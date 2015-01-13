
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 f7 03 00 00       	call   405 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 7f 04 00 00       	call   49d <sleep>
  exit();
  1e:	e8 ea 03 00 00       	call   40d <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	89 04 24             	mov    %eax,(%esp)
  5b:	e8 ba 00 00 00       	call   11a <strlen>
  60:	83 e8 01             	sub    $0x1,%eax
  63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  66:	eb 39                	jmp    a1 <reverse+0x59>
         c = s[i];
  68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  6b:	8b 45 08             	mov    0x8(%ebp),%eax
  6e:	01 d0                	add    %edx,%eax
  70:	0f b6 00             	movzbl (%eax),%eax
  73:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
  76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  79:	8b 45 08             	mov    0x8(%ebp),%eax
  7c:	01 c2                	add    %eax,%edx
  7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  81:	8b 45 08             	mov    0x8(%ebp),%eax
  84:	01 c8                	add    %ecx,%eax
  86:	0f b6 00             	movzbl (%eax),%eax
  89:	88 02                	mov    %al,(%edx)
         s[j] = c;
  8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8e:	8b 45 08             	mov    0x8(%ebp),%eax
  91:	01 c2                	add    %eax,%edx
  93:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  97:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  99:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  9d:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  a7:	7c bf                	jl     68 <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
  a9:	c9                   	leave  
  aa:	c3                   	ret    

000000ab <strcpy>:

char*
strcpy(char *s, char *t)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b1:	8b 45 08             	mov    0x8(%ebp),%eax
  b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b7:	90                   	nop
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	8d 50 01             	lea    0x1(%eax),%edx
  be:	89 55 08             	mov    %edx,0x8(%ebp)
  c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  c7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ca:	0f b6 12             	movzbl (%edx),%edx
  cd:	88 10                	mov    %dl,(%eax)
  cf:	0f b6 00             	movzbl (%eax),%eax
  d2:	84 c0                	test   %al,%al
  d4:	75 e2                	jne    b8 <strcpy+0xd>
    ;
  return os;
  d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d9:	c9                   	leave  
  da:	c3                   	ret    

000000db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  de:	eb 08                	jmp    e8 <strcmp+0xd>
    p++, q++;
  e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	84 c0                	test   %al,%al
  f0:	74 10                	je     102 <strcmp+0x27>
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 10             	movzbl (%eax),%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	38 c2                	cmp    %al,%dl
 100:	74 de                	je     e0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	0f b6 d0             	movzbl %al,%edx
 10b:	8b 45 0c             	mov    0xc(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	0f b6 c0             	movzbl %al,%eax
 114:	29 c2                	sub    %eax,%edx
 116:	89 d0                	mov    %edx,%eax
}
 118:	5d                   	pop    %ebp
 119:	c3                   	ret    

0000011a <strlen>:

uint
strlen(char *s)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 127:	eb 04                	jmp    12d <strlen+0x13>
 129:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	01 d0                	add    %edx,%eax
 135:	0f b6 00             	movzbl (%eax),%eax
 138:	84 c0                	test   %al,%al
 13a:	75 ed                	jne    129 <strlen+0xf>
    ;
  return n;
 13c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13f:	c9                   	leave  
 140:	c3                   	ret    

00000141 <memset>:

void*
memset(void *dst, int c, uint n)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 147:	8b 45 10             	mov    0x10(%ebp),%eax
 14a:	89 44 24 08          	mov    %eax,0x8(%esp)
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	89 44 24 04          	mov    %eax,0x4(%esp)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	89 04 24             	mov    %eax,(%esp)
 15b:	e8 c3 fe ff ff       	call   23 <stosb>
  return dst;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strchr>:

