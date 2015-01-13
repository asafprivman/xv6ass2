
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 c7 09 00 	movl   $0x9c7,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 d8 05 00 00       	call   5fb <printf>
    exit();
  23:	e8 3b 04 00 00       	call   463 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 7f 04 00 00       	call   4c3 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 da 09 00 	movl   $0x9da,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 87 05 00 00       	call   5fb <printf>
  exit();
  74:	e8 ea 03 00 00       	call   463 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ab:	8b 45 08             	mov    0x8(%ebp),%eax
  ae:	89 04 24             	mov    %eax,(%esp)
  b1:	e8 ba 00 00 00       	call   170 <strlen>
  b6:	83 e8 01             	sub    $0x1,%eax
  b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  bc:	eb 39                	jmp    f7 <reverse+0x59>
         c = s[i];
  be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	01 d0                	add    %edx,%eax
  c6:	0f b6 00             	movzbl (%eax),%eax
  c9:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
  cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	01 c2                	add    %eax,%edx
  d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 c8                	add    %ecx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	88 02                	mov    %al,(%edx)
         s[j] = c;
  e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	01 c2                	add    %eax,%edx
  e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  ed:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  f3:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  fd:	7c bf                	jl     be <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <strcpy>:

char*
strcpy(char *s, char *t)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 10d:	90                   	nop
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	8d 50 01             	lea    0x1(%eax),%edx
 114:	89 55 08             	mov    %edx,0x8(%ebp)
 117:	8b 55 0c             	mov    0xc(%ebp),%edx
 11a:	8d 4a 01             	lea    0x1(%edx),%ecx
 11d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 120:	0f b6 12             	movzbl (%edx),%edx
 123:	88 10                	mov    %dl,(%eax)
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	84 c0                	test   %al,%al
 12a:	75 e2                	jne    10e <strcpy+0xd>
    ;
  return os;
 12c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12f:	c9                   	leave  
 130:	c3                   	ret    

00000131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 134:	eb 08                	jmp    13e <strcmp+0xd>
    p++, q++;
 136:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 13e:	8b 45 08             	mov    0x8(%ebp),%eax
 141:	0f b6 00             	movzbl (%eax),%eax
 144:	84 c0                	test   %al,%al
 146:	74 10                	je     158 <strcmp+0x27>
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	0f b6 10             	movzbl (%eax),%edx
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	0f b6 00             	movzbl (%eax),%eax
 154:	38 c2                	cmp    %al,%dl
 156:	74 de                	je     136 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	0f b6 d0             	movzbl %al,%edx
 161:	8b 45 0c             	mov    0xc(%ebp),%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	0f b6 c0             	movzbl %al,%eax
 16a:	29 c2                	sub    %eax,%edx
 16c:	89 d0                	mov    %edx,%eax
}
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <strlen>:

