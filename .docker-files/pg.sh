set +x

# Add PostgreSQL to sources list
#curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
#  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

# Install PostgreSQL client and libs
#apt-get update -qq && \
#  DEBIAN_FRONTEND=noninteractive apt-get install -yq libpq-dev \
#  postgresql-client-$PG_MAJOR


# Create the file repository configuration:
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Update the package lists:
apt-get update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
apt-get -yq install postgresql