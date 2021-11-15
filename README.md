# QS Workshop

QuickSight with Map visualization


### Install PostgreSQL as data source

Create EC2 using Amazon Linux 2 AMI, use t3.small and use default VPC and open port 22 for SSH


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
git clone https://github.com/divaga/pos-qs-workshop.git
cd pos-qs-workshop/
psql posindo -f create_table.sql
psql posindo -f insert_data.sql
```

### Allow access 

Edit this file in PostgreSQL host:
```
sudo su - postgres 
vi /var/lib/pgsql/data/pg_hba.conf
```
and allow your DMS IP address
```
# IPv4 local connections:
host all all 0.0.0.0/00 md5
```
and also this file:
```
vi /var/lib/pgsql/data/postgresql.conf
```

change:
```
listen_addresses = '*'

```

Restart as ec2-user
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

### Security Group
Create new Security Group for QuickSight and allow All TCP from 0.0.0.0/00. Note down Security Group ID

Modify PostgreSQL EC2 Security Group and allow port 5432 from QuickSight Security Group

### Configure QuickSight
Sign up to QuickSight 

Change to correct Region then go to Manage QuickSight -> Manage VPC Connection -> Add VPC Connection. Fill in name, VPC, subnet and Security Group ID

Create new dataset, choose PostgreSQL and create new connection using VPC connection and disable SSL connection



Create visualization
