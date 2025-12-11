/*****************************************************************************/
/*                                                                           */
/*				   string.h				     */
/*                                                                           */
/*				String handling				     */
/*                                                                           */
/*                                                                           */
/*                                                                           */
/*                                                                           */
/*****************************************************************************/
#ifndef _STRING_H
#define _STRING_H

#include <stddef.h>

char* __fastcall__ strcat (char* dest, const char* src);	//Append a string
char* __fastcall__ strchr (const char* s, int c);			//Find a character in a string
int __fastcall__ strcmp (const char* s1, const char* s2);	//Compare strings
int __fastcall__ strcoll (const char* s1, const char* s2);	//Compare strings using locale-specific information
char* __fastcall__ strcpy (char* dest, const char* src);	//Copy a string
size_t __fastcall__ strcspn (const char* s1, const char* s2);	//Find a substring in a string
char* __fastcall__ strerror (int errcode);
size_t __fastcall__ strlen (const char* s);		//Get the length of a string
char* __fastcall__ strncat (char* s1, const char* s2, size_t count);	//Append characters of a string
int __fastcall__ strncmp (const char* s1, const char* s2, size_t count);	//Compare characters of two strings
char* __fastcall__ strncpy (char* dest, const char* src, size_t count);		//Copy characters of one string to another
char* __fastcall__ strrchr (const char* s, int c);		//Scan a string for the last occurrence of a character
size_t __fastcall__ strspn (const char* s1, const char* s2);	//Find the first substring
char* __fastcall__ strstr (const char* str, const char* substr);	//Find a substring
char* strtok (char* s1, const char* s2);		//Find the next token in a string
size_t strxfrm (char* s1, const char* s2, size_t count);	//Transform a string based on locale-specific information
void* __fastcall__ memchr (const void* mem, int c, size_t count);	//Finds characters in a buffer
int __fastcall__ memcmp (const void* p1, const void* p2, size_t count);	//Compare characters in two buffers
void* __fastcall__ memcpy (void* dest, const void* src, size_t count);	//Copies characters between buffers
void* __fastcall__ memmove (void* dest, const void* src, size_t count);	//Moves one buffer to another
void* __fastcall__ memset (void* s, int c, size_t count);	//Sets buffers to a specified character

/* The following is an internal function, the compiler will replace memset
 * with it if the fill value is zero. Never use this one directly!
 */
void* __fastcall__ _bzero (void* ptr, size_t n);

/* Non standard: */
#ifndef __STRICT_ANSI__
void __fastcall__ bzero (void* ptr, size_t n);                /* BSD */
char* __fastcall__ strdup (const char* s);		      /* SYSV/BSD */
int __fastcall__ stricmp (const char* s1, const char* s2);    /* DOS/Windows */
int __fastcall__ strcasecmp (const char* s1, const char* s2); /* Same for Unix */
char* __fastcall__ strlwr (char* s);		//Convert a string to lowercase
char* __fastcall__ strlower (char* s);
char* __fastcall__ strupr (char* s);		//Convert a string to uppercase
char* __fastcall__ strupper (char* s);
#endif

const char* __fastcall__ _stroserror (unsigned char errcode);
/* Map an operating system error number to an error message. */

/* End of string.h */
#endif