char*
strchr(const char *s, char c)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 171:	eb 14                	jmp    187 <strchr+0x22>
    if(*s == c)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17c:	75 05                	jne    183 <strchr+0x1e>
      return (char*)s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	eb 13                	jmp    196 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 183:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 e2                	jne    173 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a5:	eb 4c                	jmp    1f3 <gets+0x5b>
    cc = read(0, &c, 1);
 1a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ae:	00 
 1af:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bd:	e8 63 02 00 00       	call   425 <read>
 1c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c9:	7f 02                	jg     1cd <gets+0x35>
      break;
 1cb:	eb 31                	jmp    1fe <gets+0x66>
    buf[i++] = c;
 1cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d0:	8d 50 01             	lea    0x1(%eax),%edx
 1d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1d6:	89 c2                	mov    %eax,%edx
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	01 c2                	add    %eax,%edx
 1dd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	3c 0a                	cmp    $0xa,%al
 1e9:	74 13                	je     1fe <gets+0x66>
 1eb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ef:	3c 0d                	cmp    $0xd,%al
 1f1:	74 0b                	je     1fe <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f6:	83 c0 01             	add    $0x1,%eax
 1f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1fc:	7c a9                	jl     1a7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	01 d0                	add    %edx,%eax
 206:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 209:	8b 45 08             	mov    0x8(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <stat>:

int
stat(char *n, struct stat *st)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 214:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21b:	00 
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	89 04 24             	mov    %eax,(%esp)
 222:	e8 26 02 00 00       	call   44d <open>
 227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 22a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 22e:	79 07                	jns    237 <stat+0x29>
    return -1;
 230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 235:	eb 23                	jmp    25a <stat+0x4c>
  r = fstat(fd, st);
 237:	8b 45 0c             	mov    0xc(%ebp),%eax
 23a:	89 44 24 04          	mov    %eax,0x4(%esp)
 23e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 241:	89 04 24             	mov    %eax,(%esp)
 244:	e8 1c 02 00 00       	call   465 <fstat>
 249:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 24c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 de 01 00 00       	call   435 <close>
  return r;
 257:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 25a:	c9                   	leave  
 25b:	c3                   	ret    

0000025c <atoi>:

int
atoi(const char *s)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 262:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 269:	eb 25                	jmp    290 <atoi+0x34>
    n = n*10 + *s++ - '0';
 26b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26e:	89 d0                	mov    %edx,%eax
 270:	c1 e0 02             	shl    $0x2,%eax
 273:	01 d0                	add    %edx,%eax
 275:	01 c0                	add    %eax,%eax
 277:	89 c1                	mov    %eax,%ecx
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	8d 50 01             	lea    0x1(%eax),%edx
 27f:	89 55 08             	mov    %edx,0x8(%ebp)
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	0f be c0             	movsbl %al,%eax
 288:	01 c8                	add    %ecx,%eax
 28a:	83 e8 30             	sub    $0x30,%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	3c 2f                	cmp    $0x2f,%al
 298:	7e 0a                	jle    2a4 <atoi+0x48>
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	0f b6 00             	movzbl (%eax),%eax
 2a0:	3c 39                	cmp    $0x39,%al
 2a2:	7e c7                	jle    26b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a7:	c9                   	leave  
 2a8:	c3                   	ret    

000002a9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2bb:	eb 17                	jmp    2d4 <memmove+0x2b>
    *dst++ = *src++;
 2bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c0:	8d 50 01             	lea    0x1(%eax),%edx
 2c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c9:	8d 4a 01             	lea    0x1(%edx),%ecx
 2cc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2cf:	0f b6 12             	movzbl (%edx),%edx
 2d2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d4:	8b 45 10             	mov    0x10(%ebp),%eax
 2d7:	8d 50 ff             	lea    -0x1(%eax),%edx
 2da:	89 55 10             	mov    %edx,0x10(%ebp)
 2dd:	85 c0                	test   %eax,%eax
 2df:	7f dc                	jg     2bd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	53                   	push   %ebx
 2ea:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 2f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f7:	79 03                	jns    2fc <itoa+0x16>
         n = -n;          /* make n positive */
 2f9:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 2fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 303:	8b 45 f4             	mov    -0xc(%ebp),%eax
 306:	8d 50 01             	lea    0x1(%eax),%edx
 309:	89 55 f4             	mov    %edx,-0xc(%ebp)
 30c:	89 c2                	mov    %eax,%edx
 30e:	8b 45 0c             	mov    0xc(%ebp),%eax
 311:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 314:	8b 4d 08             	mov    0x8(%ebp),%ecx
 317:	ba 67 66 66 66       	mov    $0x66666667,%edx
 31c:	89 c8                	mov    %ecx,%eax
 31e:	f7 ea                	imul   %edx
 320:	c1 fa 02             	sar    $0x2,%edx
 323:	89 c8                	mov    %ecx,%eax
 325:	c1 f8 1f             	sar    $0x1f,%eax
 328:	29 c2                	sub    %eax,%edx
 32a:	89 d0                	mov    %edx,%eax
 32c:	c1 e0 02             	shl    $0x2,%eax
 32f:	01 d0                	add    %edx,%eax
 331:	01 c0                	add    %eax,%eax
 333:	29 c1                	sub    %eax,%ecx
 335:	89 ca                	mov    %ecx,%edx
 337:	89 d0                	mov    %edx,%eax
 339:	83 c0 30             	add    $0x30,%eax
 33c:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 33e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 341:	ba 67 66 66 66       	mov    $0x66666667,%edx
 346:	89 c8                	mov    %ecx,%eax
 348:	f7 ea                	imul   %edx
 34a:	c1 fa 02             	sar    $0x2,%edx
 34d:	89 c8                	mov    %ecx,%eax
 34f:	c1 f8 1f             	sar    $0x1f,%eax
 352:	29 c2                	sub    %eax,%edx
 354:	89 d0                	mov    %edx,%eax
 356:	89 45 08             	mov    %eax,0x8(%ebp)
 359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 35d:	7f a4                	jg     303 <itoa+0x1d>
     if (sign < 0)
 35f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 363:	79 13                	jns    378 <itoa+0x92>
         s[i++] = '-';
 365:	8b 45 f4             	mov    -0xc(%ebp),%eax
 368:	8d 50 01             	lea    0x1(%eax),%edx
 36b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 36e:	89 c2                	mov    %eax,%edx
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	01 d0                	add    %edx,%eax
 375:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 378:	8b 55 f4             	mov    -0xc(%ebp),%edx
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	01 d0                	add    %edx,%eax
 380:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 383:	8b 45 0c             	mov    0xc(%ebp),%eax
 386:	89 04 24             	mov    %eax,(%esp)
 389:	e8 ba fc ff ff       	call   48 <reverse>
 }
 38e:	83 c4 24             	add    $0x24,%esp
 391:	5b                   	pop    %ebx
 392:	5d                   	pop    %ebp
 393:	c3                   	ret    

