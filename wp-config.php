<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'PI3R0QREV6');

/** MySQL database username */
define('DB_USER', 'abc');

/** MySQL database password */
define('DB_PASSWORD', 'asfcvdiHIs8w9821####');

/** MySQL hostname */
define('DB_HOST', '5.63.157.34:80');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'mya`oNEcI6|%(A(j7QS4gk26;|5-kF,@2;]eH1 C[b1wySPXS=S#JW?]=7s*oXw7');
define('SECURE_AUTH_KEY',  'a%#8x|y 5>97>,2hB^+%kGC#-(M-G !Mj,e)Ez*9,G2IOdKzR!74}sZv$%3M)Hc)');
define('LOGGED_IN_KEY',    ']G[jE&K%R(VfHGyt-{14Yw~wEE^$`yeN)7W%)]t+o,Q?O-|m<cg:+B];t~M(Gi{|');
define('NONCE_KEY',        '[sHqt!cD)fWmKD#.MU IhXC(1*kn*{ABJyf| >_-ZW_a0FON(CV7fOp*lb>NqBT8');
define('AUTH_SALT',        'n|-ACg[k.ij0O;_zXeBt#Q|0=[e/$o-DF|(k9;b ^8%bL5C>G}+ZVspP;|GLMBhh');
define('SECURE_AUTH_SALT', 'qo_B)A1r(D%6|Fk>B:)z*O:5vuo|Syn$.]uHF%5lIR_p%|n:b|PP$jBR/3d|/!)^');
define('LOGGED_IN_SALT',   'k95Vatjf*VO%%=9Xq[SU:V]h/b@kpM1CyJ*KkS>FtNv~<`qy0>Ut#^-)/X`96-6{');
define('NONCE_SALT',       '* <)8$};I0|)v N>I6oZBfHKS4k&9+h:m.@JKHFx{D 7m2Z*a! oj^nkNnU<=LeF');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

/**
 * Include tweaks requested by hosting providers.  You can safely
 * remove either the file or comment out the lines below to get
 * to a vanilla state.
 */
if (file_exists(ABSPATH . 'hosting_provider_filters.php')) {
	include('hosting_provider_filters.php');
}
