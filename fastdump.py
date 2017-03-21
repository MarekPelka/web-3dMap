import csv
import os
import time
from warnings import filterwarnings
import MySQLdb
filterwarnings('ignore', category = MySQLdb.Warning)
"""
CREATE TABLE `test` (
 `data_id` int(11) NOT NULL AUTO_INCREMENT,
 `square_id` int(11) NOT NULL,
 `time` bigint(11) NOT NULL,
 `country_code` varchar(20) NOT NULL,
 `sms_in` double NOT NULL,
 `sms_out` double NOT NULL,
 `call_in` double NOT NULL,
 `call_out` double NOT NULL,
 `internet_traffic` double NOT NULL,
 PRIMARY KEY (`data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=232157455 DEFAULT CHARSET=latin1
"""
mydb = MySQLdb.connect(host='localhost',
    user='root',
    passwd='',
    db='skru')

t0 = time.time()
print "Start\n\t0%"

cursor = mydb.cursor()
#cursor.execute('TRUNCATE TABLE `skru`.`test2`')
cursor.execute('LOAD DATA LOCAL INFILE "tst.txt" INTO TABLE `skru`.`test2` CHARACTER SET latin2 FIELDS TERMINATED BY "	" LINES TERMINATED BY "\n" (`square_id`, `time`, `country_code`, `sms_in`, `sms_out`, `call_in`, `call_out`, `internet_traffic`)')
mydb.commit()
cursor.close()

t1 = time.time()
time = t1 - t0
print "\t100%\nDone in: " + str(time)

"""
TRUNCATE TABLE `skru`.`test1`;
LOAD DATA LOCAL INFILE 'C:\\Users\\Marek\\Documents\\Programowanie\\Python\\tst.txt' INTO TABLE `skru`.`test1` CHARACTER SET latin2 FIELDS TERMINATED BY '	' LINES TERMINATED BY '\n' (`square_id`, `time`, `country_code`, `sms_in`, `sms_out`, `call_in`, `call_out`, `internet_traffic`);
/* 22 rows imported in 0,046 seconds. */
SHOW WARNINGS;
"""