uint
strlen(char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 17d:	eb 04                	jmp    183 <strlen+0x13>
 17f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 183:	8b 55 fc             	mov    -0x4(%ebp),%edx
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	01 d0                	add    %edx,%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 ed                	jne    17f <strlen+0xf>
    ;
  return n;
 192:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 195:	c9                   	leave  
 196:	c3                   	ret    

00000197 <memset>:

void*
memset(void *dst, int c, uint n)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 19d:	8b 45 10             	mov    0x10(%ebp),%eax
 1a0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 c3 fe ff ff       	call   79 <stosb>
  return dst;
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b9:	c9                   	leave  
 1ba:	c3                   	ret    

000001bb <strchr>:

char*
strchr(const char *s, char c)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	83 ec 04             	sub    $0x4,%esp
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1c7:	eb 14                	jmp    1dd <strchr+0x22>
    if(*s == c)
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	0f b6 00             	movzbl (%eax),%eax
 1cf:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d2:	75 05                	jne    1d9 <strchr+0x1e>
      return (char*)s;
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	eb 13                	jmp    1ec <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	0f b6 00             	movzbl (%eax),%eax
 1e3:	84 c0                	test   %al,%al
 1e5:	75 e2                	jne    1c9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ec:	c9                   	leave  
 1ed:	c3                   	ret    

000001ee <gets>:

char*
gets(char *buf, int max)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1fb:	eb 4c                	jmp    249 <gets+0x5b>
    cc = read(0, &c, 1);
 1fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 204:	00 
 205:	8d 45 ef             	lea    -0x11(%ebp),%eax
 208:	89 44 24 04          	mov    %eax,0x4(%esp)
 20c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 213:	e8 63 02 00 00       	call   47b <read>
 218:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 21b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 21f:	7f 02                	jg     223 <gets+0x35>
      break;
 221:	eb 31                	jmp    254 <gets+0x66>
    buf[i++] = c;
 223:	8b 45 f4             	mov    -0xc(%ebp),%eax
 226:	8d 50 01             	lea    0x1(%eax),%edx
 229:	89 55 f4             	mov    %edx,-0xc(%ebp)
 22c:	89 c2                	mov    %eax,%edx
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	01 c2                	add    %eax,%edx
 233:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 237:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 239:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23d:	3c 0a                	cmp    $0xa,%al
 23f:	74 13                	je     254 <gets+0x66>
 241:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 245:	3c 0d                	cmp    $0xd,%al
 247:	74 0b                	je     254 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 249:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24c:	83 c0 01             	add    $0x1,%eax
 24f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 252:	7c a9                	jl     1fd <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 254:	8b 55 f4             	mov    -0xc(%ebp),%edx
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	01 d0                	add    %edx,%eax
 25c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 262:	c9                   	leave  
 263:	c3                   	ret    

00000264 <stat>:

int
stat(char *n, struct stat *st)
{
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 271:	00 
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	89 04 24             	mov    %eax,(%esp)
 278:	e8 26 02 00 00       	call   4a3 <open>
 27d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 284:	79 07                	jns    28d <stat+0x29>
    return -1;
 286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28b:	eb 23                	jmp    2b0 <stat+0x4c>
  r = fstat(fd, st);
 28d:	8b 45 0c             	mov    0xc(%ebp),%eax
 290:	89 44 24 04          	mov    %eax,0x4(%esp)
 294:	8b 45 f4             	mov    -0xc(%ebp),%eax
 297:	89 04 24             	mov    %eax,(%esp)
 29a:	e8 1c 02 00 00       	call   4bb <fstat>
 29f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a5:	89 04 24             	mov    %eax,(%esp)
 2a8:	e8 de 01 00 00       	call   48b <close>
  return r;
 2ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <atoi>:

int
atoi(const char *s)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2bf:	eb 25                	jmp    2e6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c4:	89 d0                	mov    %edx,%eax
 2c6:	c1 e0 02             	shl    $0x2,%eax
 2c9:	01 d0                	add    %edx,%eax
 2cb:	01 c0                	add    %eax,%eax
 2cd:	89 c1                	mov    %eax,%ecx
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	8d 50 01             	lea    0x1(%eax),%edx
 2d5:	89 55 08             	mov    %edx,0x8(%ebp)
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	0f be c0             	movsbl %al,%eax
 2de:	01 c8                	add    %ecx,%eax
 2e0:	83 e8 30             	sub    $0x30,%eax
 2e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	3c 2f                	cmp    $0x2f,%al
 2ee:	7e 0a                	jle    2fa <atoi+0x48>
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	0f b6 00             	movzbl (%eax),%eax
 2f6:	3c 39                	cmp    $0x39,%al
 2f8:	7e c7                	jle    2c1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fd:	c9                   	leave  
 2fe:	c3                   	ret    

000002ff <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ff:	55                   	push   %ebp
 300:	89 e5                	mov    %esp,%ebp
 302:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 30b:	8b 45 0c             	mov    0xc(%ebp),%eax
 30e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 311:	eb 17                	jmp    32a <memmove+0x2b>
    *dst++ = *src++;
 313:	8b 45 fc             	mov    -0x4(%ebp),%eax
 316:	8d 50 01             	lea    0x1(%eax),%edx
 319:	89 55 fc             	mov    %edx,-0x4(%ebp)
 31c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 31f:	8d 4a 01             	lea    0x1(%edx),%ecx
 322:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 325:	0f b6 12             	movzbl (%edx),%edx
 328:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32a:	8b 45 10             	mov    0x10(%ebp),%eax
 32d:	8d 50 ff             	lea    -0x1(%eax),%edx
 330:	89 55 10             	mov    %edx,0x10(%ebp)
 333:	85 c0                	test   %eax,%eax
 335:	7f dc                	jg     313 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 337:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	53                   	push   %ebx
 340:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	89 45 f0             	mov    %eax,-0x10(%ebp)
 349:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 34d:	79 03                	jns    352 <itoa+0x16>
         n = -n;          /* make n positive */
 34f:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 359:	8b 45 f4             	mov    -0xc(%ebp),%eax
 35c:	8d 50 01             	lea    0x1(%eax),%edx
 35f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 362:	89 c2                	mov    %eax,%edx
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 36a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 36d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 372:	89 c8                	mov    %ecx,%eax
 374:	f7 ea                	imul   %edx
 376:	c1 fa 02             	sar    $0x2,%edx
 379:	89 c8                	mov    %ecx,%eax
 37b:	c1 f8 1f             	sar    $0x1f,%eax
 37e:	29 c2                	sub    %eax,%edx
 380:	89 d0                	mov    %edx,%eax
 382:	c1 e0 02             	shl    $0x2,%eax
 385:	01 d0                	add    %edx,%eax
 387:	01 c0                	add    %eax,%eax
 389:	29 c1                	sub    %eax,%ecx
 38b:	89 ca                	mov    %ecx,%edx
 38d:	89 d0                	mov    %edx,%eax
 38f:	83 c0 30             	add    $0x30,%eax
 392:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 394:	8b 4d 08             	mov    0x8(%ebp),%ecx
 397:	ba 67 66 66 66       	mov    $0x66666667,%edx
 39c:	89 c8                	mov    %ecx,%eax
 39e:	f7 ea                	imul   %edx
 3a0:	c1 fa 02             	sar    $0x2,%edx
 3a3:	89 c8                	mov    %ecx,%eax
 3a5:	c1 f8 1f             	sar    $0x1f,%eax
 3a8:	29 c2                	sub    %eax,%edx
 3aa:	89 d0                	mov    %edx,%eax
 3ac:	89 45 08             	mov    %eax,0x8(%ebp)
 3af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3b3:	7f a4                	jg     359 <itoa+0x1d>
     if (sign < 0)
 3b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3b9:	79 13                	jns    3ce <itoa+0x92>
         s[i++] = '-';
 3bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3be:	8d 50 01             	lea    0x1(%eax),%edx
 3c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3c4:	89 c2                	mov    %eax,%edx
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	01 d0                	add    %edx,%eax
 3cb:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 3ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	01 d0                	add    %edx,%eax
 3d6:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dc:	89 04 24             	mov    %eax,(%esp)
 3df:	e8 ba fc ff ff       	call   9e <reverse>
 }
 3e4:	83 c4 24             	add    $0x24,%esp
 3e7:	5b                   	pop    %ebx
 3e8:	5d                   	pop    %ebp
 3e9:	c3                   	ret    

000003ea <strcat>:

char *
strcat(char *dest, const char *src)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
 3ed:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f7:	eb 04                	jmp    3fd <strcat+0x13>
 3f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	01 d0                	add    %edx,%eax
 405:	0f b6 00             	movzbl (%eax),%eax
 408:	84 c0                	test   %al,%al
 40a:	75 ed                	jne    3f9 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 40c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 413:	eb 20                	jmp    435 <strcat+0x4b>
        dest[i+j] = src[j];
 415:	8b 45 f8             	mov    -0x8(%ebp),%eax
 418:	8b 55 fc             	mov    -0x4(%ebp),%edx
 41b:	01 d0                	add    %edx,%eax
 41d:	89 c2                	mov    %eax,%edx
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	01 c2                	add    %eax,%edx
 424:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	01 c8                	add    %ecx,%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 431:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 435:	8b 55 f8             	mov    -0x8(%ebp),%edx
 438:	8b 45 0c             	mov    0xc(%ebp),%eax
 43b:	01 d0                	add    %edx,%eax
 43d:	0f b6 00             	movzbl (%eax),%eax
 440:	84 c0                	test   %al,%al
 442:	75 d1                	jne    415 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 444:	8b 45 f8             	mov    -0x8(%ebp),%eax
 447:	8b 55 fc             	mov    -0x4(%ebp),%edx
 44a:	01 d0                	add    %edx,%eax
 44c:	89 c2                	mov    %eax,%edx
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	01 d0                	add    %edx,%eax
 453:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 456:	8b 45 08             	mov    0x8(%ebp),%eax
}
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 45b:	b8 01 00 00 00       	mov    $0x1,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <exit>:
SYSCALL(exit)
 463:	b8 02 00 00 00       	mov    $0x2,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <wait>:
