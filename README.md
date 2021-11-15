# QS Workshop

QuickSight with Map visualization


### Install PostgreSQL as data source

Create EC2, use t3.small and use default VPC


Install postgreSQL
```
sudo yum update
sudo amazon-linux-extras enable postgresql11
sudo yum install postgresql postgresql-devel postgresql-server postgresql-contrib
sudo postgresql-setup initdb
sudo systemctl enable --now postgresql 
systemctl status postgresql
sudo yum install git
```

Configure user
```
sudo su - postgres
psql -c "alter user postgres with password 'yourstrongpassword'"
psql -c "create database posindo"
psql -c "ALTER USER postgres WITH SUPERUSER"
```

Install sample data
```
git clone https://github.com/devrimgunduz/pagila.git
cd pagila 
psql posindo -f pagila-schema.sql
psql posindo -f pagila-data.sql
```

### Allow access 

Edit this file in PostgreSQL host:
```
sudo su - postgres 
vi /var/lib/pgsql/data/pg_hba.conf
```
and allow your DMS IP address
```
# Replication Instance
host all all 12.3.4.56/00 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
host replication postgres 12.3.4.56/00 md5
```
and also this file:
```
vi /var/lib/pgsql/data/postgresql.conf
```

change:
```
listen_addresses = '*'

```

Restart
```
sudo systemctl restart postgresql
```

### Configure PG View

Create this view

```
create view actor_summary as 
select actor.first_name, actor.last_name,
count(actor.actor_id) as film_count
from actor actor ,film_actor film_actor
where actor.actor_id = film_actor.actor_id
group by actor.first_name, actor.last_name
```

### Configure QuickSight
Sign up to QuickSight 

Gave S3 access 

Enable QuickSight access to Athena and S3

Add Athena as data source and disable SPICE

Create visualization
