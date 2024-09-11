// Primary write database 
$wpdb->add_database( array(
  'host'     => 'wordpress-remote-db-primary.h3h3k38sa.us-east-1.rds.amazonaws.com',     // If port is other than 3306, use host:port.
  'user'     => 'root',
  'password' => 'root',
  'name'     => 'multisite_site_odd',
  'dataset' => 'odd_sites',
  'write' => 1,
  'read' => 0
) );

// Read replica
$wpdb->add_database( array(
  'host'     => 'wordpress-remote-db-replica.h3h3k38sa.us-east-1.rds.amazonaws.com',     // If port is other than 3306, use host:port.
  'user'     => 'root',
  'password' => 'root',
  'name'     => 'multisite_site_odd',
  'dataset' => 'odd_sites',
  'write' => 0,
  'read' => 1
) );