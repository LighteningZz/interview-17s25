# 3rd Exam
## Question 
#### 3. เขียนโปรแกรมเพื่อแสดงผลลัพท์ตามรูป โดยสามารถกำหนด input ที่จะแสดงผลได้ดังต่อไปนี้
- ตัวอักษรที่จะแสดง (ตามตัวอย่างคือ “1”)
- จำนวนตัวอักษรที่มากสุดที่จะแสดง (ตามตัวอย่างคือ 4 ตัว)
- จำนวนรอบของการแสดง (ตามตัวอย่างคือ 3รอบ)
### expect 

|   input | output  |
|   --- | ---    |
| 1,4,3 |   1   |
|   |   1   |
|   |   11  |
|   |   111 |
|   |   1111    |
|   |   111 |
|   |   11  |
|   |   1   |
|   |   1   |
|   |   11  |
|   |   111 |
|   |   1111    |
|   |   111 |
|   |   11  |
|   |   1   |
|   |   1   |
|   |   11  |
|   |   111 |
|   |   1111    |
|   |   111 |
|   |   11  |
|   |   1   |

### How to run this test 
#### This test have 3 version 
- [demo](https://8e359278.interview-17s25.pages.dev/3rd-question)
- file 3rd-question.html
- console with non-interactive fix input 1,4,3
- console with interactive

### file [3rd-question.html](./3rd-question.html)


### Console with non-interactive fix input 1,4,3
- test with node v22.17.0 
```
node .\console.js
```
output
```
1
11
111
1111
111
11
1
1
11
111
1111
111
11
1
1
11
111
1111
111
11
1
```

### Console with interactive version
- require node v17+ for readline module
- test with node v22.17.0 
```
node .\console-with-interactive.js
```
input
```
display value : 1
character length : 4
loop length : 3
```
output
```
1
11
111
1111
111
11
1
1
11
111
1111
111
11
1
1
11
111
1111
111
11
1
```