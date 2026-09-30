#!/usr/bin/env python3
"""Validate the content artefacts, seeded invariants and selected answer keys.

This is a documentation/content check. It does not validate a game renderer,
translation, diagram construction, learner mastery or the national exam syllabus.
No network access or third-party dependencies are used.
"""
import ast
import csv
import json
import math
import re
from collections import Counter
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DATA = json.loads((ROOT / 'blueprints.json').read_text(encoding='utf-8'))
BLUEPRINTS = DATA['blueprints']
ENV = {
    '__builtins__': {}, 'abs': abs, 'sqrt': math.sqrt, 'len': len,
    'list': list, 'tuple': tuple, 'set': set, 'range': range,
    'sum': sum, 'min': min, 'max': max, 'True': True, 'False': False,
}
ALLOWED_NODES = (
    ast.Expression, ast.Constant, ast.List, ast.Tuple, ast.Set, ast.Dict,
    ast.Name, ast.Load, ast.Store, ast.BinOp, ast.UnaryOp, ast.BoolOp,
    ast.Compare, ast.Call, ast.Attribute, ast.ListComp, ast.comprehension,
    ast.Add, ast.Sub, ast.Mult, ast.Div, ast.Mod, ast.Pow, ast.BitOr,
    ast.USub, ast.UAdd, ast.And, ast.Or, ast.Not, ast.Eq, ast.NotEq,
    ast.Lt, ast.LtE, ast.Gt, ast.GtE, ast.In, ast.NotIn,
)


def evaluate(expression):
    tree = ast.parse(expression, mode='eval')
    for node in ast.walk(tree):
        assert isinstance(node, ALLOWED_NODES), (expression, type(node).__name__)
        if isinstance(node, ast.Name):
            assert node.id in ENV or node.id in {'a', 'b'}, (expression, node.id)
        if isinstance(node, ast.Attribute):
            assert node.attr == 'issubset', (expression, node.attr)
        if isinstance(node, ast.Call):
            assert not node.keywords, expression
            assert (isinstance(node.func, ast.Name) and node.func.id in ENV) or (
                isinstance(node.func, ast.Attribute) and node.func.attr == 'issubset'
            ), expression
    return eval(compile(tree, '<authored mathematical check>', 'eval'), ENV, {})


def equivalent(left, right):
    a, b = evaluate(left), evaluate(right)
    if isinstance(a, bool) or isinstance(b, bool):
        return type(a) is type(b) and a == b
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        return math.isclose(a, b, rel_tol=1e-12, abs_tol=1e-10)
    return a == b


def triangle(sides):
    x, y, z = sorted(sides)
    return x > 0 and x + y > z


