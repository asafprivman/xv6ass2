
_mkdir:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 dd 09 00 	movl   $0x9dd,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 ee 05 00 00       	call   611 <printf>
    exit();
  23:	e8 51 04 00 00       	call   479 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 95 04 00 00       	call   4e1 <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 f4 09 00 	movl   $0x9f4,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 97 05 00 00       	call   611 <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  8a:	e8 ea 03 00 00       	call   479 <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	89 04 24             	mov    %eax,(%esp)
  c7:	e8 ba 00 00 00       	call   186 <strlen>
  cc:	83 e8 01             	sub    $0x1,%eax
  cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  d2:	eb 39                	jmp    10d <reverse+0x59>
         c = s[i];
  d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
  e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	01 c2                	add    %eax,%edx
  ea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	01 c8                	add    %ecx,%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	88 02                	mov    %al,(%edx)
         s[j] = c;
  f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	01 c2                	add    %eax,%edx
  ff:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 103:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 105:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 109:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 10d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 110:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 113:	7c bf                	jl     d4 <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 115:	c9                   	leave  
 116:	c3                   	ret    

00000117 <strcpy>:

char*
strcpy(char *s, char *t)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 123:	90                   	nop
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	8d 50 01             	lea    0x1(%eax),%edx
 12a:	89 55 08             	mov    %edx,0x8(%ebp)
 12d:	8b 55 0c             	mov    0xc(%ebp),%edx
 130:	8d 4a 01             	lea    0x1(%edx),%ecx
 133:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 136:	0f b6 12             	movzbl (%edx),%edx
 139:	88 10                	mov    %dl,(%eax)
 13b:	0f b6 00             	movzbl (%eax),%eax
 13e:	84 c0                	test   %al,%al
 140:	75 e2                	jne    124 <strcpy+0xd>
    ;
  return os;
 142:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 145:	c9                   	leave  
 146:	c3                   	ret    

00000147 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 14a:	eb 08                	jmp    154 <strcmp+0xd>
    p++, q++;
 14c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 150:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	74 10                	je     16e <strcmp+0x27>
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	0f b6 10             	movzbl (%eax),%edx
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	38 c2                	cmp    %al,%dl
 16c:	74 de                	je     14c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	0f b6 d0             	movzbl %al,%edx
 177:	8b 45 0c             	mov    0xc(%ebp),%eax
 17a:	0f b6 00             	movzbl (%eax),%eax
 17d:	0f b6 c0             	movzbl %al,%eax
 180:	29 c2                	sub    %eax,%edx
 182:	89 d0                	mov    %edx,%eax
}
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    

00000186 <strlen>:

uint
strlen(char *s)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 18c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 193:	eb 04                	jmp    199 <strlen+0x13>
 195:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 199:	8b 55 fc             	mov    -0x4(%ebp),%edx
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	01 d0                	add    %edx,%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	75 ed                	jne    195 <strlen+0xf>
    ;
  return n;
 1a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ab:	c9                   	leave  
 1ac:	c3                   	ret    

000001ad <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ad:	55                   	push   %ebp
 1ae:	89 e5                	mov    %esp,%ebp
 1b0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1b3:	8b 45 10             	mov    0x10(%ebp),%eax
 1b6:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	89 04 24             	mov    %eax,(%esp)
 1c7:	e8 c3 fe ff ff       	call   8f <stosb>
  return dst;
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1cf:	c9                   	leave  
 1d0:	c3                   	ret    

000001d1 <strchr>:

char*
strchr(const char *s, char c)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	83 ec 04             	sub    $0x4,%esp
 1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1da:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1dd:	eb 14                	jmp    1f3 <strchr+0x22>
    if(*s == c)
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	0f b6 00             	movzbl (%eax),%eax
 1e5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1e8:	75 05                	jne    1ef <strchr+0x1e>
      return (char*)s;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	eb 13                	jmp    202 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	84 c0                	test   %al,%al
 1fb:	75 e2                	jne    1df <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 202:	c9                   	leave  
 203:	c3                   	ret    

00000204 <gets>:

char*
gets(char *buf, int max)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 211:	eb 4c                	jmp    25f <gets+0x5b>
    cc = read(0, &c, 1);
 213:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 21a:	00 
 21b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 21e:	89 44 24 04          	mov    %eax,0x4(%esp)
 222:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 229:	e8 63 02 00 00       	call   491 <read>
 22e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 231:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 235:	7f 02                	jg     239 <gets+0x35>
      break;
 237:	eb 31                	jmp    26a <gets+0x66>
    buf[i++] = c;
 239:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23c:	8d 50 01             	lea    0x1(%eax),%edx
 23f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 242:	89 c2                	mov    %eax,%edx
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	01 c2                	add    %eax,%edx
 249:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 253:	3c 0a                	cmp    $0xa,%al
 255:	74 13                	je     26a <gets+0x66>
 257:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25b:	3c 0d                	cmp    $0xd,%al
 25d:	74 0b                	je     26a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	83 c0 01             	add    $0x1,%eax
 265:	3b 45 0c             	cmp    0xc(%ebp),%eax
 268:	7c a9                	jl     213 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 26a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	01 d0                	add    %edx,%eax
 272:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 275:	8b 45 08             	mov    0x8(%ebp),%eax
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <stat>:

int
stat(char *n, struct stat *st)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 280:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 287:	00 
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	89 04 24             	mov    %eax,(%esp)
 28e:	e8 26 02 00 00       	call   4b9 <open>
 293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 296:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 29a:	79 07                	jns    2a3 <stat+0x29>
    return -1;
 29c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a1:	eb 23                	jmp    2c6 <stat+0x4c>
  r = fstat(fd, st);
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 1c 02 00 00       	call   4d1 <fstat>
 2b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bb:	89 04 24             	mov    %eax,(%esp)
 2be:	e8 de 01 00 00       	call   4a1 <close>
  return r;
 2c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c6:	c9                   	leave  
 2c7:	c3                   	ret    

000002c8 <atoi>:

int
atoi(const char *s)
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d5:	eb 25                	jmp    2fc <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2da:	89 d0                	mov    %edx,%eax
 2dc:	c1 e0 02             	shl    $0x2,%eax
 2df:	01 d0                	add    %edx,%eax
 2e1:	01 c0                	add    %eax,%eax
 2e3:	89 c1                	mov    %eax,%ecx
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	8d 50 01             	lea    0x1(%eax),%edx
 2eb:	89 55 08             	mov    %edx,0x8(%ebp)
 2ee:	0f b6 00             	movzbl (%eax),%eax
 2f1:	0f be c0             	movsbl %al,%eax
 2f4:	01 c8                	add    %ecx,%eax
 2f6:	83 e8 30             	sub    $0x30,%eax
 2f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	3c 2f                	cmp    $0x2f,%al
 304:	7e 0a                	jle    310 <atoi+0x48>
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	3c 39                	cmp    $0x39,%al
 30e:	7e c7                	jle    2d7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 310:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 313:	c9                   	leave  
 314:	c3                   	ret    

00000315 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
 318:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 321:	8b 45 0c             	mov    0xc(%ebp),%eax
 324:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 327:	eb 17                	jmp    340 <memmove+0x2b>
    *dst++ = *src++;
 329:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32c:	8d 50 01             	lea    0x1(%eax),%edx
 32f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 332:	8b 55 f8             	mov    -0x8(%ebp),%edx
 335:	8d 4a 01             	lea    0x1(%edx),%ecx
 338:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 33b:	0f b6 12             	movzbl (%edx),%edx
 33e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 340:	8b 45 10             	mov    0x10(%ebp),%eax
 343:	8d 50 ff             	lea    -0x1(%eax),%edx
 346:	89 55 10             	mov    %edx,0x10(%ebp)
 349:	85 c0                	test   %eax,%eax
 34b:	7f dc                	jg     329 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 350:	c9                   	leave  
 351:	c3                   	ret    