00000394 <strcat>:

char *
strcat(char *dest, const char *src)
{
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 39a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3a1:	eb 04                	jmp    3a7 <strcat+0x13>
 3a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	01 d0                	add    %edx,%eax
 3af:	0f b6 00             	movzbl (%eax),%eax
 3b2:	84 c0                	test   %al,%al
 3b4:	75 ed                	jne    3a3 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 3b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 3bd:	eb 20                	jmp    3df <strcat+0x4b>
        dest[i+j] = src[j];
 3bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c5:	01 d0                	add    %edx,%eax
 3c7:	89 c2                	mov    %eax,%edx
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	01 c2                	add    %eax,%edx
 3ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	01 c8                	add    %ecx,%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 3db:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 3df:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	01 d0                	add    %edx,%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	84 c0                	test   %al,%al
 3ec:	75 d1                	jne    3bf <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 3ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f4:	01 d0                	add    %edx,%eax
 3f6:	89 c2                	mov    %eax,%edx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	01 d0                	add    %edx,%eax
 3fd:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 400:	8b 45 08             	mov    0x8(%ebp),%eax
}
 403:	c9                   	leave  
 404:	c3                   	ret    

00000405 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 405:	b8 01 00 00 00       	mov    $0x1,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <exit>:
SYSCALL(exit)
 40d:	b8 02 00 00 00       	mov    $0x2,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <wait>:
SYSCALL(wait)
 415:	b8 03 00 00 00       	mov    $0x3,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <pipe>:
SYSCALL(pipe)
 41d:	b8 04 00 00 00       	mov    $0x4,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <read>:
SYSCALL(read)
 425:	b8 05 00 00 00       	mov    $0x5,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <write>:
SYSCALL(write)
 42d:	b8 10 00 00 00       	mov    $0x10,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <close>:
SYSCALL(close)
 435:	b8 15 00 00 00       	mov    $0x15,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <kill>:
SYSCALL(kill)
 43d:	b8 06 00 00 00       	mov    $0x6,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <exec>:
SYSCALL(exec)
 445:	b8 07 00 00 00       	mov    $0x7,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <open>:
SYSCALL(open)
 44d:	b8 0f 00 00 00       	mov    $0xf,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <mknod>:
SYSCALL(mknod)
 455:	b8 11 00 00 00       	mov    $0x11,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <unlink>:
SYSCALL(unlink)
 45d:	b8 12 00 00 00       	mov    $0x12,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <fstat>:
SYSCALL(fstat)
 465:	b8 08 00 00 00       	mov    $0x8,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <link>:
SYSCALL(link)
 46d:	b8 13 00 00 00       	mov    $0x13,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <mkdir>:
SYSCALL(mkdir)
 475:	b8 14 00 00 00       	mov    $0x14,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <chdir>:
SYSCALL(chdir)
 47d:	b8 09 00 00 00       	mov    $0x9,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <dup>:
SYSCALL(dup)
 485:	b8 0a 00 00 00       	mov    $0xa,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <getpid>:
SYSCALL(getpid)
 48d:	b8 0b 00 00 00       	mov    $0xb,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <sbrk>:
SYSCALL(sbrk)
 495:	b8 0c 00 00 00       	mov    $0xc,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <sleep>:
SYSCALL(sleep)
 49d:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <uptime>:
SYSCALL(uptime)
 4a5:	b8 0e 00 00 00       	mov    $0xe,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <wait2>:
SYSCALL(wait2)
 4ad:	b8 16 00 00 00       	mov    $0x16,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <set_priority>:
SYSCALL(set_priority)
 4b5:	b8 17 00 00 00       	mov    $0x17,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <get_sched_record>:
SYSCALL(get_sched_record)
 4bd:	b8 18 00 00 00       	mov    $0x18,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c5:	55                   	push   %ebp
 4c6:	89 e5                	mov    %esp,%ebp
 4c8:	83 ec 18             	sub    $0x18,%esp
 4cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ce:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d8:	00 
 4d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	89 04 24             	mov    %eax,(%esp)
 4e6:	e8 42 ff ff ff       	call   42d <write>
}
 4eb:	c9                   	leave  
 4ec:	c3                   	ret    

000004ed <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ed:	55                   	push   %ebp
 4ee:	89 e5                	mov    %esp,%ebp
 4f0:	56                   	push   %esi
 4f1:	53                   	push   %ebx
 4f2:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 500:	74 17                	je     519 <printint+0x2c>
 502:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 506:	79 11                	jns    519 <printint+0x2c>
    neg = 1;
 508:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	f7 d8                	neg    %eax
 514:	89 45 ec             	mov    %eax,-0x14(%ebp)
 517:	eb 06                	jmp    51f <printint+0x32>
  } else {
    x = xx;
 519:	8b 45 0c             	mov    0xc(%ebp),%eax
 51c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 51f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 526:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 529:	8d 41 01             	lea    0x1(%ecx),%eax
 52c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 52f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 532:	8b 45 ec             	mov    -0x14(%ebp),%eax
 535:	ba 00 00 00 00       	mov    $0x0,%edx
 53a:	f7 f3                	div    %ebx
 53c:	89 d0                	mov    %edx,%eax
 53e:	0f b6 80 20 0c 00 00 	movzbl 0xc20(%eax),%eax
 545:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 549:	8b 75 10             	mov    0x10(%ebp),%esi
 54c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54f:	ba 00 00 00 00       	mov    $0x0,%edx
 554:	f7 f6                	div    %esi
 556:	89 45 ec             	mov    %eax,-0x14(%ebp)
 559:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55d:	75 c7                	jne    526 <printint+0x39>
  if(neg)
 55f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 563:	74 10                	je     575 <printint+0x88>
    buf[i++] = '-';
 565:	8b 45 f4             	mov    -0xc(%ebp),%eax
 568:	8d 50 01             	lea    0x1(%eax),%edx
 56b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 56e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 573:	eb 1f                	jmp    594 <printint+0xa7>
 575:	eb 1d                	jmp    594 <printint+0xa7>
    putc(fd, buf[i]);
 577:	8d 55 dc             	lea    -0x24(%ebp),%edx
 57a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57d:	01 d0                	add    %edx,%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 31 ff ff ff       	call   4c5 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 594:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 598:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59c:	79 d9                	jns    577 <printint+0x8a>
    putc(fd, buf[i]);
}
 59e:	83 c4 30             	add    $0x30,%esp
 5a1:	5b                   	pop    %ebx
 5a2:	5e                   	pop    %esi
 5a3:	5d                   	pop    %ebp
 5a4:	c3                   	ret    

