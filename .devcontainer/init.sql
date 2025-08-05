-- Initialize Backstage databases
CREATE DATABASE backstage_plugin_catalog;
CREATE DATABASE backstage_plugin_auth;
CREATE DATABASE backstage_plugin_scaffolder;

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE backstage_plugin_catalog TO backstage;
GRANT ALL PRIVILEGES ON DATABASE backstage_plugin_auth TO backstage;
GRANT ALL PRIVILEGES ON DATABASE backstage_plugin_scaffolder TO backstage;