00000352 <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	53                   	push   %ebx
 356:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 35f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 363:	79 03                	jns    368 <itoa+0x16>
         n = -n;          /* make n positive */
 365:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 36f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 372:	8d 50 01             	lea    0x1(%eax),%edx
 375:	89 55 f4             	mov    %edx,-0xc(%ebp)
 378:	89 c2                	mov    %eax,%edx
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 380:	8b 4d 08             	mov    0x8(%ebp),%ecx
 383:	ba 67 66 66 66       	mov    $0x66666667,%edx
 388:	89 c8                	mov    %ecx,%eax
 38a:	f7 ea                	imul   %edx
 38c:	c1 fa 02             	sar    $0x2,%edx
 38f:	89 c8                	mov    %ecx,%eax
 391:	c1 f8 1f             	sar    $0x1f,%eax
 394:	29 c2                	sub    %eax,%edx
 396:	89 d0                	mov    %edx,%eax
 398:	c1 e0 02             	shl    $0x2,%eax
 39b:	01 d0                	add    %edx,%eax
 39d:	01 c0                	add    %eax,%eax
 39f:	29 c1                	sub    %eax,%ecx
 3a1:	89 ca                	mov    %ecx,%edx
 3a3:	89 d0                	mov    %edx,%eax
 3a5:	83 c0 30             	add    $0x30,%eax
 3a8:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 3aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3ad:	ba 67 66 66 66       	mov    $0x66666667,%edx
 3b2:	89 c8                	mov    %ecx,%eax
 3b4:	f7 ea                	imul   %edx
 3b6:	c1 fa 02             	sar    $0x2,%edx
 3b9:	89 c8                	mov    %ecx,%eax
 3bb:	c1 f8 1f             	sar    $0x1f,%eax
 3be:	29 c2                	sub    %eax,%edx
 3c0:	89 d0                	mov    %edx,%eax
 3c2:	89 45 08             	mov    %eax,0x8(%ebp)
 3c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3c9:	7f a4                	jg     36f <itoa+0x1d>
     if (sign < 0)
 3cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3cf:	79 13                	jns    3e4 <itoa+0x92>
         s[i++] = '-';
 3d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d4:	8d 50 01             	lea    0x1(%eax),%edx
 3d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3da:	89 c2                	mov    %eax,%edx
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	01 d0                	add    %edx,%eax
 3e1:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 3e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ea:	01 d0                	add    %edx,%eax
 3ec:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f2:	89 04 24             	mov    %eax,(%esp)
 3f5:	e8 ba fc ff ff       	call   b4 <reverse>
 }
 3fa:	83 c4 24             	add    $0x24,%esp
 3fd:	5b                   	pop    %ebx
 3fe:	5d                   	pop    %ebp
 3ff:	c3                   	ret    

00000400 <strcat>:

char *
strcat(char *dest, const char *src)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 406:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 40d:	eb 04                	jmp    413 <strcat+0x13>
 40f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 413:	8b 55 fc             	mov    -0x4(%ebp),%edx
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	01 d0                	add    %edx,%eax
 41b:	0f b6 00             	movzbl (%eax),%eax
 41e:	84 c0                	test   %al,%al
 420:	75 ed                	jne    40f <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 422:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 429:	eb 20                	jmp    44b <strcat+0x4b>
        dest[i+j] = src[j];
 42b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 42e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 431:	01 d0                	add    %edx,%eax
 433:	89 c2                	mov    %eax,%edx
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	01 c2                	add    %eax,%edx
 43a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 43d:	8b 45 0c             	mov    0xc(%ebp),%eax
 440:	01 c8                	add    %ecx,%eax
 442:	0f b6 00             	movzbl (%eax),%eax
 445:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 447:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 44b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	01 d0                	add    %edx,%eax
 453:	0f b6 00             	movzbl (%eax),%eax
 456:	84 c0                	test   %al,%al
 458:	75 d1                	jne    42b <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 45a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 45d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 460:	01 d0                	add    %edx,%eax
 462:	89 c2                	mov    %eax,%edx
 464:	8b 45 08             	mov    0x8(%ebp),%eax
 467:	01 d0                	add    %edx,%eax
 469:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 46f:	c9                   	leave  
 470:	c3                   	ret    

00000471 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 471:	b8 01 00 00 00       	mov    $0x1,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <exit>:
SYSCALL(exit)
 479:	b8 02 00 00 00       	mov    $0x2,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <wait>:
SYSCALL(wait)
 481:	b8 03 00 00 00       	mov    $0x3,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <pipe>:
SYSCALL(pipe)
 489:	b8 04 00 00 00       	mov    $0x4,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <read>:
SYSCALL(read)
 491:	b8 05 00 00 00       	mov    $0x5,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <write>:
SYSCALL(write)
 499:	b8 10 00 00 00       	mov    $0x10,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <close>:
SYSCALL(close)
 4a1:	b8 15 00 00 00       	mov    $0x15,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <kill>:
SYSCALL(kill)
 4a9:	b8 06 00 00 00       	mov    $0x6,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <exec>:
