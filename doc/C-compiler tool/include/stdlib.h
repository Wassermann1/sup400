/*****************************************************************************/
/*                                                                           */
/*				   stdlib.h				     */
/*                                                                           */
/*			       General utilities			     */
/*                                                                           */
/*                                                                           */
/*                                                                           */
/*****************************************************************************/

#ifndef _STDLIB_H
#define _STDLIB_H

/* size_t is needed */
#ifndef _HAVE_size_t
typedef unsigned size_t;
#define _HAVE_size_t
#endif

/* Standard exit codes */
#define EXIT_SUCCESS	0
#define EXIT_FAILURE	1

/* Return type of the div function */
typedef struct {
    int rem;
    int quot;
} div_t;

/* Memory management */
void* __fastcall__ malloc (size_t size);		//Allocates memory blocks
void* __fastcall__ calloc (size_t count, size_t size);	//Allocates an array in memory with elements initialized to 0
void* __fastcall__ realloc (void* block, size_t size);	//Reallocate memory blocks
void __fastcall__ free (void* block);		//Deallocates or frees a memory block

/* Non standard memory management functions */

void __fastcall__ _heapadd (void* mem, size_t size);	//Add a block to the heap

size_t __fastcall__ _heapmemavail (void);	//Return the total free heap space

size_t __fastcall__ _heapmaxavail (void);	//Return the size of the largest free block on the heap

/* Random numbers */
#define	RAND_MAX   	0x7FFF
int rand (void);		//Generates a pseudorandom number
void __fastcall__ srand (unsigned seed);	//Sets a random starting point
void _randomize (void);

/* Other standard stuff */
void abort (void);		//Aborts the current process and returns an error code
int __fastcall__ abs (int val);	//Calculates the absolute value
long __fastcall__ labs (long val);	//Calculates the absolute value of a long integer
int __fastcall__ atoi (const char* s);	//Convert strings to integer
long __fastcall__ atol (const char* s);	//Convert strings to long
int __fastcall__ atexit (void (*exitfunc) (void));	//Processes the specified function at exit
void* __fastcall__ bsearch (const void* key, const void* base, size_t n,
	                    size_t size, int (*cmp) (const void*, const void*));	//Performs a binary search of a sorted array
div_t __fastcall__ div (int numer, int denom);	//Computes the quotient and the remainder of two integer values
void __fastcall__ exit (int ret);	//Terminate the calling process after cleanup
char* __fastcall__ getenv (const char* name);	//Get a value from the current environment
void __fastcall__ qsort (void* base, size_t count, size_t size,
	                 int (*compare) (const void*, const void*));	//Performs a quick sort
int system (const char* s);	//Execute a command

/* Non-ANSI functions */
void __fastcall__ _swap (void* p, void* q, size_t size);
#ifndef __STRICT_ANSI__
char* __fastcall__ itoa (int val, char* buf, int radix);		//Convert an integer to a string
char* __fastcall__ utoa (unsigned val, char* buf, int radix);	//Convert an unsigned integer to a string
char* __fastcall__ ltoa (long val, char* buf, int radix);		//Convert a long to a string
char* __fastcall__ ultoa (unsigned long val, char* buf, int radix);	//Convert a unsigned long to a string
#endif



/* End of stdlib.h */
#endif



