import logging

import pytest
from sqlalchemy.orm import exc as sqla_orm_exc

from swd6 import config
from swd6.db import models

CONF = config.CONF
LOG = logging.getLogger(__name__)


def test_races_api(api_client, test_attribute, test_planet):
    race_post_data = {
        'data': {
            'type': 'races',
            'attributes': {
                'name': 'Test Race',
                'description': 'Test Race Description',
            },
            'relationships': {
                'planet': {
                    'data': {
                        'type': 'planets',
                        'id': test_planet.id,
                    },
                },
            },
        },
    }

    race_json = api_client.post(path='races', data=race_post_data)

    race_attribute_post_data = {
        'data': {
            'type': 'race_attributes',
            'attributes': {
                'min_level': 1.2,
                'max_level': 4.1,
            },
            'relationships': {
                'race': {
                    'data': {
                        'type': 'races',
                        'id': race_json['data']['id'],
                    },
                },
                'attribute': {
                    'data': {
                        'type': 'attributes',
                        'id': test_attribute.id,
                    },
                },
            },
        },
    }

    race_attribute_json = api_client.post(path='race_attributes', data=race_attribute_post_data)

    race_obj = models.Race.query.filter_by(id=race_json['data']['id']).one()

    race_endpoint = "{}/{}".format('races', race_obj.id)

    for key, val in race_post_data['data']['attributes'].items():
        assert getattr(race_obj, key) == val

    assert race_obj.planet_id == test_planet.id

    race_attribute_obj = race_obj.race_attributes[0]
    race_attribute_endpoint = "{}/{}".format('races', race_attribute_obj.id)
    assert race_attribute_obj.attribute_id == test_attribute.id

    assert race_attribute_obj.id == race_attribute_json['data']['id']
    for key, val in race_attribute_post_data['data']['attributes'].items():
        assert float(getattr(race_attribute_obj, key)) == val

    race_json = api_client.get(path=race_endpoint)
    assert race_json['data']['id'] == race_obj.id

    for key, val in race_post_data['data']['attributes'].items():
        assert race_json['data']['attributes'][key] == val

    api_client.delete(path=race_attribute_endpoint)

    with pytest.raises(sqla_orm_exc.NoResultFound):
        models.RaceAttribute.query.filter_by(id=race_attribute_json['data']['id']).one()

    api_client.delete(path=race_endpoint)

    with pytest.raises(sqla_orm_exc.NoResultFound):
        models.Race.query.filter_by(id=race_json['data']['id']).one()