SYSCALL(exec)
 4b1:	b8 07 00 00 00       	mov    $0x7,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <open>:
SYSCALL(open)
 4b9:	b8 0f 00 00 00       	mov    $0xf,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <mknod>:
SYSCALL(mknod)
 4c1:	b8 11 00 00 00       	mov    $0x11,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <unlink>:
SYSCALL(unlink)
 4c9:	b8 12 00 00 00       	mov    $0x12,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <fstat>:
SYSCALL(fstat)
 4d1:	b8 08 00 00 00       	mov    $0x8,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <link>:
SYSCALL(link)
 4d9:	b8 13 00 00 00       	mov    $0x13,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <mkdir>:
SYSCALL(mkdir)
 4e1:	b8 14 00 00 00       	mov    $0x14,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <chdir>:
SYSCALL(chdir)
 4e9:	b8 09 00 00 00       	mov    $0x9,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <dup>:
SYSCALL(dup)
 4f1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <getpid>:
SYSCALL(getpid)
 4f9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <sbrk>:
SYSCALL(sbrk)
 501:	b8 0c 00 00 00       	mov    $0xc,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <sleep>:
SYSCALL(sleep)
 509:	b8 0d 00 00 00       	mov    $0xd,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <uptime>:
SYSCALL(uptime)
 511:	b8 0e 00 00 00       	mov    $0xe,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <wait2>:
SYSCALL(wait2)
 519:	b8 16 00 00 00       	mov    $0x16,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <set_priority>:
SYSCALL(set_priority)
 521:	b8 17 00 00 00       	mov    $0x17,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <get_sched_record>:
SYSCALL(get_sched_record)
 529:	b8 18 00 00 00       	mov    $0x18,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	83 ec 18             	sub    $0x18,%esp
 537:	8b 45 0c             	mov    0xc(%ebp),%eax
 53a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 53d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 544:	00 
 545:	8d 45 f4             	lea    -0xc(%ebp),%eax
 548:	89 44 24 04          	mov    %eax,0x4(%esp)
 54c:	8b 45 08             	mov    0x8(%ebp),%eax
 54f:	89 04 24             	mov    %eax,(%esp)
 552:	e8 42 ff ff ff       	call   499 <write>
}
 557:	c9                   	leave  
 558:	c3                   	ret    

00000559 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 559:	55                   	push   %ebp
 55a:	89 e5                	mov    %esp,%ebp
 55c:	56                   	push   %esi
 55d:	53                   	push   %ebx
 55e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 561:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 568:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 56c:	74 17                	je     585 <printint+0x2c>
 56e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 572:	79 11                	jns    585 <printint+0x2c>
    neg = 1;
 574:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 57b:	8b 45 0c             	mov    0xc(%ebp),%eax
 57e:	f7 d8                	neg    %eax
 580:	89 45 ec             	mov    %eax,-0x14(%ebp)
 583:	eb 06                	jmp    58b <printint+0x32>
  } else {
    x = xx;
 585:	8b 45 0c             	mov    0xc(%ebp),%eax
 588:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 58b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 592:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 595:	8d 41 01             	lea    0x1(%ecx),%eax
 598:	89 45 f4             	mov    %eax,-0xc(%ebp)
 59b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 59e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a1:	ba 00 00 00 00       	mov    $0x0,%edx
 5a6:	f7 f3                	div    %ebx
 5a8:	89 d0                	mov    %edx,%eax
 5aa:	0f b6 80 c0 0c 00 00 	movzbl 0xcc0(%eax),%eax
 5b1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5b5:	8b 75 10             	mov    0x10(%ebp),%esi
 5b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bb:	ba 00 00 00 00       	mov    $0x0,%edx
 5c0:	f7 f6                	div    %esi
 5c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c9:	75 c7                	jne    592 <printint+0x39>
  if(neg)
 5cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5cf:	74 10                	je     5e1 <printint+0x88>
    buf[i++] = '-';
 5d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d4:	8d 50 01             	lea    0x1(%eax),%edx
 5d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5da:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5df:	eb 1f                	jmp    600 <printint+0xa7>
 5e1:	eb 1d                	jmp    600 <printint+0xa7>
    putc(fd, buf[i]);
 5e3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e9:	01 d0                	add    %edx,%eax
 5eb:	0f b6 00             	movzbl (%eax),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f5:	8b 45 08             	mov    0x8(%ebp),%eax
 5f8:	89 04 24             	mov    %eax,(%esp)
 5fb:	e8 31 ff ff ff       	call   531 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 600:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 608:	79 d9                	jns    5e3 <printint+0x8a>
    putc(fd, buf[i]);
}
 60a:	83 c4 30             	add    $0x30,%esp
 60d:	5b                   	pop    %ebx
 60e:	5e                   	pop    %esi
 60f:	5d                   	pop    %ebp
 610:	c3                   	ret    