SYSCALL(wait)
 46b:	b8 03 00 00 00       	mov    $0x3,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <pipe>:
SYSCALL(pipe)
 473:	b8 04 00 00 00       	mov    $0x4,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <read>:
SYSCALL(read)
 47b:	b8 05 00 00 00       	mov    $0x5,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <write>:
SYSCALL(write)
 483:	b8 10 00 00 00       	mov    $0x10,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <close>:
SYSCALL(close)
 48b:	b8 15 00 00 00       	mov    $0x15,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <kill>:
SYSCALL(kill)
 493:	b8 06 00 00 00       	mov    $0x6,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <exec>:
SYSCALL(exec)
 49b:	b8 07 00 00 00       	mov    $0x7,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <open>:
SYSCALL(open)
 4a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <mknod>:
SYSCALL(mknod)
 4ab:	b8 11 00 00 00       	mov    $0x11,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <unlink>:
SYSCALL(unlink)
 4b3:	b8 12 00 00 00       	mov    $0x12,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <fstat>:
SYSCALL(fstat)
 4bb:	b8 08 00 00 00       	mov    $0x8,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <link>:
SYSCALL(link)
 4c3:	b8 13 00 00 00       	mov    $0x13,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <mkdir>:
SYSCALL(mkdir)
 4cb:	b8 14 00 00 00       	mov    $0x14,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <chdir>:
SYSCALL(chdir)
 4d3:	b8 09 00 00 00       	mov    $0x9,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <dup>:
SYSCALL(dup)
 4db:	b8 0a 00 00 00       	mov    $0xa,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <getpid>:
SYSCALL(getpid)
 4e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <sbrk>:
SYSCALL(sbrk)
 4eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <sleep>:
SYSCALL(sleep)
 4f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <uptime>:
SYSCALL(uptime)
 4fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <wait2>:
SYSCALL(wait2)
 503:	b8 16 00 00 00       	mov    $0x16,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <set_priority>:
SYSCALL(set_priority)
 50b:	b8 17 00 00 00       	mov    $0x17,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <get_sched_record>:
SYSCALL(get_sched_record)
 513:	b8 18 00 00 00       	mov    $0x18,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 51b:	55                   	push   %ebp
 51c:	89 e5                	mov    %esp,%ebp
 51e:	83 ec 18             	sub    $0x18,%esp
 521:	8b 45 0c             	mov    0xc(%ebp),%eax
 524:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 527:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 52e:	00 
 52f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 532:	89 44 24 04          	mov    %eax,0x4(%esp)
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	89 04 24             	mov    %eax,(%esp)
 53c:	e8 42 ff ff ff       	call   483 <write>
}
 541:	c9                   	leave  
 542:	c3                   	ret    