000005a5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a5:	55                   	push   %ebp
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b2:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b5:	83 c0 04             	add    $0x4,%eax
 5b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c2:	e9 7c 01 00 00       	jmp    743 <printf+0x19e>
    c = fmt[i] & 0xff;
 5c7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cd:	01 d0                	add    %edx,%eax
 5cf:	0f b6 00             	movzbl (%eax),%eax
 5d2:	0f be c0             	movsbl %al,%eax
 5d5:	25 ff 00 00 00       	and    $0xff,%eax
 5da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e1:	75 2c                	jne    60f <printf+0x6a>
      if(c == '%'){
 5e3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e7:	75 0c                	jne    5f5 <printf+0x50>
        state = '%';
 5e9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f0:	e9 4a 01 00 00       	jmp    73f <printf+0x19a>
      } else {
        putc(fd, c);
 5f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
 602:	89 04 24             	mov    %eax,(%esp)
 605:	e8 bb fe ff ff       	call   4c5 <putc>
 60a:	e9 30 01 00 00       	jmp    73f <printf+0x19a>
      }
    } else if(state == '%'){
 60f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 613:	0f 85 26 01 00 00    	jne    73f <printf+0x19a>
      if(c == 'd'){
 619:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61d:	75 2d                	jne    64c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 61f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 622:	8b 00                	mov    (%eax),%eax
 624:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 62b:	00 
 62c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 633:	00 
 634:	89 44 24 04          	mov    %eax,0x4(%esp)
 638:	8b 45 08             	mov    0x8(%ebp),%eax
 63b:	89 04 24             	mov    %eax,(%esp)
 63e:	e8 aa fe ff ff       	call   4ed <printint>
        ap++;
 643:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 647:	e9 ec 00 00 00       	jmp    738 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 64c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 650:	74 06                	je     658 <printf+0xb3>
 652:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 656:	75 2d                	jne    685 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 658:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 664:	00 
 665:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 66c:	00 
 66d:	89 44 24 04          	mov    %eax,0x4(%esp)
 671:	8b 45 08             	mov    0x8(%ebp),%eax
 674:	89 04 24             	mov    %eax,(%esp)
 677:	e8 71 fe ff ff       	call   4ed <printint>
        ap++;
 67c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 680:	e9 b3 00 00 00       	jmp    738 <printf+0x193>
      } else if(c == 's'){
 685:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 689:	75 45                	jne    6d0 <printf+0x12b>
        s = (char*)*ap;
 68b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68e:	8b 00                	mov    (%eax),%eax
 690:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 693:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69b:	75 09                	jne    6a6 <printf+0x101>
          s = "(null)";
 69d:	c7 45 f4 71 09 00 00 	movl   $0x971,-0xc(%ebp)
        while(*s != 0){
 6a4:	eb 1e                	jmp    6c4 <printf+0x11f>
 6a6:	eb 1c                	jmp    6c4 <printf+0x11f>
          putc(fd, *s);
 6a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	0f be c0             	movsbl %al,%eax
 6b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b5:	8b 45 08             	mov    0x8(%ebp),%eax
 6b8:	89 04 24             	mov    %eax,(%esp)
 6bb:	e8 05 fe ff ff       	call   4c5 <putc>
          s++;
 6c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c7:	0f b6 00             	movzbl (%eax),%eax
 6ca:	84 c0                	test   %al,%al
 6cc:	75 da                	jne    6a8 <printf+0x103>
 6ce:	eb 68                	jmp    738 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d4:	75 1d                	jne    6f3 <printf+0x14e>
        putc(fd, *ap);
 6d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	0f be c0             	movsbl %al,%eax
 6de:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	89 04 24             	mov    %eax,(%esp)
 6e8:	e8 d8 fd ff ff       	call   4c5 <putc>
        ap++;
 6ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f1:	eb 45                	jmp    738 <printf+0x193>
      } else if(c == '%'){
 6f3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f7:	75 17                	jne    710 <printf+0x16b>
        putc(fd, c);
 6f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fc:	0f be c0             	movsbl %al,%eax
 6ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	89 04 24             	mov    %eax,(%esp)
 709:	e8 b7 fd ff ff       	call   4c5 <putc>
 70e:	eb 28                	jmp    738 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 710:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 717:	00 
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	89 04 24             	mov    %eax,(%esp)
 71e:	e8 a2 fd ff ff       	call   4c5 <putc>
        putc(fd, c);
 723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 726:	0f be c0             	movsbl %al,%eax
 729:	89 44 24 04          	mov    %eax,0x4(%esp)
 72d:	8b 45 08             	mov    0x8(%ebp),%eax
 730:	89 04 24             	mov    %eax,(%esp)
 733:	e8 8d fd ff ff       	call   4c5 <putc>
      }
      state = 0;
 738:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 73f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 743:	8b 55 0c             	mov    0xc(%ebp),%edx
 746:	8b 45 f0             	mov    -0x10(%ebp),%eax
 749:	01 d0                	add    %edx,%eax
 74b:	0f b6 00             	movzbl (%eax),%eax
 74e:	84 c0                	test   %al,%al
 750:	0f 85 71 fe ff ff    	jne    5c7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 756:	c9                   	leave  
 757:	c3                   	ret    

00000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	83 e8 08             	sub    $0x8,%eax
 764:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 767:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 76c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76f:	eb 24                	jmp    795 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 779:	77 12                	ja     78d <free+0x35>
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 781:	77 24                	ja     7a7 <free+0x4f>
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78b:	77 1a                	ja     7a7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	89 45 fc             	mov    %eax,-0x4(%ebp)
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79b:	76 d4                	jbe    771 <free+0x19>
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a5:	76 ca                	jbe    771 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b7:	01 c2                	add    %eax,%edx
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	39 c2                	cmp    %eax,%edx
 7c0:	75 24                	jne    7e6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c5:	8b 50 04             	mov    0x4(%eax),%edx
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	01 c2                	add    %eax,%edx
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	8b 10                	mov    (%eax),%edx
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	89 10                	mov    %edx,(%eax)
 7e4:	eb 0a                	jmp    7f0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 10                	mov    (%eax),%edx
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	01 d0                	add    %edx,%eax
 802:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 805:	75 20                	jne    827 <free+0xcf>
    p->s.size += bp->s.size;
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 50 04             	mov    0x4(%eax),%edx
 80d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 810:	8b 40 04             	mov    0x4(%eax),%eax
 813:	01 c2                	add    %eax,%edx
 815:	8b 45 fc             	mov    -0x4(%ebp),%eax
 818:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81e:	8b 10                	mov    (%eax),%edx
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
 823:	89 10                	mov    %edx,(%eax)
 825:	eb 08                	jmp    82f <free+0xd7>
  } else
    p->s.ptr = bp;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 82d:	89 10                	mov    %edx,(%eax)
  freep = p;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	a3 3c 0c 00 00       	mov    %eax,0xc3c
}
 837:	c9                   	leave  
 838:	c3                   	ret    

