
_echo:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 ba 09 00 00       	mov    $0x9ba,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 bc 09 00 00       	mov    $0x9bc,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 be 09 00 	movl   $0x9be,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 95 05 00 00       	call   5ee <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 ea 03 00 00       	call   456 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 04 24             	mov    %eax,(%esp)
  a4:	e8 ba 00 00 00       	call   163 <strlen>
  a9:	83 e8 01             	sub    $0x1,%eax
  ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  af:	eb 39                	jmp    ea <reverse+0x59>
         c = s[i];
  b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	01 d0                	add    %edx,%eax
  b9:	0f b6 00             	movzbl (%eax),%eax
  bc:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
  bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	01 c2                	add    %eax,%edx
  c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	01 c8                	add    %ecx,%eax
  cf:	0f b6 00             	movzbl (%eax),%eax
  d2:	88 02                	mov    %al,(%edx)
         s[j] = c;
  d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 c2                	add    %eax,%edx
  dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  e0:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  e6:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  f0:	7c bf                	jl     b1 <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
  f2:	c9                   	leave  
  f3:	c3                   	ret    

000000f4 <strcpy>:

char*
strcpy(char *s, char *t)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 100:	90                   	nop
 101:	8b 45 08             	mov    0x8(%ebp),%eax
 104:	8d 50 01             	lea    0x1(%eax),%edx
 107:	89 55 08             	mov    %edx,0x8(%ebp)
 10a:	8b 55 0c             	mov    0xc(%ebp),%edx
 10d:	8d 4a 01             	lea    0x1(%edx),%ecx
 110:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 113:	0f b6 12             	movzbl (%edx),%edx
 116:	88 10                	mov    %dl,(%eax)
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	84 c0                	test   %al,%al
 11d:	75 e2                	jne    101 <strcpy+0xd>
    ;
  return os;
 11f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 122:	c9                   	leave  
 123:	c3                   	ret    

00000124 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 127:	eb 08                	jmp    131 <strcmp+0xd>
    p++, q++;
 129:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	84 c0                	test   %al,%al
 139:	74 10                	je     14b <strcmp+0x27>
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	0f b6 10             	movzbl (%eax),%edx
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	38 c2                	cmp    %al,%dl
 149:	74 de                	je     129 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 00             	movzbl (%eax),%eax
 151:	0f b6 d0             	movzbl %al,%edx
 154:	8b 45 0c             	mov    0xc(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	0f b6 c0             	movzbl %al,%eax
 15d:	29 c2                	sub    %eax,%edx
 15f:	89 d0                	mov    %edx,%eax
}
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    

00000163 <strlen>:

uint
strlen(char *s)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 170:	eb 04                	jmp    176 <strlen+0x13>
 172:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 176:	8b 55 fc             	mov    -0x4(%ebp),%edx
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	01 d0                	add    %edx,%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	84 c0                	test   %al,%al
 183:	75 ed                	jne    172 <strlen+0xf>
    ;
  return n;
 185:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 188:	c9                   	leave  
 189:	c3                   	ret    

0000018a <memset>:

void*
memset(void *dst, int c, uint n)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 190:	8b 45 10             	mov    0x10(%ebp),%eax
 193:	89 44 24 08          	mov    %eax,0x8(%esp)
 197:	8b 45 0c             	mov    0xc(%ebp),%eax
 19a:	89 44 24 04          	mov    %eax,0x4(%esp)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 c3 fe ff ff       	call   6c <stosb>
  return dst;
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ac:	c9                   	leave  
 1ad:	c3                   	ret    

000001ae <strchr>:

char*
strchr(const char *s, char c)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 04             	sub    $0x4,%esp
 1b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ba:	eb 14                	jmp    1d0 <strchr+0x22>
    if(*s == c)
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c5:	75 05                	jne    1cc <strchr+0x1e>
      return (char*)s;
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	eb 13                	jmp    1df <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	84 c0                	test   %al,%al
 1d8:	75 e2                	jne    1bc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1da:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <gets>:

char*
gets(char *buf, int max)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ee:	eb 4c                	jmp    23c <gets+0x5b>
    cc = read(0, &c, 1);
 1f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1f7:	00 
 1f8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 206:	e8 63 02 00 00       	call   46e <read>
 20b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 20e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 212:	7f 02                	jg     216 <gets+0x35>
      break;
 214:	eb 31                	jmp    247 <gets+0x66>
    buf[i++] = c;
 216:	8b 45 f4             	mov    -0xc(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 21f:	89 c2                	mov    %eax,%edx
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	01 c2                	add    %eax,%edx
 226:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 22c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 230:	3c 0a                	cmp    $0xa,%al
 232:	74 13                	je     247 <gets+0x66>
 234:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 238:	3c 0d                	cmp    $0xd,%al
 23a:	74 0b                	je     247 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23f:	83 c0 01             	add    $0x1,%eax
 242:	3b 45 0c             	cmp    0xc(%ebp),%eax
 245:	7c a9                	jl     1f0 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 247:	8b 55 f4             	mov    -0xc(%ebp),%edx
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	01 d0                	add    %edx,%eax
 24f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 252:	8b 45 08             	mov    0x8(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <stat>:

int
stat(char *n, struct stat *st)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 264:	00 
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	89 04 24             	mov    %eax,(%esp)
 26b:	e8 26 02 00 00       	call   496 <open>
 270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 273:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 277:	79 07                	jns    280 <stat+0x29>
    return -1;
 279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 27e:	eb 23                	jmp    2a3 <stat+0x4c>
  r = fstat(fd, st);
 280:	8b 45 0c             	mov    0xc(%ebp),%eax
 283:	89 44 24 04          	mov    %eax,0x4(%esp)
 287:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28a:	89 04 24             	mov    %eax,(%esp)
 28d:	e8 1c 02 00 00       	call   4ae <fstat>
 292:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 295:	8b 45 f4             	mov    -0xc(%ebp),%eax
 298:	89 04 24             	mov    %eax,(%esp)
 29b:	e8 de 01 00 00       	call   47e <close>
  return r;
 2a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2a3:	c9                   	leave  
 2a4:	c3                   	ret    

000002a5 <atoi>:

int
atoi(const char *s)
{
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2b2:	eb 25                	jmp    2d9 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b7:	89 d0                	mov    %edx,%eax
 2b9:	c1 e0 02             	shl    $0x2,%eax
 2bc:	01 d0                	add    %edx,%eax
 2be:	01 c0                	add    %eax,%eax
 2c0:	89 c1                	mov    %eax,%ecx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 08             	mov    %edx,0x8(%ebp)
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	0f be c0             	movsbl %al,%eax
 2d1:	01 c8                	add    %ecx,%eax
 2d3:	83 e8 30             	sub    $0x30,%eax
 2d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 2f                	cmp    $0x2f,%al
 2e1:	7e 0a                	jle    2ed <atoi+0x48>
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 39                	cmp    $0x39,%al
 2eb:	7e c7                	jle    2b4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f0:	c9                   	leave  
 2f1:	c3                   	ret    

000002f2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 301:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 304:	eb 17                	jmp    31d <memmove+0x2b>
    *dst++ = *src++;
 306:	8b 45 fc             	mov    -0x4(%ebp),%eax
 309:	8d 50 01             	lea    0x1(%eax),%edx
 30c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 30f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 312:	8d 4a 01             	lea    0x1(%edx),%ecx
 315:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 318:	0f b6 12             	movzbl (%edx),%edx
 31b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31d:	8b 45 10             	mov    0x10(%ebp),%eax
 320:	8d 50 ff             	lea    -0x1(%eax),%edx
 323:	89 55 10             	mov    %edx,0x10(%ebp)
 326:	85 c0                	test   %eax,%eax
 328:	7f dc                	jg     306 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 32d:	c9                   	leave  
 32e:	c3                   	ret    

0000032f <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 32f:	55                   	push   %ebp
 330:	89 e5                	mov    %esp,%ebp
 332:	53                   	push   %ebx
 333:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	89 45 f0             	mov    %eax,-0x10(%ebp)
 33c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 340:	79 03                	jns    345 <itoa+0x16>
         n = -n;          /* make n positive */
 342:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 34c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34f:	8d 50 01             	lea    0x1(%eax),%edx
 352:	89 55 f4             	mov    %edx,-0xc(%ebp)
 355:	89 c2                	mov    %eax,%edx
 357:	8b 45 0c             	mov    0xc(%ebp),%eax
 35a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 35d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 360:	ba 67 66 66 66       	mov    $0x66666667,%edx
 365:	89 c8                	mov    %ecx,%eax
 367:	f7 ea                	imul   %edx
 369:	c1 fa 02             	sar    $0x2,%edx
 36c:	89 c8                	mov    %ecx,%eax
 36e:	c1 f8 1f             	sar    $0x1f,%eax
 371:	29 c2                	sub    %eax,%edx
 373:	89 d0                	mov    %edx,%eax
 375:	c1 e0 02             	shl    $0x2,%eax
 378:	01 d0                	add    %edx,%eax
 37a:	01 c0                	add    %eax,%eax
 37c:	29 c1                	sub    %eax,%ecx
 37e:	89 ca                	mov    %ecx,%edx
 380:	89 d0                	mov    %edx,%eax
 382:	83 c0 30             	add    $0x30,%eax
 385:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 387:	8b 4d 08             	mov    0x8(%ebp),%ecx
 38a:	ba 67 66 66 66       	mov    $0x66666667,%edx
 38f:	89 c8                	mov    %ecx,%eax
 391:	f7 ea                	imul   %edx
 393:	c1 fa 02             	sar    $0x2,%edx
 396:	89 c8                	mov    %ecx,%eax
 398:	c1 f8 1f             	sar    $0x1f,%eax
 39b:	29 c2                	sub    %eax,%edx
 39d:	89 d0                	mov    %edx,%eax
 39f:	89 45 08             	mov    %eax,0x8(%ebp)
 3a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a6:	7f a4                	jg     34c <itoa+0x1d>
     if (sign < 0)
 3a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ac:	79 13                	jns    3c1 <itoa+0x92>
         s[i++] = '-';
 3ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b1:	8d 50 01             	lea    0x1(%eax),%edx
 3b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3b7:	89 c2                	mov    %eax,%edx
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	01 d0                	add    %edx,%eax
 3be:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 3c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	01 d0                	add    %edx,%eax
 3c9:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	89 04 24             	mov    %eax,(%esp)
 3d2:	e8 ba fc ff ff       	call   91 <reverse>
 }
 3d7:	83 c4 24             	add    $0x24,%esp
 3da:	5b                   	pop    %ebx
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    

000003dd <strcat>:

char *
strcat(char *dest, const char *src)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ea:	eb 04                	jmp    3f0 <strcat+0x13>
 3ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	01 d0                	add    %edx,%eax
 3f8:	0f b6 00             	movzbl (%eax),%eax
 3fb:	84 c0                	test   %al,%al
 3fd:	75 ed                	jne    3ec <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 3ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 406:	eb 20                	jmp    428 <strcat+0x4b>
        dest[i+j] = src[j];
 408:	8b 45 f8             	mov    -0x8(%ebp),%eax
 40b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40e:	01 d0                	add    %edx,%eax
 410:	89 c2                	mov    %eax,%edx
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	01 c2                	add    %eax,%edx
 417:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	01 c8                	add    %ecx,%eax
 41f:	0f b6 00             	movzbl (%eax),%eax
 422:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 424:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 428:	8b 55 f8             	mov    -0x8(%ebp),%edx
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	01 d0                	add    %edx,%eax
 430:	0f b6 00             	movzbl (%eax),%eax
 433:	84 c0                	test   %al,%al
 435:	75 d1                	jne    408 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 437:	8b 45 f8             	mov    -0x8(%ebp),%eax
 43a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 43d:	01 d0                	add    %edx,%eax
 43f:	89 c2                	mov    %eax,%edx
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	01 d0                	add    %edx,%eax
 446:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 449:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44c:	c9                   	leave  
 44d:	c3                   	ret    

0000044e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44e:	b8 01 00 00 00       	mov    $0x1,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <exit>:
SYSCALL(exit)
 456:	b8 02 00 00 00       	mov    $0x2,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <wait>:
SYSCALL(wait)
 45e:	b8 03 00 00 00       	mov    $0x3,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <pipe>:
SYSCALL(pipe)
 466:	b8 04 00 00 00       	mov    $0x4,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <read>:
SYSCALL(read)
 46e:	b8 05 00 00 00       	mov    $0x5,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <write>:
SYSCALL(write)
 476:	b8 10 00 00 00       	mov    $0x10,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <close>:
SYSCALL(close)
 47e:	b8 15 00 00 00       	mov    $0x15,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <kill>:
SYSCALL(kill)
 486:	b8 06 00 00 00       	mov    $0x6,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <exec>:
SYSCALL(exec)
 48e:	b8 07 00 00 00       	mov    $0x7,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <open>:
SYSCALL(open)
 496:	b8 0f 00 00 00       	mov    $0xf,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <mknod>:
SYSCALL(mknod)
 49e:	b8 11 00 00 00       	mov    $0x11,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <unlink>:
SYSCALL(unlink)
 4a6:	b8 12 00 00 00       	mov    $0x12,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <fstat>:
SYSCALL(fstat)
 4ae:	b8 08 00 00 00       	mov    $0x8,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <link>:
SYSCALL(link)
 4b6:	b8 13 00 00 00       	mov    $0x13,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <mkdir>:
SYSCALL(mkdir)
 4be:	b8 14 00 00 00       	mov    $0x14,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <chdir>:
SYSCALL(chdir)
 4c6:	b8 09 00 00 00       	mov    $0x9,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <dup>:
SYSCALL(dup)
 4ce:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <getpid>:
SYSCALL(getpid)
 4d6:	b8 0b 00 00 00       	mov    $0xb,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <sbrk>:
SYSCALL(sbrk)
 4de:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <sleep>:
SYSCALL(sleep)
 4e6:	b8 0d 00 00 00       	mov    $0xd,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <uptime>:
SYSCALL(uptime)
 4ee:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <wait2>:
SYSCALL(wait2)
 4f6:	b8 16 00 00 00       	mov    $0x16,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <set_priority>:
SYSCALL(set_priority)
 4fe:	b8 17 00 00 00       	mov    $0x17,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <get_sched_record>:
SYSCALL(get_sched_record)
 506:	b8 18 00 00 00       	mov    $0x18,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	83 ec 18             	sub    $0x18,%esp
 514:	8b 45 0c             	mov    0xc(%ebp),%eax
 517:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 51a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 521:	00 
 522:	8d 45 f4             	lea    -0xc(%ebp),%eax
 525:	89 44 24 04          	mov    %eax,0x4(%esp)
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	89 04 24             	mov    %eax,(%esp)
 52f:	e8 42 ff ff ff       	call   476 <write>
}
 534:	c9                   	leave  
 535:	c3                   	ret    

00000536 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 536:	55                   	push   %ebp
 537:	89 e5                	mov    %esp,%ebp
 539:	56                   	push   %esi
 53a:	53                   	push   %ebx
 53b:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 53e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 545:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 549:	74 17                	je     562 <printint+0x2c>
 54b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 54f:	79 11                	jns    562 <printint+0x2c>
    neg = 1;
 551:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 558:	8b 45 0c             	mov    0xc(%ebp),%eax
 55b:	f7 d8                	neg    %eax
 55d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 560:	eb 06                	jmp    568 <printint+0x32>
  } else {
    x = xx;
 562:	8b 45 0c             	mov    0xc(%ebp),%eax
 565:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 568:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 56f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 572:	8d 41 01             	lea    0x1(%ecx),%eax
 575:	89 45 f4             	mov    %eax,-0xc(%ebp)
 578:	8b 5d 10             	mov    0x10(%ebp),%ebx
 57b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 57e:	ba 00 00 00 00       	mov    $0x0,%edx
 583:	f7 f3                	div    %ebx
 585:	89 d0                	mov    %edx,%eax
 587:	0f b6 80 74 0c 00 00 	movzbl 0xc74(%eax),%eax
 58e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 592:	8b 75 10             	mov    0x10(%ebp),%esi
 595:	8b 45 ec             	mov    -0x14(%ebp),%eax
 598:	ba 00 00 00 00       	mov    $0x0,%edx
 59d:	f7 f6                	div    %esi
 59f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a6:	75 c7                	jne    56f <printint+0x39>
  if(neg)
 5a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ac:	74 10                	je     5be <printint+0x88>
    buf[i++] = '-';
 5ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b1:	8d 50 01             	lea    0x1(%eax),%edx
 5b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5bc:	eb 1f                	jmp    5dd <printint+0xa7>
 5be:	eb 1d                	jmp    5dd <printint+0xa7>
    putc(fd, buf[i]);
 5c0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c6:	01 d0                	add    %edx,%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	0f be c0             	movsbl %al,%eax
 5ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	89 04 24             	mov    %eax,(%esp)
 5d8:	e8 31 ff ff ff       	call   50e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e5:	79 d9                	jns    5c0 <printint+0x8a>
    putc(fd, buf[i]);
}
 5e7:	83 c4 30             	add    $0x30,%esp
 5ea:	5b                   	pop    %ebx
 5eb:	5e                   	pop    %esi
 5ec:	5d                   	pop    %ebp
 5ed:	c3                   	ret    

