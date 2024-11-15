#!/usr/bin/bash
# --------------------------
# WordPress Update
# Author: Joseph Yap (modified by Byron for updating)


# Logging
Update_LOG="/var/log/wpupdate.log"
# WordPress Installation Path
WPROOT="/var/www"

# Timezone and datetime used for backup file prefix
CURRTIME=$(TZ="America/New_York" date +"%Y-%m-%d_%H-%M")

# Ensure WPROOT Directory Exists
[ ! -d "$WPROOT" ] && { echo "Error: WPROOT directory $WPROOT does not exist."; exit 1; }

# Check if wp CLI installed
command -v wp >/dev/null 2>&1 || { echo >&2 "Error: wp-cli command not found. Please install wp-cli to use this script.."; exit 1; }

# Create array of domains listed in $WPROOT
SITELIST=( $(find "$WPROOT" -maxdepth 1 -type d -exec basename {} \;) )

for SITE in "${SITELIST[@]}"; do
    echo "Updating $SITE"
	echo "Updating $SITE" >> "$Update_LOG"
    if [ ! -e "$WPROOT/$SITE/wp-config.php" ]; then
        echo "Warning: wp-config.php not found in $WPROOT/$SITE/. Skipping $SITE."
        continue
    fi

    cd "$WPROOT/$SITE/htdocs" || { echo "Error: Failed to cd into $WPROOT/$SITE/htdocs. Skipping $SITE."; continue; }
    wp plugin update --all --allow-root
    wp core update --allow-root

	# Successful update message
	echo "$(date) - Update of $SITE completed successfully" >> "$Update_LOG"
done
