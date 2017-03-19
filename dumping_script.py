import csv
import MySQLdb
import os

mydb = MySQLdb.connect(host='localhost',
    user='grzegorz',
    passwd='123456',
    db='skru')


for i in range(1,30):
    cursor = mydb.cursor()
    csv_data = csv.reader(file('sms-call-internet-mi-2013-11-'+str(i).zfill(2)+'.txt'))
    fileSize = os.path.getsize('sms-call-internet-mi-2013-11-'+str(i).zfill(2)+'.txt')
    progress = 0
    progressPercent = (1.0*progress)/fileSize
    lastProgressPercent = progressPercent

    for row in csv_data:
        if len(row[0])==0:
            continue
        progress = progress + len(row[0])
        progressPercent = (1.0*progress)/fileSize
        if int(lastProgressPercent*100) != int(progressPercent*100):
            print str(int(progressPercent*100)) + '%'
            lastProgressPercent = progressPercent
        rowtab = row[0].split('\t')
        cursor.execute('INSERT INTO test(data_id,square_id,time,country_code,sms_in,sms_out,call_in,call_out,internet_traffic)' \
              'VALUES(NULL,(%s * 1), (%s * 1), "%s",%s + 0.0 ,%s + 0.0,%s + 0.0,%s + 0.0,%s + 0.0)', rowtab)
    mydb.commit()
    cursor.close()
    print "Done" + str(i) + "/30"