000005ee <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ee:	55                   	push   %ebp
 5ef:	89 e5                	mov    %esp,%ebp
 5f1:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5fb:	8d 45 0c             	lea    0xc(%ebp),%eax
 5fe:	83 c0 04             	add    $0x4,%eax
 601:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 60b:	e9 7c 01 00 00       	jmp    78c <printf+0x19e>
    c = fmt[i] & 0xff;
 610:	8b 55 0c             	mov    0xc(%ebp),%edx
 613:	8b 45 f0             	mov    -0x10(%ebp),%eax
 616:	01 d0                	add    %edx,%eax
 618:	0f b6 00             	movzbl (%eax),%eax
 61b:	0f be c0             	movsbl %al,%eax
 61e:	25 ff 00 00 00       	and    $0xff,%eax
 623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 626:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 62a:	75 2c                	jne    658 <printf+0x6a>
      if(c == '%'){
 62c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 630:	75 0c                	jne    63e <printf+0x50>
        state = '%';
 632:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 639:	e9 4a 01 00 00       	jmp    788 <printf+0x19a>
      } else {
        putc(fd, c);
 63e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 641:	0f be c0             	movsbl %al,%eax
 644:	89 44 24 04          	mov    %eax,0x4(%esp)
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	89 04 24             	mov    %eax,(%esp)
 64e:	e8 bb fe ff ff       	call   50e <putc>
 653:	e9 30 01 00 00       	jmp    788 <printf+0x19a>
      }
    } else if(state == '%'){
 658:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 65c:	0f 85 26 01 00 00    	jne    788 <printf+0x19a>
      if(c == 'd'){
 662:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 666:	75 2d                	jne    695 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 668:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 674:	00 
 675:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 67c:	00 
 67d:	89 44 24 04          	mov    %eax,0x4(%esp)
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	89 04 24             	mov    %eax,(%esp)
 687:	e8 aa fe ff ff       	call   536 <printint>
        ap++;
 68c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 690:	e9 ec 00 00 00       	jmp    781 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 695:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 699:	74 06                	je     6a1 <printf+0xb3>
 69b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 69f:	75 2d                	jne    6ce <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6ad:	00 
 6ae:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6b5:	00 
 6b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	89 04 24             	mov    %eax,(%esp)
 6c0:	e8 71 fe ff ff       	call   536 <printint>
        ap++;
 6c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c9:	e9 b3 00 00 00       	jmp    781 <printf+0x193>
      } else if(c == 's'){
 6ce:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d2:	75 45                	jne    719 <printf+0x12b>
        s = (char*)*ap;
 6d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e4:	75 09                	jne    6ef <printf+0x101>
          s = "(null)";
 6e6:	c7 45 f4 c3 09 00 00 	movl   $0x9c3,-0xc(%ebp)
        while(*s != 0){
 6ed:	eb 1e                	jmp    70d <printf+0x11f>
 6ef:	eb 1c                	jmp    70d <printf+0x11f>
          putc(fd, *s);
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	0f b6 00             	movzbl (%eax),%eax
 6f7:	0f be c0             	movsbl %al,%eax
 6fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	89 04 24             	mov    %eax,(%esp)
 704:	e8 05 fe ff ff       	call   50e <putc>
          s++;
 709:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	0f b6 00             	movzbl (%eax),%eax
 713:	84 c0                	test   %al,%al
 715:	75 da                	jne    6f1 <printf+0x103>
 717:	eb 68                	jmp    781 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 719:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 71d:	75 1d                	jne    73c <printf+0x14e>
        putc(fd, *ap);
 71f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	0f be c0             	movsbl %al,%eax
 727:	89 44 24 04          	mov    %eax,0x4(%esp)
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	89 04 24             	mov    %eax,(%esp)
 731:	e8 d8 fd ff ff       	call   50e <putc>
        ap++;
 736:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73a:	eb 45                	jmp    781 <printf+0x193>
      } else if(c == '%'){
 73c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 740:	75 17                	jne    759 <printf+0x16b>
        putc(fd, c);
 742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 745:	0f be c0             	movsbl %al,%eax
 748:	89 44 24 04          	mov    %eax,0x4(%esp)
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	89 04 24             	mov    %eax,(%esp)
 752:	e8 b7 fd ff ff       	call   50e <putc>
 757:	eb 28                	jmp    781 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 759:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 760:	00 
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	89 04 24             	mov    %eax,(%esp)
 767:	e8 a2 fd ff ff       	call   50e <putc>
        putc(fd, c);
 76c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76f:	0f be c0             	movsbl %al,%eax
 772:	89 44 24 04          	mov    %eax,0x4(%esp)
 776:	8b 45 08             	mov    0x8(%ebp),%eax
 779:	89 04 24             	mov    %eax,(%esp)
 77c:	e8 8d fd ff ff       	call   50e <putc>
      }
      state = 0;
 781:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 788:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 78c:	8b 55 0c             	mov    0xc(%ebp),%edx
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	01 d0                	add    %edx,%eax
 794:	0f b6 00             	movzbl (%eax),%eax
 797:	84 c0                	test   %al,%al
 799:	0f 85 71 fe ff ff    	jne    610 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 79f:	c9                   	leave  
 7a0:	c3                   	ret    

000007a1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a1:	55                   	push   %ebp
 7a2:	89 e5                	mov    %esp,%ebp
 7a4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a7:	8b 45 08             	mov    0x8(%ebp),%eax
 7aa:	83 e8 08             	sub    $0x8,%eax
 7ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	a1 90 0c 00 00       	mov    0xc90,%eax
 7b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b8:	eb 24                	jmp    7de <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c2:	77 12                	ja     7d6 <free+0x35>
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ca:	77 24                	ja     7f0 <free+0x4f>
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d4:	77 1a                	ja     7f0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8b 00                	mov    (%eax),%eax
 7db:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e4:	76 d4                	jbe    7ba <free+0x19>
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ee:	76 ca                	jbe    7ba <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	01 c2                	add    %eax,%edx
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	39 c2                	cmp    %eax,%edx
 809:	75 24                	jne    82f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	8b 50 04             	mov    0x4(%eax),%edx
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	01 c2                	add    %eax,%edx
 81b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82b:	89 10                	mov    %edx,(%eax)
 82d:	eb 0a                	jmp    839 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 10                	mov    (%eax),%edx
 834:	8b 45 f8             	mov    -0x8(%ebp),%eax
 837:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	8b 40 04             	mov    0x4(%eax),%eax
 83f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	01 d0                	add    %edx,%eax
 84b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84e:	75 20                	jne    870 <free+0xcf>
    p->s.size += bp->s.size;
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	8b 50 04             	mov    0x4(%eax),%edx
 856:	8b 45 f8             	mov    -0x8(%ebp),%eax
 859:	8b 40 04             	mov    0x4(%eax),%eax
 85c:	01 c2                	add    %eax,%edx
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 864:	8b 45 f8             	mov    -0x8(%ebp),%eax
 867:	8b 10                	mov    (%eax),%edx
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	89 10                	mov    %edx,(%eax)
 86e:	eb 08                	jmp    878 <free+0xd7>
  } else
    p->s.ptr = bp;
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 55 f8             	mov    -0x8(%ebp),%edx
 876:	89 10                	mov    %edx,(%eax)
  freep = p;
 878:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87b:	a3 90 0c 00 00       	mov    %eax,0xc90
}
 880:	c9                   	leave  
 881:	c3                   	ret    

