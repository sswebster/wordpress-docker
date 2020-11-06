<?php

defined( 'ABSPATH' ) || exit;


class WP_MailHog {

    function __construct() {
        $this->define_constants();
        $this->init_phpmailer();
    }

    /**
     * Define constants
     *
     * @return void
     */
    public function define_constants() {

        if ( ! defined( 'WP_MAILHOG_HOST') ) {
            define( 'WP_MAILHOG_HOST', 'mailhog' );
        }

        if ( ! defined( 'WP_MAILHOG_PORT') ) {
            define( 'WP_MAILHOG_PORT', 1025 );
        }
    }

    /**
     * Override the PHPMailer SMTP options
     *
     * @return void
     */
    public function init_phpmailer() {
        add_action( 'phpmailer_init', function( $phpmailer ) {
            $phpmailer->Host     = WP_MAILHOG_HOST;
            $phpmailer->Port     = WP_MAILHOG_PORT;
            $phpmailer->SMTPAuth = false;
            $phpmailer->isSMTP();
        } );
    }
}

new WP_MailHog();