00000839 <morecore>:

static Header*
morecore(uint nu)
{
 839:	55                   	push   %ebp
 83a:	89 e5                	mov    %esp,%ebp
 83c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 83f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 846:	77 07                	ja     84f <morecore+0x16>
    nu = 4096;
 848:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 84f:	8b 45 08             	mov    0x8(%ebp),%eax
 852:	c1 e0 03             	shl    $0x3,%eax
 855:	89 04 24             	mov    %eax,(%esp)
 858:	e8 38 fc ff ff       	call   495 <sbrk>
 85d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 860:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 864:	75 07                	jne    86d <morecore+0x34>
    return 0;
 866:	b8 00 00 00 00       	mov    $0x0,%eax
 86b:	eb 22                	jmp    88f <morecore+0x56>
  hp = (Header*)p;
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 873:	8b 45 f0             	mov    -0x10(%ebp),%eax
 876:	8b 55 08             	mov    0x8(%ebp),%edx
 879:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	83 c0 08             	add    $0x8,%eax
 882:	89 04 24             	mov    %eax,(%esp)
 885:	e8 ce fe ff ff       	call   758 <free>
  return freep;
 88a:	a1 3c 0c 00 00       	mov    0xc3c,%eax
}
 88f:	c9                   	leave  
 890:	c3                   	ret    

