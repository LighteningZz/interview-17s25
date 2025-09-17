# Question
จงใช้ cursor ในการ Looping เพื่อแสดงข้อมูล CustomerName และ City จาก @tbCustomers สามารถสร้าง table จากสคริปด้านล่าง

```sql
BEGIN

DECLARE @tbCustomers table (CustomerId int,CustomerName VARCHAR(50),City VARCHAR(50))
insert into @tbCustomers (CustomerId ,CustomerName ,City ) values(1,'Alfreds Futterkiste' ,'Berlin');
insert into @tbCustomers (CustomerId ,CustomerName ,City ) values(2,'Around the Horn' ,'London');
insert into @tbCustomers (CustomerId ,CustomerName ,City ) values(3,'Blondel père et fils' ,'Strasbourg');
insert into @tbCustomers (CustomerId ,CustomerName ,City ) values(4,'Consolidated Holdings' ,'London');
insert into @tbCustomers (CustomerId ,CustomerName ,City ) values(5,'Eastern Connection' ,'London');
insert into @tbCustomers (CustomerId ,CustomerName ,City ) values(6,'Paris spécialités' ,'Paris');

END

```

## answer
tool gemini-flash

[demo on sqlfiddle](https://sqlfiddle.com/sql-server/online-compiler?id=5fc5e2c8-6eae-4034-b5e4-26193afa8e25)

```sql
-- ประกาศตัวแปรสำหรับเก็บข้อมูลแต่ละแถว
DECLARE @CustomerName VARCHAR(50);
DECLARE @City VARCHAR(50);

-- ประกาศและกำหนดค่า CURSOR
DECLARE customer_cursor CURSOR FOR
    SELECT CustomerName, City
    FROM @tbCustomers;

-- เปิดใช้งาน CURSOR
OPEN customer_cursor;

-- ดึงข้อมูลแถวแรก
FETCH NEXT FROM customer_cursor INTO @CustomerName, @City;

-- เริ่มลูปจนกว่าจะไม่มีข้อมูลให้ดึง
WHILE @@FETCH_STATUS = 0
BEGIN
    -- แสดงผลข้อมูล CustomerName และ City
    PRINT 'Customer: ' + @CustomerName + ', City: ' + @City;

    -- ดึงข้อมูลแถวถัดไป
    FETCH NEXT FROM customer_cursor INTO @CustomerName, @City;
END;

-- ปิด CURSOR
CLOSE customer_cursor;

-- ยกเลิกการใช้งาน CURSOR เพื่อคืนหน่วยความจำ
DEALLOCATE customer_cursor;

```