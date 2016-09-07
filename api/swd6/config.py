import os
from oslo_config import cfg

CONF = cfg.CONF


def load(args, default_config_files=None):
    CONF(args, project='swd6', default_config_files=default_config_files)


def get_host_from_env():
    host = os.environ.get('API_HOST', 'localhost')
    port = os.environ.get('API_PORT')
    if port:
        return '{}:{}'.format(host, port)

    return host


######################################################################
# DB options
######################################################################

db_group = cfg.OptGroup(name='db',
                        title='Configs for the database connection.')

CONF.register_group(db_group)

db_opts = [
    cfg.StrOpt('uri',
               default='postgresql://swd6:swd6@db:5432/swd6',
               help='Database connection string.'),
]

CONF.register_opts(db_opts, group=db_group)

######################################################################
# API options
######################################################################

api_group = cfg.OptGroup(name='api',
                         title='Configs for the database connection.')

CONF.register_group(api_group)

api_opts = [
    cfg.StrOpt('host',
               default=get_host_from_env(),
               help='URL to the API host (i.e. localhost:8080).'),
    cfg.StrOpt('path',
               default='/api',
               help='Path where the root endpoint resides.'),
    cfg.ListOpt('cors_hosts',
                default=['http://localhost:9090'],
                help='Paths that we should allow cross-origin requests from.'),
]

CONF.register_opts(api_opts, group=api_group)