def domain_check(id, p, answer):
    """Independent domain/invariant checks for constrained seed families."""
    if id == 'f01':
        assert 1 <= p['hundreds'] <= 9 and 0 <= p['ones'] <= 9
        assert int(answer) == 100*p['hundreds']+10*p['tens']+p['ones']
    elif id == 'f02':
        assert 10 <= p['a'] % 10 + p['b'] % 10 <= 18
        assert int(answer) == p['a'] + p['b']
    elif id == 'f03':
        assert p['stock'] > p['remove'] and p['stock'] % 10 < p['remove'] % 10
        assert int(answer) + p['remove'] == p['stock']
    elif id == 'f04':
        assert 0 < p['split'] < p['columns'] and p['rows'] > 0
    elif id == 'f05':
        assert p['divisor'] != 0 and p['total'] % p['divisor'] == 0
        assert int(answer) * p['divisor'] == p['total']
    elif id == 'f06':
        assert 0 <= p['selected'] <= p['parts'] and p['parts'] > 0
    elif id == 'f07':
        assert p['b'] > 0 and p['k'] > 0
        assert Fraction(answer) == Fraction(p['a'], p['b'])
    elif id == 'f08':
        assert 0 <= p['cents'] < 100
        assert Fraction(answer) == p['birr'] + Fraction(p['cents'], 100)
    elif id == 'f09':
        assert int(answer) == p['square_metres'] * 10000
    elif id == 'g7i04':
        assert p['a'] > 0 and p['b'] > 0
        assert int(answer) == (-p['a']) * (-p['b'])
    elif id == 'g7i05':
        assert p['divisor'] != 0 and int(answer) * p['divisor'] == p['dividend']
    elif id == 'g7a04':
        assert Fraction(answer) == Fraction(p['base']*p['height'], 2)
    elif id == 'g7a06':
        assert p['long_base'] >= p['short_base'] > 0 and p['height'] > 0
        assert Fraction(answer) == Fraction((p['long_base']+p['short_base'])*p['height'], 2)
    elif id in {'g7c02', 'g8t05'}:
        assert triangle(p['sides'])
    elif id == 'g7c03':
        assert p['side1'] > 0 and p['side2'] > 0 and 0 < p['included_angle'] < 180
    elif id in {'g7c04', 'g8m02', 'g8t01'}:
        assert p['angle1'] > 0 and p['angle2'] > 0 and p['angle1']+p['angle2'] < 180
    elif id == 'g7d02':
        assert sum(p['counts']) == p['total'] and all(x >= 0 for x in p['counts'])
    elif id == 'g7d03':
        assert Fraction(answer) == Fraction(sum(p['data']), len(p['data']))
    elif id == 'g7d04':
        ordered = sorted(p['data'])
        assert Fraction(answer) == Fraction(ordered[1] + ordered[2], 2)
    elif id == 'g7d06':
        assert int(answer) == max(p['data']) - min(p['data'])
    elif id == 'g7d07':
        expected = Fraction(p['n1']*p['mean1'] + p['n2']*p['mean2'], p['n1']+p['n2'])
        assert Fraction(answer) == expected
    elif id == 'g8q04':
        assert 0 < p['a'] <= p['b'] and 0 < p['c'] <= p['d']
        assert Fraction(answer) == Fraction(p['a']*p['c'], p['b']*p['d'])
    elif id == 'g8q05':
        assert p['available_denominator'] > 0 and p['portion_numerator'] > 0 and p['portion_denominator'] > 0
        available = Fraction(p['available_numerator'], p['available_denominator'])
        portion = Fraction(p['portion_numerator'], p['portion_denominator'])
        assert Fraction(answer) * portion == available
    elif id == 'g8q06':
        assert Fraction(answer) * Fraction(p['fraction_numerator'], p['fraction_denominator']) == p['known']
    elif id == 'g8q07':
        share1, share2 = Fraction(p['share1']), Fraction(p['share2'])
        assert 0 <= share1+share2 <= 1
        assert Fraction(answer) + p['total']*(share1+share2) == p['total']
    elif id == 'g8p02':
        assert int(answer) >= 0 and int(answer)**2 == p['area']
    elif id == 'g8p03':
        assert int(answer)**2 == p['number']
    elif id == 'g8p04':
        assert 0 <= p['lower']**2 < p['N'] < p['upper']**2
    elif id == 'g8p05':
        assert int(answer)**3 == p['volume']
    elif id == 'g8l03':
        assert p['coefficient'] < 0
        boundary = Fraction(p['limit']-p['constant'], p['coefficient'])
        assert answer == f'x>{boundary}'
        assert p['coefficient']*(boundary+1)+p['constant'] < p['limit']
        assert not p['coefficient']*(boundary-1)+p['constant'] < p['limit']
    elif id == 'g8l04':
        n = int(answer)
        assert n >= 0 and p['fee']+p['unit_cost']*n <= p['budget']
        assert p['fee']+p['unit_cost']*(n+1) > p['budget']
    elif id == 'g8m03':
        assert triangle(p['small'])
        k = Fraction(p['known_large'][0], p['small'][0])
        assert Fraction(p['known_large'][1], p['small'][1]) == k
        assert Fraction(answer) == p['small'][2]*k
    elif id == 'g8t03':
        assert p['AD'] + p['DB'] == p['AB'] and p['AD'] > 0 and p['DB'] > 0
        assert math.isqrt(p['AB']*p['AD'])**2 == p['AB']*p['AD']
        assert math.isqrt(p['AB']*p['DB'])**2 == p['AB']*p['DB']
    elif id == 'g8t04':
        assert int(answer)**2 == p['a']**2 + p['b']**2
    elif id == 'g8o02':
        assert 0 <= p['distance'] < p['radius']
        assert (Fraction(answer)/2)**2 + p['distance']**2 == p['radius']**2
    elif id in {'g8o03', 'g8o04'}:
        assert 0 < p['arc_degrees'] < 360
    elif id == 'g8o05':
        assert 0 < p['arc1']+p['arc2'] < 360 and p['arc1'] > 0 and p['arc2'] > 0
        assert Fraction(answer) == Fraction(p['arc1']+p['arc2'], 2)
    elif id == 'g8v05':
        assert p['length'] > 0 and p['width'] > 0 and p['height'] > 0
        assert int(answer) == p['length']*p['width']*p['height']
    elif id == 'g8b03':
        count = sum(a+b == p['sum_target'] for a in range(1, 7) for b in range(1, 7))
        assert Fraction(answer) == Fraction(count, 36)
    elif id == 'g8b04':
        assert p['red']+p['blue'] > 0 and p['red'] >= 0 and p['blue'] >= 0
        assert Fraction(answer) == Fraction(p['red'], p['red']+p['blue'])
    elif id == 'g8b05':
        assert p['trials'] > 0 and 0 <= p['heads'] <= p['trials']


