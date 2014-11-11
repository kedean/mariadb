# Prepare Configuration File
audit_plugin_options = {}

audit_plugin_options['comment1'] = '#'
audit_plugin_options['comment2'] = '# * MariaDB Audit Plugin'
audit_plugin_options['comment3'] = '#'

audit_plugin_options['server_audit_events'] = \
  node['mariadb']['audit_plugin']['server_audit_events']
audit_plugin_options['server_audit_output_type'] = \
  node['mariadb']['audit_plugin']['server_audit_output_type']
audit_plugin_options['server_audit_syslog_facility'] = \
  node['mariadb']['audit_plugin']['server_audit_syslog_facility']
audit_plugin_options['server_audit_syslog_priority'] = \
  node['mariadb']['audit_plugin']['server_audit_syslog_priority']

audit_plugin_options['enable'] = '#server_audit_logging = ON'

# Create Configuration File
mariadb_configuration 'audit_plugin' do
  section 'mysqld'
  option audit_plugin_options
  action :add
end

# Install the MariaDB Audit Plugin
execute 'install_mariadb_audit_plugin' do
  command '/usr/bin/mysql -e"INSTALL PLUGIN server_audit ' + \
  'SONAME \'server_audit\';"'
end

# Configure (Dynamic)
execute 'configure_mariadb_audit_plugin' do
  command 'echo "SET GLOBAL server_audit_events=\'' + \
    node['mariadb']['audit_plugin']['server_audit_events'] + '\';' \
    'SET GLOBAL server_audit_output_type=\'' + \
    node['mariadb']['audit_plugin']['server_audit_output_type'] + '\';' \
    'SET GLOBAL server_audit_syslog_facility=\'' + \
    node['mariadb']['audit_plugin']['server_audit_syslog_facility'] + '\';' \
    'SET GLOBAL server_audit_syslog_priority=\'' + \
    node['mariadb']['audit_plugin']['server_audit_syslog_priority'] + '\';"' \
    '| /usr/bin/mysql'
end
