
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 a0 0d 00 	movl   $0xda0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 04 05 00 00       	call   527 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 a0 0d 00 	movl   $0xda0,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 e1 04 00 00       	call   51f <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 6b 0a 00 	movl   $0xa6b,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 3e 06 00 00       	call   69f <printf>
    exit();
  61:	e8 a1 04 00 00       	call   507 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 7f 04 00 00       	call   507 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 79                	jmp    10b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 93 04 00 00       	call   547 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 7c 0a 00 	movl   $0xa7c,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 b6 05 00 00       	call   69f <printf>
      exit();
  e9:	e8 19 04 00 00       	call   507 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 29 04 00 00       	call   52f <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 10b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10f:	3b 45 08             	cmp    0x8(%ebp),%eax
 112:	0f 8c 7a ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 118:	e8 ea 03 00 00       	call   507 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	5b                   	pop    %ebx
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 148:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 ba 00 00 00       	call   214 <strlen>
 15a:	83 e8 01             	sub    $0x1,%eax
 15d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 160:	eb 39                	jmp    19b <reverse+0x59>
         c = s[i];
 162:	8b 55 f4             	mov    -0xc(%ebp),%edx
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	01 d0                	add    %edx,%eax
 16a:	0f b6 00             	movzbl (%eax),%eax
 16d:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
 170:	8b 55 f4             	mov    -0xc(%ebp),%edx
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	01 c2                	add    %eax,%edx
 178:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	01 c8                	add    %ecx,%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	88 02                	mov    %al,(%edx)
         s[j] = c;
 185:	8b 55 f0             	mov    -0x10(%ebp),%edx
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	01 c2                	add    %eax,%edx
 18d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 191:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 193:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 197:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 19b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 1a1:	7c bf                	jl     162 <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 1a3:	c9                   	leave  
 1a4:	c3                   	ret    

000001a5 <strcpy>:

char*
strcpy(char *s, char *t)
{
 1a5:	55                   	push   %ebp
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1b1:	90                   	nop
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	8d 50 01             	lea    0x1(%eax),%edx
 1b8:	89 55 08             	mov    %edx,0x8(%ebp)
 1bb:	8b 55 0c             	mov    0xc(%ebp),%edx
 1be:	8d 4a 01             	lea    0x1(%edx),%ecx
 1c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1c4:	0f b6 12             	movzbl (%edx),%edx
 1c7:	88 10                	mov    %dl,(%eax)
 1c9:	0f b6 00             	movzbl (%eax),%eax
 1cc:	84 c0                	test   %al,%al
 1ce:	75 e2                	jne    1b2 <strcpy+0xd>
    ;
  return os;
 1d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d3:	c9                   	leave  
 1d4:	c3                   	ret    

000001d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1d8:	eb 08                	jmp    1e2 <strcmp+0xd>
    p++, q++;
 1da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1de:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	84 c0                	test   %al,%al
 1ea:	74 10                	je     1fc <strcmp+0x27>
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	0f b6 10             	movzbl (%eax),%edx
 1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f5:	0f b6 00             	movzbl (%eax),%eax
 1f8:	38 c2                	cmp    %al,%dl
 1fa:	74 de                	je     1da <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 00             	movzbl (%eax),%eax
 202:	0f b6 d0             	movzbl %al,%edx
 205:	8b 45 0c             	mov    0xc(%ebp),%eax
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	0f b6 c0             	movzbl %al,%eax
 20e:	29 c2                	sub    %eax,%edx
 210:	89 d0                	mov    %edx,%eax
}
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    

00000214 <strlen>:

uint
strlen(char *s)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 21a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 221:	eb 04                	jmp    227 <strlen+0x13>
 223:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 227:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	01 d0                	add    %edx,%eax
 22f:	0f b6 00             	movzbl (%eax),%eax
 232:	84 c0                	test   %al,%al
 234:	75 ed                	jne    223 <strlen+0xf>
    ;
  return n;
 236:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 239:	c9                   	leave  
 23a:	c3                   	ret    

0000023b <memset>:

