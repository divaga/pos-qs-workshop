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

### Create aggregate View

Create this view

```
create view public.realisasi_alokasi as 
select a.provinsi, a.nama_kota, a.latitude, a.longitude,
b.nama_penerima, b.jumlah_realisasi, c.jumlah_alokasi
from
kota a, realisasi b, alokasi c
where a.nama_kota = b.nama_kota
and b.nama_kota = c.nama_kota;
```

### Allow access 

Edit this file in PostgreSQL host:
```
sudo su - postgres 
vi /var/lib/pgsql/data/pg_hba.conf
```
and allow all IP address
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


### Security Group
Create new Security Group for QuickSight and allow All TCP from 0.0.0.0/00. Note down Security Group ID

Modify PostgreSQL EC2 Security Group and allow port 5432 from QuickSight Security Group

### Configure QuickSight
Sign up to QuickSight 

Change to correct Region then go to Manage QuickSight -> Manage VPC Connection -> Add VPC Connection. Fill in name, VPC, subnet and Security Group ID

Create new dataset, choose PostgreSQL and create new connection using VPC connection and disable SSL connection


### Create visualization

#### Map Visualization
Choose longitude, latitude and jumlah_realisasi

#### Realisasi vs Alokasi
Create new calculated field 
```
sumOver
(
     sum({jumlah_alokasi}), 
     [{provinsi}]
) 
```

Add those calculated field to visual and change chart type to Vertical Stacked 100% Bar Chart