00000611 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 611:	55                   	push   %ebp
 612:	89 e5                	mov    %esp,%ebp
 614:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 617:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 61e:	8d 45 0c             	lea    0xc(%ebp),%eax
 621:	83 c0 04             	add    $0x4,%eax
 624:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 627:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 62e:	e9 7c 01 00 00       	jmp    7af <printf+0x19e>
    c = fmt[i] & 0xff;
 633:	8b 55 0c             	mov    0xc(%ebp),%edx
 636:	8b 45 f0             	mov    -0x10(%ebp),%eax
 639:	01 d0                	add    %edx,%eax
 63b:	0f b6 00             	movzbl (%eax),%eax
 63e:	0f be c0             	movsbl %al,%eax
 641:	25 ff 00 00 00       	and    $0xff,%eax
 646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 649:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64d:	75 2c                	jne    67b <printf+0x6a>
      if(c == '%'){
 64f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 653:	75 0c                	jne    661 <printf+0x50>
        state = '%';
 655:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 65c:	e9 4a 01 00 00       	jmp    7ab <printf+0x19a>
      } else {
        putc(fd, c);
 661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 664:	0f be c0             	movsbl %al,%eax
 667:	89 44 24 04          	mov    %eax,0x4(%esp)
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 bb fe ff ff       	call   531 <putc>
 676:	e9 30 01 00 00       	jmp    7ab <printf+0x19a>
      }
    } else if(state == '%'){
 67b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 67f:	0f 85 26 01 00 00    	jne    7ab <printf+0x19a>
      if(c == 'd'){
 685:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 689:	75 2d                	jne    6b8 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 68b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68e:	8b 00                	mov    (%eax),%eax
 690:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 697:	00 
 698:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 69f:	00 
 6a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	89 04 24             	mov    %eax,(%esp)
 6aa:	e8 aa fe ff ff       	call   559 <printint>
        ap++;
 6af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b3:	e9 ec 00 00 00       	jmp    7a4 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6b8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6bc:	74 06                	je     6c4 <printf+0xb3>
 6be:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6c2:	75 2d                	jne    6f1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6d0:	00 
 6d1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6d8:	00 
 6d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6dd:	8b 45 08             	mov    0x8(%ebp),%eax
 6e0:	89 04 24             	mov    %eax,(%esp)
 6e3:	e8 71 fe ff ff       	call   559 <printint>
        ap++;
 6e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ec:	e9 b3 00 00 00       	jmp    7a4 <printf+0x193>
      } else if(c == 's'){
 6f1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6f5:	75 45                	jne    73c <printf+0x12b>
        s = (char*)*ap;
 6f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 707:	75 09                	jne    712 <printf+0x101>
          s = "(null)";
 709:	c7 45 f4 10 0a 00 00 	movl   $0xa10,-0xc(%ebp)
        while(*s != 0){
 710:	eb 1e                	jmp    730 <printf+0x11f>
 712:	eb 1c                	jmp    730 <printf+0x11f>
          putc(fd, *s);
 714:	8b 45 f4             	mov    -0xc(%ebp),%eax
 717:	0f b6 00             	movzbl (%eax),%eax
 71a:	0f be c0             	movsbl %al,%eax
 71d:	89 44 24 04          	mov    %eax,0x4(%esp)
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 05 fe ff ff       	call   531 <putc>
          s++;
 72c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 730:	8b 45 f4             	mov    -0xc(%ebp),%eax
 733:	0f b6 00             	movzbl (%eax),%eax
 736:	84 c0                	test   %al,%al
 738:	75 da                	jne    714 <printf+0x103>
 73a:	eb 68                	jmp    7a4 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 73c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 740:	75 1d                	jne    75f <printf+0x14e>
        putc(fd, *ap);
 742:	8b 45 e8             	mov    -0x18(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	0f be c0             	movsbl %al,%eax
 74a:	89 44 24 04          	mov    %eax,0x4(%esp)
 74e:	8b 45 08             	mov    0x8(%ebp),%eax
 751:	89 04 24             	mov    %eax,(%esp)
 754:	e8 d8 fd ff ff       	call   531 <putc>
        ap++;
 759:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 75d:	eb 45                	jmp    7a4 <printf+0x193>
      } else if(c == '%'){
 75f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 763:	75 17                	jne    77c <printf+0x16b>
        putc(fd, c);
 765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 768:	0f be c0             	movsbl %al,%eax
 76b:	89 44 24 04          	mov    %eax,0x4(%esp)
 76f:	8b 45 08             	mov    0x8(%ebp),%eax
 772:	89 04 24             	mov    %eax,(%esp)
 775:	e8 b7 fd ff ff       	call   531 <putc>
 77a:	eb 28                	jmp    7a4 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 77c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 783:	00 
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	89 04 24             	mov    %eax,(%esp)
 78a:	e8 a2 fd ff ff       	call   531 <putc>
        putc(fd, c);
 78f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 792:	0f be c0             	movsbl %al,%eax
 795:	89 44 24 04          	mov    %eax,0x4(%esp)
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	89 04 24             	mov    %eax,(%esp)
 79f:	e8 8d fd ff ff       	call   531 <putc>
      }
      state = 0;
 7a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7af:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b5:	01 d0                	add    %edx,%eax
 7b7:	0f b6 00             	movzbl (%eax),%eax
 7ba:	84 c0                	test   %al,%al
 7bc:	0f 85 71 fe ff ff    	jne    633 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7c2:	c9                   	leave  
 7c3:	c3                   	ret    

000007c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c4:	55                   	push   %ebp
 7c5:	89 e5                	mov    %esp,%ebp
 7c7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ca:	8b 45 08             	mov    0x8(%ebp),%eax
 7cd:	83 e8 08             	sub    $0x8,%eax
 7d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d3:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 7d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7db:	eb 24                	jmp    801 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e0:	8b 00                	mov    (%eax),%eax
 7e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e5:	77 12                	ja     7f9 <free+0x35>
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ed:	77 24                	ja     813 <free+0x4f>
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f7:	77 1a                	ja     813 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 801:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 807:	76 d4                	jbe    7dd <free+0x19>
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8b 00                	mov    (%eax),%eax
 80e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 811:	76 ca                	jbe    7dd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 813:	8b 45 f8             	mov    -0x8(%ebp),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 820:	8b 45 f8             	mov    -0x8(%ebp),%eax
 823:	01 c2                	add    %eax,%edx
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	8b 00                	mov    (%eax),%eax
 82a:	39 c2                	cmp    %eax,%edx
 82c:	75 24                	jne    852 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 82e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 831:	8b 50 04             	mov    0x4(%eax),%edx
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	8b 40 04             	mov    0x4(%eax),%eax
 83c:	01 c2                	add    %eax,%edx
 83e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 841:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	8b 10                	mov    (%eax),%edx
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	89 10                	mov    %edx,(%eax)
 850:	eb 0a                	jmp    85c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 852:	8b 45 fc             	mov    -0x4(%ebp),%eax
 855:	8b 10                	mov    (%eax),%edx
 857:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 85c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85f:	8b 40 04             	mov    0x4(%eax),%eax
 862:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	01 d0                	add    %edx,%eax
 86e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 871:	75 20                	jne    893 <free+0xcf>
    p->s.size += bp->s.size;
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	8b 50 04             	mov    0x4(%eax),%edx
 879:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87c:	8b 40 04             	mov    0x4(%eax),%eax
 87f:	01 c2                	add    %eax,%edx
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 887:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88a:	8b 10                	mov    (%eax),%edx
 88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88f:	89 10                	mov    %edx,(%eax)
 891:	eb 08                	jmp    89b <free+0xd7>
  } else
    p->s.ptr = bp;
 893:	8b 45 fc             	mov    -0x4(%ebp),%eax
 896:	8b 55 f8             	mov    -0x8(%ebp),%edx
 899:	89 10                	mov    %edx,(%eax)
  freep = p;
 89b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89e:	a3 dc 0c 00 00       	mov    %eax,0xcdc
}
 8a3:	c9                   	leave  
 8a4:	c3                   	ret    

000008a5 <morecore>:

static Header*
morecore(uint nu)
{
 8a5:	55                   	push   %ebp
 8a6:	89 e5                	mov    %esp,%ebp
 8a8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8ab:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8b2:	77 07                	ja     8bb <morecore+0x16>
    nu = 4096;
 8b4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	c1 e0 03             	shl    $0x3,%eax
 8c1:	89 04 24             	mov    %eax,(%esp)
 8c4:	e8 38 fc ff ff       	call   501 <sbrk>
 8c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8d0:	75 07                	jne    8d9 <morecore+0x34>
    return 0;
 8d2:	b8 00 00 00 00       	mov    $0x0,%eax
 8d7:	eb 22                	jmp    8fb <morecore+0x56>
  hp = (Header*)p;
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	8b 55 08             	mov    0x8(%ebp),%edx
 8e5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8eb:	83 c0 08             	add    $0x8,%eax
 8ee:	89 04 24             	mov    %eax,(%esp)
 8f1:	e8 ce fe ff ff       	call   7c4 <free>
  return freep;
 8f6:	a1 dc 0c 00 00       	mov    0xcdc,%eax
}
 8fb:	c9                   	leave  
 8fc:	c3                   	ret    

000008fd <malloc>:

void*
malloc(uint nbytes)
{
 8fd:	55                   	push   %ebp
 8fe:	89 e5                	mov    %esp,%ebp
 900:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 903:	8b 45 08             	mov    0x8(%ebp),%eax
 906:	83 c0 07             	add    $0x7,%eax
 909:	c1 e8 03             	shr    $0x3,%eax
 90c:	83 c0 01             	add    $0x1,%eax
 90f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 912:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 917:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 91e:	75 23                	jne    943 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 920:	c7 45 f0 d4 0c 00 00 	movl   $0xcd4,-0x10(%ebp)
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	a3 dc 0c 00 00       	mov    %eax,0xcdc
 92f:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 934:	a3 d4 0c 00 00       	mov    %eax,0xcd4
    base.s.size = 0;
 939:	c7 05 d8 0c 00 00 00 	movl   $0x0,0xcd8
 940:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 943:	8b 45 f0             	mov    -0x10(%ebp),%eax
 946:	8b 00                	mov    (%eax),%eax
 948:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 94b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94e:	8b 40 04             	mov    0x4(%eax),%eax
 951:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 954:	72 4d                	jb     9a3 <malloc+0xa6>
      if(p->s.size == nunits)
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	8b 40 04             	mov    0x4(%eax),%eax
 95c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 95f:	75 0c                	jne    96d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 961:	8b 45 f4             	mov    -0xc(%ebp),%eax
 964:	8b 10                	mov    (%eax),%edx
 966:	8b 45 f0             	mov    -0x10(%ebp),%eax
 969:	89 10                	mov    %edx,(%eax)
 96b:	eb 26                	jmp    993 <malloc+0x96>
      else {
        p->s.size -= nunits;
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	8b 40 04             	mov    0x4(%eax),%eax
 973:	2b 45 ec             	sub    -0x14(%ebp),%eax
 976:	89 c2                	mov    %eax,%edx
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	8b 40 04             	mov    0x4(%eax),%eax
 984:	c1 e0 03             	shl    $0x3,%eax
 987:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 990:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 993:	8b 45 f0             	mov    -0x10(%ebp),%eax
 996:	a3 dc 0c 00 00       	mov    %eax,0xcdc
      return (void*)(p + 1);
 99b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99e:	83 c0 08             	add    $0x8,%eax
 9a1:	eb 38                	jmp    9db <malloc+0xde>
    }
    if(p == freep)
 9a3:	a1 dc 0c 00 00       	mov    0xcdc,%eax
 9a8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9ab:	75 1b                	jne    9c8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9b0:	89 04 24             	mov    %eax,(%esp)
 9b3:	e8 ed fe ff ff       	call   8a5 <morecore>
 9b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9bf:	75 07                	jne    9c8 <malloc+0xcb>
        return 0;
 9c1:	b8 00 00 00 00       	mov    $0x0,%eax
 9c6:	eb 13                	jmp    9db <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d1:	8b 00                	mov    (%eax),%eax
 9d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9d6:	e9 70 ff ff ff       	jmp    94b <malloc+0x4e>
}
 9db:	c9                   	leave  
 9dc:	c3                   	ret    