00000882 <morecore>:

static Header*
morecore(uint nu)
{
 882:	55                   	push   %ebp
 883:	89 e5                	mov    %esp,%ebp
 885:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 888:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 88f:	77 07                	ja     898 <morecore+0x16>
    nu = 4096;
 891:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 898:	8b 45 08             	mov    0x8(%ebp),%eax
 89b:	c1 e0 03             	shl    $0x3,%eax
 89e:	89 04 24             	mov    %eax,(%esp)
 8a1:	e8 38 fc ff ff       	call   4de <sbrk>
 8a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8ad:	75 07                	jne    8b6 <morecore+0x34>
    return 0;
 8af:	b8 00 00 00 00       	mov    $0x0,%eax
 8b4:	eb 22                	jmp    8d8 <morecore+0x56>
  hp = (Header*)p;
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	8b 55 08             	mov    0x8(%ebp),%edx
 8c2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c8:	83 c0 08             	add    $0x8,%eax
 8cb:	89 04 24             	mov    %eax,(%esp)
 8ce:	e8 ce fe ff ff       	call   7a1 <free>
  return freep;
 8d3:	a1 90 0c 00 00       	mov    0xc90,%eax
}
 8d8:	c9                   	leave  
 8d9:	c3                   	ret    

000008da <malloc>:

