// Lab 3 template file
.data

.global login_name
login_name:
    .asciz "chris268"

.global puid
puid:
    .asciz "324443541"

.balign 4

.equ TEST_SORT,         0x1
.equ TEST_STRCONCAT,    0x2
.equ TEST_FIB,          0x4
.equ TEST_BSEARCH,      0x8
.equ TEST_ALL,          (TEST_SORT | TEST_STRCONCAT | TEST_FIB | TEST_BSEARCH)

// Replace the TEST_ALL with the tests you want to run
// OR expression also support like the TEST_ALL above
// i.e. replace the TEST_ALL below with TEST_SORT | TEST_STRCONCAT
//      will test on the sort and strconcat
.global test
test:
    .word TEST_BSEARCH


// Align to 4bytes boundary as we have a string above
.balign 4

.text
.global asm_sort_int
asm_sort_int:
    /* void asm_sort_int(int64_t* arr, uint64_t n)
     * relies on `qsort` in C standard library to 
     * sort in ascending order
     **/

    /* Enter your code after this comment */
	sub sp, sp, #16 //allocate 16 bytes
	str lr, [sp] //store lr to sp
	mov x2, #8
	ldr x3, =asm_cmp
	bl qsort
	ldr lr, [sp] //load lr from sp
	add sp, sp, #16 //deallocating the 16 bytes
    /* Enter your code above this comment */
    ret

.global asm_cmp
asm_cmp:
    // int asm_cmp(const void * a, const void * b)
    // Compare function to int64_t
    // used for qsort
    /* Enter your code after this comment */
	ldr x0, [x0]
	ldr x1, [x1]
	sub x2, x0, x1
	cmp x2, #0
	B.LT _ifthen
	mov x0, #1
	B brk
	_ifthen:
		mov x0, #-1
	//_ifthen:
	brk:

    /* Enter your code above this comment */
    ret

.global asm_strconcat
asm_strconcat:
    /* char* asm_strconcat(char * str1, char * str2)
     * First assign memory space with `malloc`, 
     * concatenating `str1` and `str2`, 
     * and return the resulted string.
     **/
    /* Enter your code after this comment */
//	sub sp, sp, #16
//	str x1, [sp]
//	bl strlen
//	mov x2, x0
//	ldr x0, [sp]
//	str x2, [sp]
//	bl strlen
//	mov x4, x0


	sub sp, sp, #48
	str x19, [sp] //preserved registers
	str x20, [sp, #8]
	str lr, [sp, #16]
	str x21, [sp, #24]
	str x22, [sp, #32]

	mov x21, x0
	mov x22, x1
	mov x19, x1

	bl strlen
	mov x23, x0
	mov x20, x0
	mov x0, x19
	bl strlen
	mov x24, x0

	mov x1, x20
	mov x2, x0

	add x1, x1, #1
	add x0, x1, x2
	str x0, [sp, #24]

	bl malloc

	mov x1, x21
	mov x2, x23
	bl memcpy

	add x0, x0, x23
	mov x1, x22
	mov x2, x24
	bl memcpy

	sub x0, x0, x23
	ldr x1, [sp, #24]
	sub x1, x1, #1
	mov x3, #0
	strb w3, [x0, x1]  //sorting at index

	ldr lr , [sp, #16]
	ldr x19, [sp]
	ldr x20, [sp, #8]
	ldr x21, [sp, #24]
	ldr x22, [sp, #32]

	add sp, sp, #48

    /* Enter your code above this comment */
    ret

.global asm_fib
asm_fib:
    /* uint64_t asm_fib(uint64_t n)
     * accept an index term `n` and return 
     * the Fn fibonacci term (F0 = 0, F1 = 1)
     **/

    /* Enter your code after this comment */
	sub sp, sp, #16
	str lr, [sp]
	str x0, [sp, #8]
	cmp x0, #2
	B.LT _if
	sub x0, x0, #1

	bl asm_fib
	ldr x1, [sp, #8]
	str x0, [sp, #8]
	sub x0, x1, #2
	bl asm_fib
	ldr x1, [sp, #8]
	add x0, x1, x0
	_if:

	ldr lr, [sp]
	add sp, sp, #16
    /* Enter your code above this comment */
    ret

.global asm_bsearch
asm_bsearch:
    /* int64_t asm_bsearch(int *arr, int key, 
                    int64_t start,
                    int64_t end)
     * Return the index of the element in the array
     * if the element does not exist, return -1 instead
     * arr: integer array to be searched
     * key: the element we want to search on
     * start: start index of subarray, inclusive
     * end: end index of subarray, inclusiveloop through an entire string and only convert
     **/

    /* Enter your code after this comment */

//    sub sp, sp, #64
//    str lr, [sp]
//    str x0, [sp, #8]
//    str x1, [sp, #16]
//    str x2, [sp, #24]
//    str x3, [sp, #32]
//	cmp x2, x3
//	B.GT _greater
//	b _else
//	_greater:
//		mov x0, #-1
//		b _end
//	_else:
//		ldr x19, [sp, #24] //start
//    	ldr x20, [sp, #32] //end
//		add x1, x19, x20 // add
//		asr x1, x1, #1 //div
//		str x1, [sp, #40] //store mid
//		ldr x21, [sp, #8] //get pointer
//		ldr w22, [x21, x1,lsl#2] //get value
//		str x22, [sp, #48] // arr[mid]
//		ldr x23, [sp, #16] //get key
//		cmp x22, x23
//		B.LT _lt
//		B _el
//		_elif:
//			ldr x0, [sp, #8]
//			ldr x1, [sp, #16]
//			ldr x2, [sp, #40]
//			add x2, x2, #1
//			ldr x3, [sp, #32]
//			bl asm_bsearch
//			B _end
//		_el:
//			ldr x0, [sp, #48]
//			ldr x1, [sp, #16]
//			cmp x0, x1
//			B.LT _elif
//			ldr x0, [sp, #40]
//			b _end
//		_lt:
//			// write return
//			ldr x0, [sp, #8]
//			ldr x1, [sp, #16]
//			ldr x2, [sp, #24]
//			ldr x3, [sp, #40]
//			sub x3, x3, #1
//			bl asm_bsearch
//			b _end
//		_end:
//			ldr lr, [sp]
//			add sp, sp, #64


	sub sp, sp, #16
	str lr, [sp]
	str x19, [sp, #8]

	cmp x2, x3
	B.LE _else
	_if1:
		mov x0, #-1
		b _end
	_else:
		add x19, x2, x3
		asr x19, x19, #1

		ldr w4, [x0, x19, lsl#2]
		cmp w4, w1
		B.LT _if2
		b _el1

		_if2:
			add x2, x19, #1
			bl asm_bsearch
			b _end
		_el1:
			cmp w4, w1
			B.GT _aelif
			mov x0, x19
			b _end
		_aelif:
			sub x3, x19, #1
			bl asm_bsearch
			b _end

	_end:
		ldr lr, [sp]
		ldr x19, [sp, #8]
		add sp, sp, #16

    /* Enter your code above this comment */
    ret