void*
memset(void *dst, int c, uint n)
{
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
 23e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 241:	8b 45 10             	mov    0x10(%ebp),%eax
 244:	89 44 24 08          	mov    %eax,0x8(%esp)
 248:	8b 45 0c             	mov    0xc(%ebp),%eax
 24b:	89 44 24 04          	mov    %eax,0x4(%esp)
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	89 04 24             	mov    %eax,(%esp)
 255:	e8 c3 fe ff ff       	call   11d <stosb>
  return dst;
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 25d:	c9                   	leave  
 25e:	c3                   	ret    

0000025f <strchr>:

char*
strchr(const char *s, char c)
{
 25f:	55                   	push   %ebp
 260:	89 e5                	mov    %esp,%ebp
 262:	83 ec 04             	sub    $0x4,%esp
 265:	8b 45 0c             	mov    0xc(%ebp),%eax
 268:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 26b:	eb 14                	jmp    281 <strchr+0x22>
    if(*s == c)
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3a 45 fc             	cmp    -0x4(%ebp),%al
 276:	75 05                	jne    27d <strchr+0x1e>
      return (char*)s;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	eb 13                	jmp    290 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 27d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	84 c0                	test   %al,%al
 289:	75 e2                	jne    26d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 28b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <gets>:

char*
gets(char *buf, int max)
{
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 29f:	eb 4c                	jmp    2ed <gets+0x5b>
    cc = read(0, &c, 1);
 2a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2a8:	00 
 2a9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2b7:	e8 63 02 00 00       	call   51f <read>
 2bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2c3:	7f 02                	jg     2c7 <gets+0x35>
      break;
 2c5:	eb 31                	jmp    2f8 <gets+0x66>
    buf[i++] = c;
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2d0:	89 c2                	mov    %eax,%edx
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	01 c2                	add    %eax,%edx
 2d7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2db:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2dd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e1:	3c 0a                	cmp    $0xa,%al
 2e3:	74 13                	je     2f8 <gets+0x66>
 2e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e9:	3c 0d                	cmp    $0xd,%al
 2eb:	74 0b                	je     2f8 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f0:	83 c0 01             	add    $0x1,%eax
 2f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2f6:	7c a9                	jl     2a1 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	01 d0                	add    %edx,%eax
 300:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 303:	8b 45 08             	mov    0x8(%ebp),%eax
}
 306:	c9                   	leave  
 307:	c3                   	ret    

00000308 <stat>:

int
stat(char *n, struct stat *st)
{
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp
 30b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 30e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 315:	00 
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	89 04 24             	mov    %eax,(%esp)
 31c:	e8 26 02 00 00       	call   547 <open>
 321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 328:	79 07                	jns    331 <stat+0x29>
    return -1;
 32a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 32f:	eb 23                	jmp    354 <stat+0x4c>
  r = fstat(fd, st);
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	89 44 24 04          	mov    %eax,0x4(%esp)
 338:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33b:	89 04 24             	mov    %eax,(%esp)
 33e:	e8 1c 02 00 00       	call   55f <fstat>
 343:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 346:	8b 45 f4             	mov    -0xc(%ebp),%eax
 349:	89 04 24             	mov    %eax,(%esp)
 34c:	e8 de 01 00 00       	call   52f <close>
  return r;
 351:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <atoi>:

int
atoi(const char *s)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 35c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 363:	eb 25                	jmp    38a <atoi+0x34>
    n = n*10 + *s++ - '0';
 365:	8b 55 fc             	mov    -0x4(%ebp),%edx
 368:	89 d0                	mov    %edx,%eax
 36a:	c1 e0 02             	shl    $0x2,%eax
 36d:	01 d0                	add    %edx,%eax
 36f:	01 c0                	add    %eax,%eax
 371:	89 c1                	mov    %eax,%ecx
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	8d 50 01             	lea    0x1(%eax),%edx
 379:	89 55 08             	mov    %edx,0x8(%ebp)
 37c:	0f b6 00             	movzbl (%eax),%eax
 37f:	0f be c0             	movsbl %al,%eax
 382:	01 c8                	add    %ecx,%eax
 384:	83 e8 30             	sub    $0x30,%eax
 387:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	0f b6 00             	movzbl (%eax),%eax
 390:	3c 2f                	cmp    $0x2f,%al
 392:	7e 0a                	jle    39e <atoi+0x48>
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	0f b6 00             	movzbl (%eax),%eax
 39a:	3c 39                	cmp    $0x39,%al
 39c:	7e c7                	jle    365 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 39e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a1:	c9                   	leave  
 3a2:	c3                   	ret    

000003a3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3a3:	55                   	push   %ebp
 3a4:	89 e5                	mov    %esp,%ebp
 3a6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3af:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3b5:	eb 17                	jmp    3ce <memmove+0x2b>
    *dst++ = *src++;
 3b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ba:	8d 50 01             	lea    0x1(%eax),%edx
 3bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3c3:	8d 4a 01             	lea    0x1(%edx),%ecx
 3c6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3c9:	0f b6 12             	movzbl (%edx),%edx
 3cc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ce:	8b 45 10             	mov    0x10(%ebp),%eax
 3d1:	8d 50 ff             	lea    -0x1(%eax),%edx
 3d4:	89 55 10             	mov    %edx,0x10(%ebp)
 3d7:	85 c0                	test   %eax,%eax
 3d9:	7f dc                	jg     3b7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3de:	c9                   	leave  
 3df:	c3                   	ret    

000003e0 <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 3ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f1:	79 03                	jns    3f6 <itoa+0x16>
         n = -n;          /* make n positive */
 3f3:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 3f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 3fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 400:	8d 50 01             	lea    0x1(%eax),%edx
 403:	89 55 f4             	mov    %edx,-0xc(%ebp)
 406:	89 c2                	mov    %eax,%edx
 408:	8b 45 0c             	mov    0xc(%ebp),%eax
 40b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 40e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 411:	ba 67 66 66 66       	mov    $0x66666667,%edx
 416:	89 c8                	mov    %ecx,%eax
 418:	f7 ea                	imul   %edx
 41a:	c1 fa 02             	sar    $0x2,%edx
 41d:	89 c8                	mov    %ecx,%eax
 41f:	c1 f8 1f             	sar    $0x1f,%eax
 422:	29 c2                	sub    %eax,%edx
 424:	89 d0                	mov    %edx,%eax
 426:	c1 e0 02             	shl    $0x2,%eax
 429:	01 d0                	add    %edx,%eax
 42b:	01 c0                	add    %eax,%eax
 42d:	29 c1                	sub    %eax,%ecx
 42f:	89 ca                	mov    %ecx,%edx
 431:	89 d0                	mov    %edx,%eax
 433:	83 c0 30             	add    $0x30,%eax
 436:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 438:	8b 4d 08             	mov    0x8(%ebp),%ecx
 43b:	ba 67 66 66 66       	mov    $0x66666667,%edx
 440:	89 c8                	mov    %ecx,%eax
 442:	f7 ea                	imul   %edx
 444:	c1 fa 02             	sar    $0x2,%edx
 447:	89 c8                	mov    %ecx,%eax
 449:	c1 f8 1f             	sar    $0x1f,%eax
 44c:	29 c2                	sub    %eax,%edx
 44e:	89 d0                	mov    %edx,%eax
 450:	89 45 08             	mov    %eax,0x8(%ebp)
 453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 457:	7f a4                	jg     3fd <itoa+0x1d>
     if (sign < 0)
 459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45d:	79 13                	jns    472 <itoa+0x92>
         s[i++] = '-';
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	8d 50 01             	lea    0x1(%eax),%edx
 465:	89 55 f4             	mov    %edx,-0xc(%ebp)
 468:	89 c2                	mov    %eax,%edx
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	01 d0                	add    %edx,%eax
 46f:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 472:	8b 55 f4             	mov    -0xc(%ebp),%edx
 475:	8b 45 0c             	mov    0xc(%ebp),%eax
 478:	01 d0                	add    %edx,%eax
 47a:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 47d:	8b 45 0c             	mov    0xc(%ebp),%eax
 480:	89 04 24             	mov    %eax,(%esp)
 483:	e8 ba fc ff ff       	call   142 <reverse>
 }
 488:	83 c4 24             	add    $0x24,%esp
 48b:	5b                   	pop    %ebx
 48c:	5d                   	pop    %ebp
 48d:	c3                   	ret    

0000048e <strcat>:

char *
strcat(char *dest, const char *src)
{
 48e:	55                   	push   %ebp
 48f:	89 e5                	mov    %esp,%ebp
 491:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 494:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 49b:	eb 04                	jmp    4a1 <strcat+0x13>
 49d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	01 d0                	add    %edx,%eax
 4a9:	0f b6 00             	movzbl (%eax),%eax
 4ac:	84 c0                	test   %al,%al
 4ae:	75 ed                	jne    49d <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 4b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 4b7:	eb 20                	jmp    4d9 <strcat+0x4b>
        dest[i+j] = src[j];
 4b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4bf:	01 d0                	add    %edx,%eax
 4c1:	89 c2                	mov    %eax,%edx
 4c3:	8b 45 08             	mov    0x8(%ebp),%eax
 4c6:	01 c2                	add    %eax,%edx
 4c8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 4cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ce:	01 c8                	add    %ecx,%eax
 4d0:	0f b6 00             	movzbl (%eax),%eax
 4d3:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 4d5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 4d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4df:	01 d0                	add    %edx,%eax
 4e1:	0f b6 00             	movzbl (%eax),%eax
 4e4:	84 c0                	test   %al,%al
 4e6:	75 d1                	jne    4b9 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 4e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4ee:	01 d0                	add    %edx,%eax
 4f0:	89 c2                	mov    %eax,%edx
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	01 d0                	add    %edx,%eax
 4f7:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4fd:	c9                   	leave  
 4fe:	c3                   	ret    

000004ff <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ff:	b8 01 00 00 00       	mov    $0x1,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <exit>:
SYSCALL(exit)
 507:	b8 02 00 00 00       	mov    $0x2,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <wait>:
SYSCALL(wait)
 50f:	b8 03 00 00 00       	mov    $0x3,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <pipe>:
SYSCALL(pipe)
 517:	b8 04 00 00 00       	mov    $0x4,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <read>:
SYSCALL(read)
 51f:	b8 05 00 00 00       	mov    $0x5,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <write>:
SYSCALL(write)
 527:	b8 10 00 00 00       	mov    $0x10,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <close>:
SYSCALL(close)
 52f:	b8 15 00 00 00       	mov    $0x15,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <kill>:
SYSCALL(kill)
 537:	b8 06 00 00 00       	mov    $0x6,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <exec>:
SYSCALL(exec)
 53f:	b8 07 00 00 00       	mov    $0x7,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <open>:
SYSCALL(open)
 547:	b8 0f 00 00 00       	mov    $0xf,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <mknod>:
SYSCALL(mknod)
 54f:	b8 11 00 00 00       	mov    $0x11,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <unlink>:
SYSCALL(unlink)
 557:	b8 12 00 00 00       	mov    $0x12,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <fstat>:
SYSCALL(fstat)
 55f:	b8 08 00 00 00       	mov    $0x8,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <link>:
SYSCALL(link)
 567:	b8 13 00 00 00       	mov    $0x13,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <mkdir>:
SYSCALL(mkdir)
 56f:	b8 14 00 00 00       	mov    $0x14,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <chdir>:
SYSCALL(chdir)
 577:	b8 09 00 00 00       	mov    $0x9,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <dup>:
SYSCALL(dup)
 57f:	b8 0a 00 00 00       	mov    $0xa,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <getpid>:
SYSCALL(getpid)
 587:	b8 0b 00 00 00       	mov    $0xb,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <sbrk>:
SYSCALL(sbrk)
 58f:	b8 0c 00 00 00       	mov    $0xc,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <sleep>:
SYSCALL(sleep)
 597:	b8 0d 00 00 00       	mov    $0xd,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <uptime>:
SYSCALL(uptime)
 59f:	b8 0e 00 00 00       	mov    $0xe,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <wait2>:
SYSCALL(wait2)
 5a7:	b8 16 00 00 00       	mov    $0x16,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <set_priority>:
SYSCALL(set_priority)
 5af:	b8 17 00 00 00       	mov    $0x17,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <get_sched_record>:
SYSCALL(get_sched_record)
 5b7:	b8 18 00 00 00       	mov    $0x18,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5bf:	55                   	push   %ebp
 5c0:	89 e5                	mov    %esp,%ebp
 5c2:	83 ec 18             	sub    $0x18,%esp
 5c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d2:	00 
 5d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 42 ff ff ff       	call   527 <write>
}
 5e5:	c9                   	leave  
 5e6:	c3                   	ret    

000005e7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e7:	55                   	push   %ebp
 5e8:	89 e5                	mov    %esp,%ebp
 5ea:	56                   	push   %esi
 5eb:	53                   	push   %ebx
 5ec:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5f6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5fa:	74 17                	je     613 <printint+0x2c>
 5fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 600:	79 11                	jns    613 <printint+0x2c>
    neg = 1;
 602:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 609:	8b 45 0c             	mov    0xc(%ebp),%eax
 60c:	f7 d8                	neg    %eax
 60e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 611:	eb 06                	jmp    619 <printint+0x32>
  } else {
    x = xx;
 613:	8b 45 0c             	mov    0xc(%ebp),%eax
 616:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 620:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 623:	8d 41 01             	lea    0x1(%ecx),%eax
 626:	89 45 f4             	mov    %eax,-0xc(%ebp)
 629:	8b 5d 10             	mov    0x10(%ebp),%ebx
 62c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 62f:	ba 00 00 00 00       	mov    $0x0,%edx
 634:	f7 f3                	div    %ebx
 636:	89 d0                	mov    %edx,%eax
 638:	0f b6 80 60 0d 00 00 	movzbl 0xd60(%eax),%eax
 63f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 643:	8b 75 10             	mov    0x10(%ebp),%esi
 646:	8b 45 ec             	mov    -0x14(%ebp),%eax
 649:	ba 00 00 00 00       	mov    $0x0,%edx
 64e:	f7 f6                	div    %esi
 650:	89 45 ec             	mov    %eax,-0x14(%ebp)
 653:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 657:	75 c7                	jne    620 <printint+0x39>
  if(neg)
 659:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 65d:	74 10                	je     66f <printint+0x88>
    buf[i++] = '-';
 65f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 662:	8d 50 01             	lea    0x1(%eax),%edx
 665:	89 55 f4             	mov    %edx,-0xc(%ebp)
 668:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 66d:	eb 1f                	jmp    68e <printint+0xa7>
 66f:	eb 1d                	jmp    68e <printint+0xa7>
    putc(fd, buf[i]);
 671:	8d 55 dc             	lea    -0x24(%ebp),%edx
 674:	8b 45 f4             	mov    -0xc(%ebp),%eax
 677:	01 d0                	add    %edx,%eax
 679:	0f b6 00             	movzbl (%eax),%eax
 67c:	0f be c0             	movsbl %al,%eax
 67f:	89 44 24 04          	mov    %eax,0x4(%esp)
 683:	8b 45 08             	mov    0x8(%ebp),%eax
 686:	89 04 24             	mov    %eax,(%esp)
 689:	e8 31 ff ff ff       	call   5bf <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 68e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 696:	79 d9                	jns    671 <printint+0x8a>
    putc(fd, buf[i]);
}
 698:	83 c4 30             	add    $0x30,%esp
 69b:	5b                   	pop    %ebx
 69c:	5e                   	pop    %esi
 69d:	5d                   	pop    %ebp
 69e:	c3                   	ret    

0000069f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 69f:	55                   	push   %ebp
 6a0:	89 e5                	mov    %esp,%ebp
 6a2:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6ac:	8d 45 0c             	lea    0xc(%ebp),%eax
 6af:	83 c0 04             	add    $0x4,%eax
 6b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6bc:	e9 7c 01 00 00       	jmp    83d <printf+0x19e>
    c = fmt[i] & 0xff;
 6c1:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c7:	01 d0                	add    %edx,%eax
 6c9:	0f b6 00             	movzbl (%eax),%eax
 6cc:	0f be c0             	movsbl %al,%eax
 6cf:	25 ff 00 00 00       	and    $0xff,%eax
 6d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6db:	75 2c                	jne    709 <printf+0x6a>
      if(c == '%'){
 6dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e1:	75 0c                	jne    6ef <printf+0x50>
        state = '%';
 6e3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ea:	e9 4a 01 00 00       	jmp    839 <printf+0x19a>
      } else {
        putc(fd, c);
 6ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f2:	0f be c0             	movsbl %al,%eax
 6f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
 6fc:	89 04 24             	mov    %eax,(%esp)
 6ff:	e8 bb fe ff ff       	call   5bf <putc>
 704:	e9 30 01 00 00       	jmp    839 <printf+0x19a>
      }
    } else if(state == '%'){
 709:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 70d:	0f 85 26 01 00 00    	jne    839 <printf+0x19a>
      if(c == 'd'){
 713:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 717:	75 2d                	jne    746 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 719:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 725:	00 
 726:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 72d:	00 
 72e:	89 44 24 04          	mov    %eax,0x4(%esp)
 732:	8b 45 08             	mov    0x8(%ebp),%eax
 735:	89 04 24             	mov    %eax,(%esp)
 738:	e8 aa fe ff ff       	call   5e7 <printint>
        ap++;
 73d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 741:	e9 ec 00 00 00       	jmp    832 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 746:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 74a:	74 06                	je     752 <printf+0xb3>
 74c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 750:	75 2d                	jne    77f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 752:	8b 45 e8             	mov    -0x18(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 75e:	00 
 75f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 766:	00 
 767:	89 44 24 04          	mov    %eax,0x4(%esp)
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	89 04 24             	mov    %eax,(%esp)
 771:	e8 71 fe ff ff       	call   5e7 <printint>
        ap++;
 776:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77a:	e9 b3 00 00 00       	jmp    832 <printf+0x193>
      } else if(c == 's'){
 77f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 783:	75 45                	jne    7ca <printf+0x12b>
        s = (char*)*ap;
 785:	8b 45 e8             	mov    -0x18(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 78d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 795:	75 09                	jne    7a0 <printf+0x101>
          s = "(null)";
 797:	c7 45 f4 91 0a 00 00 	movl   $0xa91,-0xc(%ebp)
        while(*s != 0){
 79e:	eb 1e                	jmp    7be <printf+0x11f>
 7a0:	eb 1c                	jmp    7be <printf+0x11f>
          putc(fd, *s);
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	0f b6 00             	movzbl (%eax),%eax
 7a8:	0f be c0             	movsbl %al,%eax
 7ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	89 04 24             	mov    %eax,(%esp)
 7b5:	e8 05 fe ff ff       	call   5bf <putc>
          s++;
 7ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	0f b6 00             	movzbl (%eax),%eax
 7c4:	84 c0                	test   %al,%al
 7c6:	75 da                	jne    7a2 <printf+0x103>
 7c8:	eb 68                	jmp    832 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ca:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ce:	75 1d                	jne    7ed <printf+0x14e>
        putc(fd, *ap);
 7d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	0f be c0             	movsbl %al,%eax
 7d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 d8 fd ff ff       	call   5bf <putc>
        ap++;
 7e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7eb:	eb 45                	jmp    832 <printf+0x193>
      } else if(c == '%'){
 7ed:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7f1:	75 17                	jne    80a <printf+0x16b>
        putc(fd, c);
 7f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f6:	0f be c0             	movsbl %al,%eax
 7f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
 800:	89 04 24             	mov    %eax,(%esp)
 803:	e8 b7 fd ff ff       	call   5bf <putc>
 808:	eb 28                	jmp    832 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 80a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 811:	00 
 812:	8b 45 08             	mov    0x8(%ebp),%eax
 815:	89 04 24             	mov    %eax,(%esp)
 818:	e8 a2 fd ff ff       	call   5bf <putc>
        putc(fd, c);
 81d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 820:	0f be c0             	movsbl %al,%eax
 823:	89 44 24 04          	mov    %eax,0x4(%esp)
 827:	8b 45 08             	mov    0x8(%ebp),%eax
 82a:	89 04 24             	mov    %eax,(%esp)
 82d:	e8 8d fd ff ff       	call   5bf <putc>
      }
      state = 0;
 832:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 839:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 83d:	8b 55 0c             	mov    0xc(%ebp),%edx
 840:	8b 45 f0             	mov    -0x10(%ebp),%eax
 843:	01 d0                	add    %edx,%eax
 845:	0f b6 00             	movzbl (%eax),%eax
 848:	84 c0                	test   %al,%al
 84a:	0f 85 71 fe ff ff    	jne    6c1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 850:	c9                   	leave  
 851:	c3                   	ret    

00000852 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 852:	55                   	push   %ebp
 853:	89 e5                	mov    %esp,%ebp
 855:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 858:	8b 45 08             	mov    0x8(%ebp),%eax
 85b:	83 e8 08             	sub    $0x8,%eax
 85e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 861:	a1 88 0d 00 00       	mov    0xd88,%eax
 866:	89 45 fc             	mov    %eax,-0x4(%ebp)
 869:	eb 24                	jmp    88f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	8b 00                	mov    (%eax),%eax
 870:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 873:	77 12                	ja     887 <free+0x35>
 875:	8b 45 f8             	mov    -0x8(%ebp),%eax
 878:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 87b:	77 24                	ja     8a1 <free+0x4f>
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8b 00                	mov    (%eax),%eax
 882:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 885:	77 1a                	ja     8a1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 887:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88a:	8b 00                	mov    (%eax),%eax
 88c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 88f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 892:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 895:	76 d4                	jbe    86b <free+0x19>
 897:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89f:	76 ca                	jbe    86b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a4:	8b 40 04             	mov    0x4(%eax),%eax
 8a7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b1:	01 c2                	add    %eax,%edx
 8b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b6:	8b 00                	mov    (%eax),%eax
 8b8:	39 c2                	cmp    %eax,%edx
 8ba:	75 24                	jne    8e0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bf:	8b 50 04             	mov    0x4(%eax),%edx
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	01 c2                	add    %eax,%edx
 8cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	8b 00                	mov    (%eax),%eax
 8d7:	8b 10                	mov    (%eax),%edx
 8d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dc:	89 10                	mov    %edx,(%eax)
 8de:	eb 0a                	jmp    8ea <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e3:	8b 10                	mov    (%eax),%edx
 8e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ed:	8b 40 04             	mov    0x4(%eax),%eax
 8f0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fa:	01 d0                	add    %edx,%eax
 8fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ff:	75 20                	jne    921 <free+0xcf>
    p->s.size += bp->s.size;
 901:	8b 45 fc             	mov    -0x4(%ebp),%eax
 904:	8b 50 04             	mov    0x4(%eax),%edx
 907:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90a:	8b 40 04             	mov    0x4(%eax),%eax
 90d:	01 c2                	add    %eax,%edx
 90f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 912:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 915:	8b 45 f8             	mov    -0x8(%ebp),%eax
 918:	8b 10                	mov    (%eax),%edx
 91a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91d:	89 10                	mov    %edx,(%eax)
 91f:	eb 08                	jmp    929 <free+0xd7>
  } else
    p->s.ptr = bp;
 921:	8b 45 fc             	mov    -0x4(%ebp),%eax
 924:	8b 55 f8             	mov    -0x8(%ebp),%edx
 927:	89 10                	mov    %edx,(%eax)
  freep = p;
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	a3 88 0d 00 00       	mov    %eax,0xd88
}
 931:	c9                   	leave  
 932:	c3                   	ret    

00000933 <morecore>:

static Header*
morecore(uint nu)
{
 933:	55                   	push   %ebp
 934:	89 e5                	mov    %esp,%ebp
 936:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 939:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 940:	77 07                	ja     949 <morecore+0x16>
    nu = 4096;
 942:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 949:	8b 45 08             	mov    0x8(%ebp),%eax
 94c:	c1 e0 03             	shl    $0x3,%eax
 94f:	89 04 24             	mov    %eax,(%esp)
 952:	e8 38 fc ff ff       	call   58f <sbrk>
 957:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 95a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 95e:	75 07                	jne    967 <morecore+0x34>
    return 0;
 960:	b8 00 00 00 00       	mov    $0x0,%eax
 965:	eb 22                	jmp    989 <morecore+0x56>
  hp = (Header*)p;
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 96d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 970:	8b 55 08             	mov    0x8(%ebp),%edx
 973:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 976:	8b 45 f0             	mov    -0x10(%ebp),%eax
 979:	83 c0 08             	add    $0x8,%eax
 97c:	89 04 24             	mov    %eax,(%esp)
 97f:	e8 ce fe ff ff       	call   852 <free>
  return freep;
 984:	a1 88 0d 00 00       	mov    0xd88,%eax
}
 989:	c9                   	leave  
 98a:	c3                   	ret    

0000098b <malloc>:

void*
malloc(uint nbytes)
{
 98b:	55                   	push   %ebp
 98c:	89 e5                	mov    %esp,%ebp
 98e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 991:	8b 45 08             	mov    0x8(%ebp),%eax
 994:	83 c0 07             	add    $0x7,%eax
 997:	c1 e8 03             	shr    $0x3,%eax
 99a:	83 c0 01             	add    $0x1,%eax
 99d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9a0:	a1 88 0d 00 00       	mov    0xd88,%eax
 9a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ac:	75 23                	jne    9d1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9ae:	c7 45 f0 80 0d 00 00 	movl   $0xd80,-0x10(%ebp)
 9b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b8:	a3 88 0d 00 00       	mov    %eax,0xd88
 9bd:	a1 88 0d 00 00       	mov    0xd88,%eax
 9c2:	a3 80 0d 00 00       	mov    %eax,0xd80
    base.s.size = 0;
 9c7:	c7 05 84 0d 00 00 00 	movl   $0x0,0xd84
 9ce:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d4:	8b 00                	mov    (%eax),%eax
 9d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	8b 40 04             	mov    0x4(%eax),%eax
 9df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e2:	72 4d                	jb     a31 <malloc+0xa6>
      if(p->s.size == nunits)
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	8b 40 04             	mov    0x4(%eax),%eax
 9ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ed:	75 0c                	jne    9fb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	8b 10                	mov    (%eax),%edx
 9f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f7:	89 10                	mov    %edx,(%eax)
 9f9:	eb 26                	jmp    a21 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fe:	8b 40 04             	mov    0x4(%eax),%eax
 a01:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a04:	89 c2                	mov    %eax,%edx
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	8b 40 04             	mov    0x4(%eax),%eax
 a12:	c1 e0 03             	shl    $0x3,%eax
 a15:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a1e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a24:	a3 88 0d 00 00       	mov    %eax,0xd88
      return (void*)(p + 1);
 a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2c:	83 c0 08             	add    $0x8,%eax
 a2f:	eb 38                	jmp    a69 <malloc+0xde>
    }
    if(p == freep)
 a31:	a1 88 0d 00 00       	mov    0xd88,%eax
 a36:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a39:	75 1b                	jne    a56 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a3e:	89 04 24             	mov    %eax,(%esp)
 a41:	e8 ed fe ff ff       	call   933 <morecore>
 a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a4d:	75 07                	jne    a56 <malloc+0xcb>
        return 0;
 a4f:	b8 00 00 00 00       	mov    $0x0,%eax
 a54:	eb 13                	jmp    a69 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5f:	8b 00                	mov    (%eax),%eax
 a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a64:	e9 70 ff ff ff       	jmp    9d9 <malloc+0x4e>
}
 a69:	c9                   	leave  
 a6a:	c3                   	ret    