void*
malloc(uint nbytes)
{
 8da:	55                   	push   %ebp
 8db:	89 e5                	mov    %esp,%ebp
 8dd:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e0:	8b 45 08             	mov    0x8(%ebp),%eax
 8e3:	83 c0 07             	add    $0x7,%eax
 8e6:	c1 e8 03             	shr    $0x3,%eax
 8e9:	83 c0 01             	add    $0x1,%eax
 8ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ef:	a1 90 0c 00 00       	mov    0xc90,%eax
 8f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8fb:	75 23                	jne    920 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8fd:	c7 45 f0 88 0c 00 00 	movl   $0xc88,-0x10(%ebp)
 904:	8b 45 f0             	mov    -0x10(%ebp),%eax
 907:	a3 90 0c 00 00       	mov    %eax,0xc90
 90c:	a1 90 0c 00 00       	mov    0xc90,%eax
 911:	a3 88 0c 00 00       	mov    %eax,0xc88
    base.s.size = 0;
 916:	c7 05 8c 0c 00 00 00 	movl   $0x0,0xc8c
 91d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	8b 45 f0             	mov    -0x10(%ebp),%eax
 923:	8b 00                	mov    (%eax),%eax
 925:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 928:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 931:	72 4d                	jb     980 <malloc+0xa6>
      if(p->s.size == nunits)
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	8b 40 04             	mov    0x4(%eax),%eax
 939:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93c:	75 0c                	jne    94a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	8b 10                	mov    (%eax),%edx
 943:	8b 45 f0             	mov    -0x10(%ebp),%eax
 946:	89 10                	mov    %edx,(%eax)
 948:	eb 26                	jmp    970 <malloc+0x96>
      else {
        p->s.size -= nunits;
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	8b 40 04             	mov    0x4(%eax),%eax
 950:	2b 45 ec             	sub    -0x14(%ebp),%eax
 953:	89 c2                	mov    %eax,%edx
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	8b 40 04             	mov    0x4(%eax),%eax
 961:	c1 e0 03             	shl    $0x3,%eax
 964:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 96d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 970:	8b 45 f0             	mov    -0x10(%ebp),%eax
 973:	a3 90 0c 00 00       	mov    %eax,0xc90
      return (void*)(p + 1);
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	83 c0 08             	add    $0x8,%eax
 97e:	eb 38                	jmp    9b8 <malloc+0xde>
    }
    if(p == freep)
 980:	a1 90 0c 00 00       	mov    0xc90,%eax
 985:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 988:	75 1b                	jne    9a5 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 98a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 98d:	89 04 24             	mov    %eax,(%esp)
 990:	e8 ed fe ff ff       	call   882 <morecore>
 995:	89 45 f4             	mov    %eax,-0xc(%ebp)
 998:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 99c:	75 07                	jne    9a5 <malloc+0xcb>
        return 0;
 99e:	b8 00 00 00 00       	mov    $0x0,%eax
 9a3:	eb 13                	jmp    9b8 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	8b 00                	mov    (%eax),%eax
 9b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9b3:	e9 70 ff ff ff       	jmp    928 <malloc+0x4e>
}
 9b8:	c9                   	leave  
 9b9:	c3                   	ret    