00000543 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 543:	55                   	push   %ebp
 544:	89 e5                	mov    %esp,%ebp
 546:	56                   	push   %esi
 547:	53                   	push   %ebx
 548:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 54b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 552:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 556:	74 17                	je     56f <printint+0x2c>
 558:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 55c:	79 11                	jns    56f <printint+0x2c>
    neg = 1;
 55e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 565:	8b 45 0c             	mov    0xc(%ebp),%eax
 568:	f7 d8                	neg    %eax
 56a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 56d:	eb 06                	jmp    575 <printint+0x32>
  } else {
    x = xx;
 56f:	8b 45 0c             	mov    0xc(%ebp),%eax
 572:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 575:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 57c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 57f:	8d 41 01             	lea    0x1(%ecx),%eax
 582:	89 45 f4             	mov    %eax,-0xc(%ebp)
 585:	8b 5d 10             	mov    0x10(%ebp),%ebx
 588:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58b:	ba 00 00 00 00       	mov    $0x0,%edx
 590:	f7 f3                	div    %ebx
 592:	89 d0                	mov    %edx,%eax
 594:	0f b6 80 a0 0c 00 00 	movzbl 0xca0(%eax),%eax
 59b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 59f:	8b 75 10             	mov    0x10(%ebp),%esi
 5a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a5:	ba 00 00 00 00       	mov    $0x0,%edx
 5aa:	f7 f6                	div    %esi
 5ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b3:	75 c7                	jne    57c <printint+0x39>
  if(neg)
 5b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5b9:	74 10                	je     5cb <printint+0x88>
    buf[i++] = '-';
 5bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5be:	8d 50 01             	lea    0x1(%eax),%edx
 5c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5c4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5c9:	eb 1f                	jmp    5ea <printint+0xa7>
 5cb:	eb 1d                	jmp    5ea <printint+0xa7>
    putc(fd, buf[i]);
 5cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d3:	01 d0                	add    %edx,%eax
 5d5:	0f b6 00             	movzbl (%eax),%eax
 5d8:	0f be c0             	movsbl %al,%eax
 5db:	89 44 24 04          	mov    %eax,0x4(%esp)
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	89 04 24             	mov    %eax,(%esp)
 5e5:	e8 31 ff ff ff       	call   51b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ea:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f2:	79 d9                	jns    5cd <printint+0x8a>
    putc(fd, buf[i]);
}
 5f4:	83 c4 30             	add    $0x30,%esp
 5f7:	5b                   	pop    %ebx
 5f8:	5e                   	pop    %esi
 5f9:	5d                   	pop    %ebp
 5fa:	c3                   	ret    