required = {
    'id', 'concept', 'source', 'prerequisites', 'interaction_model',
    'learner_goal', 'mathematical_actions', 'visible_consequence',
    'definition_debrief', 'misconception', 'transfer', 'generation', 'language',
}
ids = [b['id'] for b in BLUEPRINTS]
assert len(ids) >= 60 and len(ids) == len(set(ids))
models = [b['interaction_model'] for b in BLUEPRINTS]
assert len(models) == len(set(models))
by_id = {b['id']: b for b in BLUEPRINTS}
groups = Counter(b['group'] for b in BLUEPRINTS)
assert set(groups) == {'foundation'} | {f'g7c{i}' for i in range(1, 8)} | {f'g8c{i}' for i in range(1, 9)}
scenarios, seed_checks, transfer_checks = set(), 0, 0
for b in BLUEPRINTS:
    assert required <= set(b), b['id']
    assert 3 <= len(b['mathematical_actions']) <= 5, b['id']
    for field in ('concept', 'learner_goal', 'visible_consequence', 'definition_debrief'):
        assert isinstance(b[field], str) and b[field].strip(), (b['id'], field)
    assert b['misconception']['claim'] and b['misconception']['response']
    assert b['transfer']['question'] and b['transfer']['worked_answer']
    assert set(b['prerequisites']) <= set(ids), b['id']
    assert b['id'] not in b['prerequisites'], b['id']
    src = b['source']
    if src['grade']:
        limits = {
            'g7c1': (1,18), 'g7c2': (19,52), 'g7c3': (53,85), 'g7c4': (86,123),
            'g7c5': (124,166), 'g7c6': (167,188), 'g7c7': (189,213),
            'g8c1': (1,46), 'g8c2': (47,77), 'g8c3': (78,94), 'g8c4': (95,116),
            'g8c5': (117,144), 'g8c6': (145,168), 'g8c7': (169,199), 'g8c8': (200,221),
        }
        low, high = limits[b['group']]
        for page in map(int, re.findall(r'\d+', src['printed_pages'])):
            assert low <= page <= high or (b['group'] == 'g8c2' and 222 <= page <= 226), (b['id'], page)
    gen = b['generation']
    seeds = gen['parameter_sets']
    assert len(seeds) == 8 and len({s['seed_id'] for s in seeds}) == 8
    assert len({json.dumps(s['parameters'], sort_keys=True) for s in seeds}) == 8, b['id']
    assert {m['id'] for m in gen['challenge_modes']} == {'build', 'repair'}
    assert gen['count'] == len(seeds)*len(gen['challenge_modes']) == 16
    assert len(gen['constraints']) >= 2
    for seed in seeds:
        assert seed['checks'], (b['id'], seed['seed_id'])
        for check in seed['checks']:
            assert equivalent(check['left'], check['right']), (b['id'], seed['seed_id'], check)
            seed_checks += 1
        domain_check(b['id'], seed['parameters'], seed['expected_answer'])
        for mode in gen['challenge_modes']:
            scenario_id = f'{b["id"]}.{seed["seed_id"]}.{mode["id"]}'
            assert scenario_id not in scenarios, scenario_id
            scenarios.add(scenario_id)
    for check in b['transfer']['checks']:
        assert equivalent(check['left'], check['right']), (b['id'], check)
        transfer_checks += 1

visited, active = set(), set()
def visit(id):
    assert id not in active, ('prerequisite cycle', id)
    if id in visited:
        return
    active.add(id)
    for prerequisite in by_id[id]['prerequisites']:
        visit(prerequisite)
    active.remove(id)
    visited.add(id)
for id in ids:
    visit(id)

with (ROOT/'translation-review.csv').open(encoding='utf-8', newline='') as file:
    rows = list(csv.DictReader(file))
assert rows and len({row['id'] for row in rows}) == len(rows)
assert all(row['source_english'].strip() for row in rows)
assert all(row['review_status'] == 'unreviewed' for row in rows)
assert all(not row['proposed_afaan_oromo'] or row['id'].startswith('glossary.') for row in rows)
for b in BLUEPRINTS:
    assert any(row['id'] == b['id']+'.goal' for row in rows), b['id']
    for action in range(1, len(b['mathematical_actions'])+1):
        assert any(row['id'] == f'{b["id"]}.action.{action}' for row in rows)
assert len(scenarios) >= 1000
assert DATA['scenario_accounting']['blueprint_count'] == len(BLUEPRINTS)
assert DATA['scenario_accounting']['scenario_design_slots'] == len(scenarios)
catalogue = (ROOT/'catalogue.md').read_text(encoding='utf-8')
assert all(f'#### {id} — ' in catalogue for id in ids)
print(json.dumps({
    'result': 'passed', 'blueprints': len(BLUEPRINTS), 'chapter_groups': len(groups)-1,
    'foundations': groups['foundation'], 'seed_configurations': len(BLUEPRINTS)*8,
    'unique_scenario_design_slots': len(scenarios),
    'seeded_numeric_or_structural_checks': seed_checks,
    'worked_transfer_numeric_checks': transfer_checks,
    'translation_rows': len(rows),
    'unreviewed_proposed_glossary_terms': sum(bool(r['proposed_afaan_oromo']) for r in rows),
    'limits': 'Checks do not establish diagram/proof correctness, reviewed translation, learner mastery or renderer readiness.',
}, indent=2))
