/*****************************************************************************/
/*                                                                           */
/*				    stdio.h				     */
/*                                                                           */
/*				 Input/output				     */
/*                                                                           */
/*****************************************************************************/
#ifndef _STDIO_H
#define _STDIO_H

#ifndef _STDDEF_H
#  include <stddef.h>
#endif
#ifndef _STDARG_H
#  include <stdarg.h>
#endif

/* Types */
typedef struct _FILE FILE;
typedef unsigned long fpos_t;

/* Standard file descriptors */
extern FILE* stdin;
extern FILE* stdout;
extern FILE* stderr;

/* Standard defines */
#define _IOFBF		0
#define _IOLBF		1
#define _IONBF		2
#define BUFSIZ		256
#define EOF 	      	-1
#define FILENAME_MAX	16
#define FOPEN_MAX	8
#define L_tmpnam	(FILENAME_MAX + 1)
#define SEEK_CUR	0
#define SEEK_END	1
#define SEEK_SET	2
#define TMP_MAX		256

/*****************************************************************************/
/*     	    	     		     Code				     */
/*****************************************************************************/
void __fastcall__ clearerr (FILE* f);		//Resets the error indicator for a stream
int __fastcall__ fclose (FILE* f);			//Closes a stream		
int __fastcall__ feof (FILE* f);			//Tests for end-of-file on a stream
int __fastcall__ ferror (FILE* f);			//Tests for an error on a stream
int __fastcall__ fflush (FILE* f);			//Flushes a stream
int __fastcall__ fgetc (FILE* f);			//Read a character from a stream 
char* __fastcall__ fgets (char* buf, size_t size, FILE* f);		//Get a string from a stream
FILE* __fastcall__ fopen (const char* name, const char* mode);	//Open a file
int fprintf (FILE* f, const char* format, ...);		//Print formatted data to a stream
int __fastcall__ fputc (int c, FILE* f);			//Writes a character to a stream 
int __fastcall__ fputs (const char* s, FILE* f);	//Write a string to a stream		
size_t __fastcall__ fread (void* buf, size_t size, size_t count, FILE* f);	//Reads data from a stream
FILE* __fastcall__ freopen (const char* name, const char* mode, FILE* f);	//Reassign a file pointer
size_t __fastcall__ fwrite (const void* buf, size_t size, size_t count, FILE* f);	//Writes data to a stream
int __fastcall__ fgetpos (FILE* f, fpos_t *pos);	//Gets a stream¡¯s file-position indicator
int __fastcall__ fsetpos (FILE* f, const fpos_t* pos);	//Sets the stream-position indicator
long __fastcall__ ftell (FILE* f);		//Gets the current position of a file pointer
int __fastcall__ fseek (FILE* f, long offset, int whence);	//Moves the file pointer to a specified location
void __fastcall__ rewind (FILE *f);		//Repositions the file pointer to the beginning of a file
int __fastcall__ getchar (void);		//Read a character from a stream 
char* __fastcall__ gets (char* s);		//Get a line from the stdin stream
void __fastcall__ perror (const char* s);	//Print an error message
int printf (const char* format, ...);		//Print formatted output to the standard output stream
int __fastcall__ putchar (int c);			//Writes a character to a stream 
int __fastcall__ puts (const char* s);		//Write a string to stdout
int __fastcall__ remove (const char* name);	//Delete a file
int __fastcall__ rename (const char* oldname, const char* newname);	//Rename a file or directory
int sprintf (char* buf, const char* format, ...);	//Write formatted data to a string
int __fastcall__ vfprintf (FILE* f, const char* format, va_list ap);	//Write formatted output using a pointer to a list of arguments
int __fastcall__ vprintf (const char* format, va_list ap);		//Write formatted output using a pointer to a list of arguments		
int __fastcall__ vsprintf (char* buf, const char* format, va_list ap);	//Write formatted output using a pointer to a list of arguments

/* Not available or testing: */
int scanf (const char* format, ...);
int fscanf (FILE* f, const char* format, ...);
int sscanf (const char* s, const char* format, ...);
int __fastcall__ vscanf (const char* format, va_list ap);
int __fastcall__ vsscanf (const char* s, const char* format, va_list ap);
int __fastcall__ vfscanf (FILE* f, const char* format, va_list ap);

/* Masking macros for some functions */
#define getchar()   	fgetc (stdin)		/* ANSI */
#define putchar(c)  	fputc (c, stdout)	/* ANSI */
#define getc(f)	       	fgetc (f)     		/* ANSI */
#define putc(c, f)     	fputc (c, f)  		/* ANSI */

/* End of stdio.h */
#endif



							