00000891 <malloc>:

void*
malloc(uint nbytes)
{
 891:	55                   	push   %ebp
 892:	89 e5                	mov    %esp,%ebp
 894:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	83 c0 07             	add    $0x7,%eax
 89d:	c1 e8 03             	shr    $0x3,%eax
 8a0:	83 c0 01             	add    $0x1,%eax
 8a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a6:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 8ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b2:	75 23                	jne    8d7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b4:	c7 45 f0 34 0c 00 00 	movl   $0xc34,-0x10(%ebp)
 8bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8be:	a3 3c 0c 00 00       	mov    %eax,0xc3c
 8c3:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 8c8:	a3 34 0c 00 00       	mov    %eax,0xc34
    base.s.size = 0;
 8cd:	c7 05 38 0c 00 00 00 	movl   $0x0,0xc38
 8d4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8da:	8b 00                	mov    (%eax),%eax
 8dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	8b 40 04             	mov    0x4(%eax),%eax
 8e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e8:	72 4d                	jb     937 <malloc+0xa6>
      if(p->s.size == nunits)
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	8b 40 04             	mov    0x4(%eax),%eax
 8f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f3:	75 0c                	jne    901 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	8b 10                	mov    (%eax),%edx
 8fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fd:	89 10                	mov    %edx,(%eax)
 8ff:	eb 26                	jmp    927 <malloc+0x96>
      else {
        p->s.size -= nunits;
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	8b 40 04             	mov    0x4(%eax),%eax
 907:	2b 45 ec             	sub    -0x14(%ebp),%eax
 90a:	89 c2                	mov    %eax,%edx
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	8b 40 04             	mov    0x4(%eax),%eax
 918:	c1 e0 03             	shl    $0x3,%eax
 91b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 921:	8b 55 ec             	mov    -0x14(%ebp),%edx
 924:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	a3 3c 0c 00 00       	mov    %eax,0xc3c
      return (void*)(p + 1);
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	83 c0 08             	add    $0x8,%eax
 935:	eb 38                	jmp    96f <malloc+0xde>
    }
    if(p == freep)
 937:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 93c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93f:	75 1b                	jne    95c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 941:	8b 45 ec             	mov    -0x14(%ebp),%eax
 944:	89 04 24             	mov    %eax,(%esp)
 947:	e8 ed fe ff ff       	call   839 <morecore>
 94c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 94f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 953:	75 07                	jne    95c <malloc+0xcb>
        return 0;
 955:	b8 00 00 00 00       	mov    $0x0,%eax
 95a:	eb 13                	jmp    96f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 00                	mov    (%eax),%eax
 967:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96a:	e9 70 ff ff ff       	jmp    8df <malloc+0x4e>
}
 96f:	c9                   	leave  
 970:	c3                   	ret    
