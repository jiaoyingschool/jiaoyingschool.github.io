<?php
/** Enable W3 Total Cache */
define('WP_CACHE', true); // Added by W3 Total Cache

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
define('DB_NAME', 'wordpress_d7de2na7mk');

/** MySQL database username */
define('DB_USER', 'xSctmJKlVaECoPN');

/** MySQL database password */
define('DB_PASSWORD', 'qvejoZhz23s18u2B');

/** MySQL hostname */
define('DB_HOST', 'jiaoying.ipowermysql.com');

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
define('AUTH_KEY', 'nvmmGWpqdyP%YUr+O!s@bR/z?-+vIuueX+bNR&?gPVX!?F;Y?Ni<^QiSYtyP?xd]-HN^N&<vi;TI*e!]*RtPi;y%/{EH&]X++Z|@z{dTSOtsumbmVoLjyOBf-{Y!bMT%');
define('SECURE_AUTH_KEY', 'fBz(mQ)i@&Cycxl(cPPpW@uFmqQRtLo?GMiVnYUA=n;D<Gfpm>jGYwmf-;j;FMZ*T$_tf?{nTaO[GAXvejfsa>o>!nvit{*Tkb%%wM&zI!(<TIB%A{I_G(DSIz&^Gjpd');
define('LOGGED_IN_KEY', 'G*rboQRnxwtxuOV%DEvrL%)_<^|X&a^Kakr>%qoI+CBopP_)giNSvMKnpg]akc$({m_/eyZrNvMXpdVY][IDDLWW_@mD)Lsb-rB&fCam(D?s*YYU+]xnkD%)*Au{ENVh');
define('NONCE_KEY', 'R-{OJkb[%_J<=xRDchZfKoeCmDwaV&Acv|dEFzJVzC@^*UuqQzngXm_TJm=evES@<^<]+dU;J<]*-UeRGZ]G>olxy&IiJ<hmY-F-xVEpAp-k>|cU{n!^ugs-@KP-Pi^+');
define('AUTH_SALT', '};qKFMSR=BNuPo_E@[_JCvS!wJc?<b}jSkXM>Ag(-@%h^wUyEL;N^K<vVg<&nIF?Y&!-ksbCOydLrFd-fsRaqyu[qHY{UyncMHoRmZjFxc+|ED^!h;/RDofTxZgI^VOp');
define('SECURE_AUTH_SALT', 'E$sb{^j)q<c*RVRZJB@kppiqk+SQUm[O&}ZQAhp(tmxwV^!tV)ir{UTF[^nT?-EP_ZUGag{[nCK[Ye+[buc<z[q}Z!KsVR*=KxGRF(O-)y[zwo[[fZDXWUEQ]FUQhfi$');
define('LOGGED_IN_SALT', 'R?_W%K;Hk*V&TX{Zbg*jKFIDLvXKIzRRVsFEVN($zf>S=pLEw<Vs|N<vM{?qAPnrI=&$Au&k[LGR/Rrg(LYa@r_T^Q%P!hrP}fbwHE@v@QU$)S-$SdRVj})QQti!+-B!');
define('NONCE_SALT', 'mstNLgXKzualdN-*r[(iL<_Et_<C]|bLWmCD-@StIR[HlU+diUjriJLBuym_?WMImrW{BQlw{O]UW<G{fPYKT&hsFDXoJiWYEuA^xRpfoMt]<eVD;{GT?W(U-lf@pK!G');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_bnsq_';

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