000005fb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5fb:	55                   	push   %ebp
 5fc:	89 e5                	mov    %esp,%ebp
 5fe:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 601:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 608:	8d 45 0c             	lea    0xc(%ebp),%eax
 60b:	83 c0 04             	add    $0x4,%eax
 60e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 611:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 618:	e9 7c 01 00 00       	jmp    799 <printf+0x19e>
    c = fmt[i] & 0xff;
 61d:	8b 55 0c             	mov    0xc(%ebp),%edx
 620:	8b 45 f0             	mov    -0x10(%ebp),%eax
 623:	01 d0                	add    %edx,%eax
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	25 ff 00 00 00       	and    $0xff,%eax
 630:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 633:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 637:	75 2c                	jne    665 <printf+0x6a>
      if(c == '%'){
 639:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63d:	75 0c                	jne    64b <printf+0x50>
        state = '%';
 63f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 646:	e9 4a 01 00 00       	jmp    795 <printf+0x19a>
      } else {
        putc(fd, c);
 64b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64e:	0f be c0             	movsbl %al,%eax
 651:	89 44 24 04          	mov    %eax,0x4(%esp)
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	89 04 24             	mov    %eax,(%esp)
 65b:	e8 bb fe ff ff       	call   51b <putc>
 660:	e9 30 01 00 00       	jmp    795 <printf+0x19a>
      }
    } else if(state == '%'){
 665:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 669:	0f 85 26 01 00 00    	jne    795 <printf+0x19a>
      if(c == 'd'){
 66f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 673:	75 2d                	jne    6a2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 675:	8b 45 e8             	mov    -0x18(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 681:	00 
 682:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 689:	00 
 68a:	89 44 24 04          	mov    %eax,0x4(%esp)
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	89 04 24             	mov    %eax,(%esp)
 694:	e8 aa fe ff ff       	call   543 <printint>
        ap++;
 699:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69d:	e9 ec 00 00 00       	jmp    78e <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6a2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a6:	74 06                	je     6ae <printf+0xb3>
 6a8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6ac:	75 2d                	jne    6db <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6ba:	00 
 6bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6c2:	00 
 6c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ca:	89 04 24             	mov    %eax,(%esp)
 6cd:	e8 71 fe ff ff       	call   543 <printint>
        ap++;
 6d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d6:	e9 b3 00 00 00       	jmp    78e <printf+0x193>
      } else if(c == 's'){
 6db:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6df:	75 45                	jne    726 <printf+0x12b>
        s = (char*)*ap;
 6e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f1:	75 09                	jne    6fc <printf+0x101>
          s = "(null)";
 6f3:	c7 45 f4 ee 09 00 00 	movl   $0x9ee,-0xc(%ebp)
        while(*s != 0){
 6fa:	eb 1e                	jmp    71a <printf+0x11f>
 6fc:	eb 1c                	jmp    71a <printf+0x11f>
          putc(fd, *s);
 6fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 701:	0f b6 00             	movzbl (%eax),%eax
 704:	0f be c0             	movsbl %al,%eax
 707:	89 44 24 04          	mov    %eax,0x4(%esp)
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	89 04 24             	mov    %eax,(%esp)
 711:	e8 05 fe ff ff       	call   51b <putc>
          s++;
 716:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 71a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71d:	0f b6 00             	movzbl (%eax),%eax
 720:	84 c0                	test   %al,%al
 722:	75 da                	jne    6fe <printf+0x103>
 724:	eb 68                	jmp    78e <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 726:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 72a:	75 1d                	jne    749 <printf+0x14e>
        putc(fd, *ap);
 72c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	0f be c0             	movsbl %al,%eax
 734:	89 44 24 04          	mov    %eax,0x4(%esp)
 738:	8b 45 08             	mov    0x8(%ebp),%eax
 73b:	89 04 24             	mov    %eax,(%esp)
 73e:	e8 d8 fd ff ff       	call   51b <putc>
        ap++;
 743:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 747:	eb 45                	jmp    78e <printf+0x193>
      } else if(c == '%'){
 749:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 74d:	75 17                	jne    766 <printf+0x16b>
        putc(fd, c);
 74f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 752:	0f be c0             	movsbl %al,%eax
 755:	89 44 24 04          	mov    %eax,0x4(%esp)
 759:	8b 45 08             	mov    0x8(%ebp),%eax
 75c:	89 04 24             	mov    %eax,(%esp)
 75f:	e8 b7 fd ff ff       	call   51b <putc>
 764:	eb 28                	jmp    78e <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 766:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 76d:	00 
 76e:	8b 45 08             	mov    0x8(%ebp),%eax
 771:	89 04 24             	mov    %eax,(%esp)
 774:	e8 a2 fd ff ff       	call   51b <putc>
        putc(fd, c);
 779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77c:	0f be c0             	movsbl %al,%eax
 77f:	89 44 24 04          	mov    %eax,0x4(%esp)
 783:	8b 45 08             	mov    0x8(%ebp),%eax
 786:	89 04 24             	mov    %eax,(%esp)
 789:	e8 8d fd ff ff       	call   51b <putc>
      }
      state = 0;
 78e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 795:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 799:	8b 55 0c             	mov    0xc(%ebp),%edx
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	01 d0                	add    %edx,%eax
 7a1:	0f b6 00             	movzbl (%eax),%eax
 7a4:	84 c0                	test   %al,%al
 7a6:	0f 85 71 fe ff ff    	jne    61d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7ac:	c9                   	leave  
 7ad:	c3                   	ret    

000007ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ae:	55                   	push   %ebp
 7af:	89 e5                	mov    %esp,%ebp
 7b1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b4:	8b 45 08             	mov    0x8(%ebp),%eax
 7b7:	83 e8 08             	sub    $0x8,%eax
 7ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bd:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 7c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c5:	eb 24                	jmp    7eb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cf:	77 12                	ja     7e3 <free+0x35>
 7d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d7:	77 24                	ja     7fd <free+0x4f>
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e1:	77 1a                	ja     7fd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f1:	76 d4                	jbe    7c7 <free+0x19>
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	8b 00                	mov    (%eax),%eax
 7f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fb:	76 ca                	jbe    7c7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	8b 40 04             	mov    0x4(%eax),%eax
 803:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80d:	01 c2                	add    %eax,%edx
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	39 c2                	cmp    %eax,%edx
 816:	75 24                	jne    83c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 818:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81b:	8b 50 04             	mov    0x4(%eax),%edx
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	8b 40 04             	mov    0x4(%eax),%eax
 826:	01 c2                	add    %eax,%edx
 828:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 82e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 831:	8b 00                	mov    (%eax),%eax
 833:	8b 10                	mov    (%eax),%edx
 835:	8b 45 f8             	mov    -0x8(%ebp),%eax
 838:	89 10                	mov    %edx,(%eax)
 83a:	eb 0a                	jmp    846 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 83c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83f:	8b 10                	mov    (%eax),%edx
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 853:	8b 45 fc             	mov    -0x4(%ebp),%eax
 856:	01 d0                	add    %edx,%eax
 858:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 85b:	75 20                	jne    87d <free+0xcf>
    p->s.size += bp->s.size;
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	8b 50 04             	mov    0x4(%eax),%edx
 863:	8b 45 f8             	mov    -0x8(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	01 c2                	add    %eax,%edx
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 871:	8b 45 f8             	mov    -0x8(%ebp),%eax
 874:	8b 10                	mov    (%eax),%edx
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	89 10                	mov    %edx,(%eax)
 87b:	eb 08                	jmp    885 <free+0xd7>
  } else
    p->s.ptr = bp;
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8b 55 f8             	mov    -0x8(%ebp),%edx
 883:	89 10                	mov    %edx,(%eax)
  freep = p;
 885:	8b 45 fc             	mov    -0x4(%ebp),%eax
 888:	a3 bc 0c 00 00       	mov    %eax,0xcbc
}
 88d:	c9                   	leave  
 88e:	c3                   	ret    

0000088f <morecore>:

static Header*
morecore(uint nu)
{
 88f:	55                   	push   %ebp
 890:	89 e5                	mov    %esp,%ebp
 892:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 895:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 89c:	77 07                	ja     8a5 <morecore+0x16>
    nu = 4096;
 89e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a5:	8b 45 08             	mov    0x8(%ebp),%eax
 8a8:	c1 e0 03             	shl    $0x3,%eax
 8ab:	89 04 24             	mov    %eax,(%esp)
 8ae:	e8 38 fc ff ff       	call   4eb <sbrk>
 8b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8ba:	75 07                	jne    8c3 <morecore+0x34>
    return 0;
 8bc:	b8 00 00 00 00       	mov    $0x0,%eax
 8c1:	eb 22                	jmp    8e5 <morecore+0x56>
  hp = (Header*)p;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cc:	8b 55 08             	mov    0x8(%ebp),%edx
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d5:	83 c0 08             	add    $0x8,%eax
 8d8:	89 04 24             	mov    %eax,(%esp)
 8db:	e8 ce fe ff ff       	call   7ae <free>
  return freep;
 8e0:	a1 bc 0c 00 00       	mov    0xcbc,%eax
}
 8e5:	c9                   	leave  
 8e6:	c3                   	ret    

000008e7 <malloc>:

void*
malloc(uint nbytes)
{
 8e7:	55                   	push   %ebp
 8e8:	89 e5                	mov    %esp,%ebp
 8ea:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ed:	8b 45 08             	mov    0x8(%ebp),%eax
 8f0:	83 c0 07             	add    $0x7,%eax
 8f3:	c1 e8 03             	shr    $0x3,%eax
 8f6:	83 c0 01             	add    $0x1,%eax
 8f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8fc:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 901:	89 45 f0             	mov    %eax,-0x10(%ebp)
 904:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 908:	75 23                	jne    92d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 90a:	c7 45 f0 b4 0c 00 00 	movl   $0xcb4,-0x10(%ebp)
 911:	8b 45 f0             	mov    -0x10(%ebp),%eax
 914:	a3 bc 0c 00 00       	mov    %eax,0xcbc
 919:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 91e:	a3 b4 0c 00 00       	mov    %eax,0xcb4
    base.s.size = 0;
 923:	c7 05 b8 0c 00 00 00 	movl   $0x0,0xcb8
 92a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 930:	8b 00                	mov    (%eax),%eax
 932:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 935:	8b 45 f4             	mov    -0xc(%ebp),%eax
 938:	8b 40 04             	mov    0x4(%eax),%eax
 93b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93e:	72 4d                	jb     98d <malloc+0xa6>
      if(p->s.size == nunits)
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	8b 40 04             	mov    0x4(%eax),%eax
 946:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 949:	75 0c                	jne    957 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 94b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94e:	8b 10                	mov    (%eax),%edx
 950:	8b 45 f0             	mov    -0x10(%ebp),%eax
 953:	89 10                	mov    %edx,(%eax)
 955:	eb 26                	jmp    97d <malloc+0x96>
      else {
        p->s.size -= nunits;
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	8b 40 04             	mov    0x4(%eax),%eax
 95d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 960:	89 c2                	mov    %eax,%edx
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 968:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96b:	8b 40 04             	mov    0x4(%eax),%eax
 96e:	c1 e0 03             	shl    $0x3,%eax
 971:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 974:	8b 45 f4             	mov    -0xc(%ebp),%eax
 977:	8b 55 ec             	mov    -0x14(%ebp),%edx
 97a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 97d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 980:	a3 bc 0c 00 00       	mov    %eax,0xcbc
      return (void*)(p + 1);
 985:	8b 45 f4             	mov    -0xc(%ebp),%eax
 988:	83 c0 08             	add    $0x8,%eax
 98b:	eb 38                	jmp    9c5 <malloc+0xde>
    }
    if(p == freep)
 98d:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 992:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 995:	75 1b                	jne    9b2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 997:	8b 45 ec             	mov    -0x14(%ebp),%eax
 99a:	89 04 24             	mov    %eax,(%esp)
 99d:	e8 ed fe ff ff       	call   88f <morecore>
 9a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a9:	75 07                	jne    9b2 <malloc+0xcb>
        return 0;
 9ab:	b8 00 00 00 00       	mov    $0x0,%eax
 9b0:	eb 13                	jmp    9c5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bb:	8b 00                	mov    (%eax),%eax
 9bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9c0:	e9 70 ff ff ff       	jmp    935 <malloc+0x4e>
}
 9c5:	c9                   	leave  
 9c6:	c3                   	ret    
