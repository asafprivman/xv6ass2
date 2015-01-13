
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 80 0e 00 00       	add    $0xe80,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 80 0e 00 00       	add    $0xe80,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 27 0b 00 00 	movl   $0xb27,(%esp)
  5b:	e8 bb 02 00 00       	call   31b <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 80 0e 00 	movl   $0xe80,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 36 05 00 00       	call   5db <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 2d 0b 00 	movl   $0xb2d,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 8f 06 00 00       	call   75b <printf>
    exit();
  cc:	e8 f2 04 00 00       	call   5c3 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 14          	mov    %eax,0x14(%esp)
  d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  db:	89 44 24 10          	mov    %eax,0x10(%esp)
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	c7 44 24 04 3d 0b 00 	movl   $0xb3d,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 5a 06 00 00       	call   75b <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
 112:	c7 44 24 04 4a 0b 00 	movl   $0xb4a,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 98 04 00 00       	call   5c3 <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
 138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	8b 00                	mov    (%eax),%eax
 14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 151:	00 
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 a9 04 00 00       	call   603 <open>
 15a:	89 44 24 18          	mov    %eax,0x18(%esp)
 15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 163:	79 2f                	jns    194 <main+0x91>
      printf(1, "cat: cannot open %s\n", argv[i]);
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	8b 00                	mov    (%eax),%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	c7 44 24 04 4b 0b 00 	movl   $0xb4b,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 cc 05 00 00       	call   75b <printf>
      exit();
 18f:	e8 2f 04 00 00       	call   5c3 <exit>
    }
    wc(fd, argv[i]);
 194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8b 00                	mov    (%eax),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
 1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 29 04 00 00       	call   5eb <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1d4:	e8 ea 03 00 00       	call   5c3 <exit>

000001d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	57                   	push   %edi
 1dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1de:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e1:	8b 55 10             	mov    0x10(%ebp),%edx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	89 cb                	mov    %ecx,%ebx
 1e9:	89 df                	mov    %ebx,%edi
 1eb:	89 d1                	mov    %edx,%ecx
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
 1f0:	89 ca                	mov    %ecx,%edx
 1f2:	89 fb                	mov    %edi,%ebx
 1f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fa:	5b                   	pop    %ebx
 1fb:	5f                   	pop    %edi
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret    

000001fe <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 204:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	89 04 24             	mov    %eax,(%esp)
 211:	e8 ba 00 00 00       	call   2d0 <strlen>
 216:	83 e8 01             	sub    $0x1,%eax
 219:	89 45 f0             	mov    %eax,-0x10(%ebp)
 21c:	eb 39                	jmp    257 <reverse+0x59>
         c = s[i];
 21e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	01 d0                	add    %edx,%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
 22c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	01 c2                	add    %eax,%edx
 234:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	01 c8                	add    %ecx,%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	88 02                	mov    %al,(%edx)
         s[j] = c;
 241:	8b 55 f0             	mov    -0x10(%ebp),%edx
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	01 c2                	add    %eax,%edx
 249:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24d:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 24f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 253:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 257:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 25d:	7c bf                	jl     21e <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 25f:	c9                   	leave  
 260:	c3                   	ret    

00000261 <strcpy>:

char*
strcpy(char *s, char *t)
{
 261:	55                   	push   %ebp
 262:	89 e5                	mov    %esp,%ebp
 264:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 26d:	90                   	nop
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	8d 50 01             	lea    0x1(%eax),%edx
 274:	89 55 08             	mov    %edx,0x8(%ebp)
 277:	8b 55 0c             	mov    0xc(%ebp),%edx
 27a:	8d 4a 01             	lea    0x1(%edx),%ecx
 27d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 280:	0f b6 12             	movzbl (%edx),%edx
 283:	88 10                	mov    %dl,(%eax)
 285:	0f b6 00             	movzbl (%eax),%eax
 288:	84 c0                	test   %al,%al
 28a:	75 e2                	jne    26e <strcpy+0xd>
    ;
  return os;
 28c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 294:	eb 08                	jmp    29e <strcmp+0xd>
    p++, q++;
 296:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 29a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	84 c0                	test   %al,%al
 2a6:	74 10                	je     2b8 <strcmp+0x27>
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 10             	movzbl (%eax),%edx
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	38 c2                	cmp    %al,%dl
 2b6:	74 de                	je     296 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	0f b6 d0             	movzbl %al,%edx
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	0f b6 c0             	movzbl %al,%eax
 2ca:	29 c2                	sub    %eax,%edx
 2cc:	89 d0                	mov    %edx,%eax
}
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    

000002d0 <strlen>:

uint
strlen(char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2dd:	eb 04                	jmp    2e3 <strlen+0x13>
 2df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	01 d0                	add    %edx,%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	84 c0                	test   %al,%al
 2f0:	75 ed                	jne    2df <strlen+0xf>
    ;
  return n;
 2f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f5:	c9                   	leave  
 2f6:	c3                   	ret    

000002f7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f7:	55                   	push   %ebp
 2f8:	89 e5                	mov    %esp,%ebp
 2fa:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2fd:	8b 45 10             	mov    0x10(%ebp),%eax
 300:	89 44 24 08          	mov    %eax,0x8(%esp)
 304:	8b 45 0c             	mov    0xc(%ebp),%eax
 307:	89 44 24 04          	mov    %eax,0x4(%esp)
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	89 04 24             	mov    %eax,(%esp)
 311:	e8 c3 fe ff ff       	call   1d9 <stosb>
  return dst;
 316:	8b 45 08             	mov    0x8(%ebp),%eax
}
 319:	c9                   	leave  
 31a:	c3                   	ret    

0000031b <strchr>:

char*
strchr(const char *s, char c)
{
 31b:	55                   	push   %ebp
 31c:	89 e5                	mov    %esp,%ebp
 31e:	83 ec 04             	sub    $0x4,%esp
 321:	8b 45 0c             	mov    0xc(%ebp),%eax
 324:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 327:	eb 14                	jmp    33d <strchr+0x22>
    if(*s == c)
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	0f b6 00             	movzbl (%eax),%eax
 32f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 332:	75 05                	jne    339 <strchr+0x1e>
      return (char*)s;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	eb 13                	jmp    34c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 339:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	0f b6 00             	movzbl (%eax),%eax
 343:	84 c0                	test   %al,%al
 345:	75 e2                	jne    329 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 347:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    

0000034e <gets>:

char*
gets(char *buf, int max)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 354:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 35b:	eb 4c                	jmp    3a9 <gets+0x5b>
    cc = read(0, &c, 1);
 35d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 364:	00 
 365:	8d 45 ef             	lea    -0x11(%ebp),%eax
 368:	89 44 24 04          	mov    %eax,0x4(%esp)
 36c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 373:	e8 63 02 00 00       	call   5db <read>
 378:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 37b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 37f:	7f 02                	jg     383 <gets+0x35>
      break;
 381:	eb 31                	jmp    3b4 <gets+0x66>
    buf[i++] = c;
 383:	8b 45 f4             	mov    -0xc(%ebp),%eax
 386:	8d 50 01             	lea    0x1(%eax),%edx
 389:	89 55 f4             	mov    %edx,-0xc(%ebp)
 38c:	89 c2                	mov    %eax,%edx
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	01 c2                	add    %eax,%edx
 393:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 397:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 399:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 39d:	3c 0a                	cmp    $0xa,%al
 39f:	74 13                	je     3b4 <gets+0x66>
 3a1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a5:	3c 0d                	cmp    $0xd,%al
 3a7:	74 0b                	je     3b4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ac:	83 c0 01             	add    $0x1,%eax
 3af:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3b2:	7c a9                	jl     35d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	01 d0                	add    %edx,%eax
 3bc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c2:	c9                   	leave  
 3c3:	c3                   	ret    

000003c4 <stat>:

int
stat(char *n, struct stat *st)
{
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3d1:	00 
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	89 04 24             	mov    %eax,(%esp)
 3d8:	e8 26 02 00 00       	call   603 <open>
 3dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e4:	79 07                	jns    3ed <stat+0x29>
    return -1;
 3e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3eb:	eb 23                	jmp    410 <stat+0x4c>
  r = fstat(fd, st);
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f7:	89 04 24             	mov    %eax,(%esp)
 3fa:	e8 1c 02 00 00       	call   61b <fstat>
 3ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 402:	8b 45 f4             	mov    -0xc(%ebp),%eax
 405:	89 04 24             	mov    %eax,(%esp)
 408:	e8 de 01 00 00       	call   5eb <close>
  return r;
 40d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 410:	c9                   	leave  
 411:	c3                   	ret    

00000412 <atoi>:

int
atoi(const char *s)
{
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 41f:	eb 25                	jmp    446 <atoi+0x34>
    n = n*10 + *s++ - '0';
 421:	8b 55 fc             	mov    -0x4(%ebp),%edx
 424:	89 d0                	mov    %edx,%eax
 426:	c1 e0 02             	shl    $0x2,%eax
 429:	01 d0                	add    %edx,%eax
 42b:	01 c0                	add    %eax,%eax
 42d:	89 c1                	mov    %eax,%ecx
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	8d 50 01             	lea    0x1(%eax),%edx
 435:	89 55 08             	mov    %edx,0x8(%ebp)
 438:	0f b6 00             	movzbl (%eax),%eax
 43b:	0f be c0             	movsbl %al,%eax
 43e:	01 c8                	add    %ecx,%eax
 440:	83 e8 30             	sub    $0x30,%eax
 443:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	0f b6 00             	movzbl (%eax),%eax
 44c:	3c 2f                	cmp    $0x2f,%al
 44e:	7e 0a                	jle    45a <atoi+0x48>
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	0f b6 00             	movzbl (%eax),%eax
 456:	3c 39                	cmp    $0x39,%al
 458:	7e c7                	jle    421 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 45a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 45d:	c9                   	leave  
 45e:	c3                   	ret    

0000045f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 45f:	55                   	push   %ebp
 460:	89 e5                	mov    %esp,%ebp
 462:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 465:	8b 45 08             	mov    0x8(%ebp),%eax
 468:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 46b:	8b 45 0c             	mov    0xc(%ebp),%eax
 46e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 471:	eb 17                	jmp    48a <memmove+0x2b>
    *dst++ = *src++;
 473:	8b 45 fc             	mov    -0x4(%ebp),%eax
 476:	8d 50 01             	lea    0x1(%eax),%edx
 479:	89 55 fc             	mov    %edx,-0x4(%ebp)
 47c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 47f:	8d 4a 01             	lea    0x1(%edx),%ecx
 482:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 485:	0f b6 12             	movzbl (%edx),%edx
 488:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48a:	8b 45 10             	mov    0x10(%ebp),%eax
 48d:	8d 50 ff             	lea    -0x1(%eax),%edx
 490:	89 55 10             	mov    %edx,0x10(%ebp)
 493:	85 c0                	test   %eax,%eax
 495:	7f dc                	jg     473 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 497:	8b 45 08             	mov    0x8(%ebp),%eax
}
 49a:	c9                   	leave  
 49b:	c3                   	ret    

0000049c <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 49c:	55                   	push   %ebp
 49d:	89 e5                	mov    %esp,%ebp
 49f:	53                   	push   %ebx
 4a0:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 4a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ad:	79 03                	jns    4b2 <itoa+0x16>
         n = -n;          /* make n positive */
 4af:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 4b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bc:	8d 50 01             	lea    0x1(%eax),%edx
 4bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c2:	89 c2                	mov    %eax,%edx
 4c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 4ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4cd:	ba 67 66 66 66       	mov    $0x66666667,%edx
 4d2:	89 c8                	mov    %ecx,%eax
 4d4:	f7 ea                	imul   %edx
 4d6:	c1 fa 02             	sar    $0x2,%edx
 4d9:	89 c8                	mov    %ecx,%eax
 4db:	c1 f8 1f             	sar    $0x1f,%eax
 4de:	29 c2                	sub    %eax,%edx
 4e0:	89 d0                	mov    %edx,%eax
 4e2:	c1 e0 02             	shl    $0x2,%eax
 4e5:	01 d0                	add    %edx,%eax
 4e7:	01 c0                	add    %eax,%eax
 4e9:	29 c1                	sub    %eax,%ecx
 4eb:	89 ca                	mov    %ecx,%edx
 4ed:	89 d0                	mov    %edx,%eax
 4ef:	83 c0 30             	add    $0x30,%eax
 4f2:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 4f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4f7:	ba 67 66 66 66       	mov    $0x66666667,%edx
 4fc:	89 c8                	mov    %ecx,%eax
 4fe:	f7 ea                	imul   %edx
 500:	c1 fa 02             	sar    $0x2,%edx
 503:	89 c8                	mov    %ecx,%eax
 505:	c1 f8 1f             	sar    $0x1f,%eax
 508:	29 c2                	sub    %eax,%edx
 50a:	89 d0                	mov    %edx,%eax
 50c:	89 45 08             	mov    %eax,0x8(%ebp)
 50f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 513:	7f a4                	jg     4b9 <itoa+0x1d>
     if (sign < 0)
 515:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 519:	79 13                	jns    52e <itoa+0x92>
         s[i++] = '-';
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	8d 50 01             	lea    0x1(%eax),%edx
 521:	89 55 f4             	mov    %edx,-0xc(%ebp)
 524:	89 c2                	mov    %eax,%edx
 526:	8b 45 0c             	mov    0xc(%ebp),%eax
 529:	01 d0                	add    %edx,%eax
 52b:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 52e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 531:	8b 45 0c             	mov    0xc(%ebp),%eax
 534:	01 d0                	add    %edx,%eax
 536:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 539:	8b 45 0c             	mov    0xc(%ebp),%eax
 53c:	89 04 24             	mov    %eax,(%esp)
 53f:	e8 ba fc ff ff       	call   1fe <reverse>
 }
 544:	83 c4 24             	add    $0x24,%esp
 547:	5b                   	pop    %ebx
 548:	5d                   	pop    %ebp
 549:	c3                   	ret    

0000054a <strcat>:

char *
strcat(char *dest, const char *src)
{
 54a:	55                   	push   %ebp
 54b:	89 e5                	mov    %esp,%ebp
 54d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 550:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 557:	eb 04                	jmp    55d <strcat+0x13>
 559:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 55d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	01 d0                	add    %edx,%eax
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	84 c0                	test   %al,%al
 56a:	75 ed                	jne    559 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 56c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 573:	eb 20                	jmp    595 <strcat+0x4b>
        dest[i+j] = src[j];
 575:	8b 45 f8             	mov    -0x8(%ebp),%eax
 578:	8b 55 fc             	mov    -0x4(%ebp),%edx
 57b:	01 d0                	add    %edx,%eax
 57d:	89 c2                	mov    %eax,%edx
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	01 c2                	add    %eax,%edx
 584:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 587:	8b 45 0c             	mov    0xc(%ebp),%eax
 58a:	01 c8                	add    %ecx,%eax
 58c:	0f b6 00             	movzbl (%eax),%eax
 58f:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 591:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 595:	8b 55 f8             	mov    -0x8(%ebp),%edx
 598:	8b 45 0c             	mov    0xc(%ebp),%eax
 59b:	01 d0                	add    %edx,%eax
 59d:	0f b6 00             	movzbl (%eax),%eax
 5a0:	84 c0                	test   %al,%al
 5a2:	75 d1                	jne    575 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 5a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5aa:	01 d0                	add    %edx,%eax
 5ac:	89 c2                	mov    %eax,%edx
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	01 d0                	add    %edx,%eax
 5b3:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b9:	c9                   	leave  
 5ba:	c3                   	ret    

000005bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5bb:	b8 01 00 00 00       	mov    $0x1,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <exit>:
SYSCALL(exit)
 5c3:	b8 02 00 00 00       	mov    $0x2,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <wait>:
SYSCALL(wait)
 5cb:	b8 03 00 00 00       	mov    $0x3,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <pipe>:
SYSCALL(pipe)
 5d3:	b8 04 00 00 00       	mov    $0x4,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <read>:
SYSCALL(read)
 5db:	b8 05 00 00 00       	mov    $0x5,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <write>:
SYSCALL(write)
 5e3:	b8 10 00 00 00       	mov    $0x10,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <close>:
SYSCALL(close)
 5eb:	b8 15 00 00 00       	mov    $0x15,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <kill>:
SYSCALL(kill)
 5f3:	b8 06 00 00 00       	mov    $0x6,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <exec>:
SYSCALL(exec)
 5fb:	b8 07 00 00 00       	mov    $0x7,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <open>:
SYSCALL(open)
 603:	b8 0f 00 00 00       	mov    $0xf,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <mknod>:
SYSCALL(mknod)
 60b:	b8 11 00 00 00       	mov    $0x11,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <unlink>:
SYSCALL(unlink)
 613:	b8 12 00 00 00       	mov    $0x12,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <fstat>:
SYSCALL(fstat)
 61b:	b8 08 00 00 00       	mov    $0x8,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <link>:
SYSCALL(link)
 623:	b8 13 00 00 00       	mov    $0x13,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <mkdir>:
SYSCALL(mkdir)
 62b:	b8 14 00 00 00       	mov    $0x14,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <chdir>:
SYSCALL(chdir)
 633:	b8 09 00 00 00       	mov    $0x9,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <dup>:
SYSCALL(dup)
 63b:	b8 0a 00 00 00       	mov    $0xa,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <getpid>:
SYSCALL(getpid)
 643:	b8 0b 00 00 00       	mov    $0xb,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <sbrk>:
SYSCALL(sbrk)
 64b:	b8 0c 00 00 00       	mov    $0xc,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <sleep>:
SYSCALL(sleep)
 653:	b8 0d 00 00 00       	mov    $0xd,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <uptime>:
SYSCALL(uptime)
 65b:	b8 0e 00 00 00       	mov    $0xe,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <wait2>:
SYSCALL(wait2)
 663:	b8 16 00 00 00       	mov    $0x16,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <set_priority>:
SYSCALL(set_priority)
 66b:	b8 17 00 00 00       	mov    $0x17,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <get_sched_record>:
SYSCALL(get_sched_record)
 673:	b8 18 00 00 00       	mov    $0x18,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 67b:	55                   	push   %ebp
 67c:	89 e5                	mov    %esp,%ebp
 67e:	83 ec 18             	sub    $0x18,%esp
 681:	8b 45 0c             	mov    0xc(%ebp),%eax
 684:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 687:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 68e:	00 
 68f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 692:	89 44 24 04          	mov    %eax,0x4(%esp)
 696:	8b 45 08             	mov    0x8(%ebp),%eax
 699:	89 04 24             	mov    %eax,(%esp)
 69c:	e8 42 ff ff ff       	call   5e3 <write>
}
 6a1:	c9                   	leave  
 6a2:	c3                   	ret    

000006a3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6a3:	55                   	push   %ebp
 6a4:	89 e5                	mov    %esp,%ebp
 6a6:	56                   	push   %esi
 6a7:	53                   	push   %ebx
 6a8:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6b6:	74 17                	je     6cf <printint+0x2c>
 6b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6bc:	79 11                	jns    6cf <printint+0x2c>
    neg = 1;
 6be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c8:	f7 d8                	neg    %eax
 6ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6cd:	eb 06                	jmp    6d5 <printint+0x32>
  } else {
    x = xx;
 6cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6df:	8d 41 01             	lea    0x1(%ecx),%eax
 6e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6eb:	ba 00 00 00 00       	mov    $0x0,%edx
 6f0:	f7 f3                	div    %ebx
 6f2:	89 d0                	mov    %edx,%eax
 6f4:	0f b6 80 30 0e 00 00 	movzbl 0xe30(%eax),%eax
 6fb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6ff:	8b 75 10             	mov    0x10(%ebp),%esi
 702:	8b 45 ec             	mov    -0x14(%ebp),%eax
 705:	ba 00 00 00 00       	mov    $0x0,%edx
 70a:	f7 f6                	div    %esi
 70c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 70f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 713:	75 c7                	jne    6dc <printint+0x39>
  if(neg)
 715:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 719:	74 10                	je     72b <printint+0x88>
    buf[i++] = '-';
 71b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71e:	8d 50 01             	lea    0x1(%eax),%edx
 721:	89 55 f4             	mov    %edx,-0xc(%ebp)
 724:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 729:	eb 1f                	jmp    74a <printint+0xa7>
 72b:	eb 1d                	jmp    74a <printint+0xa7>
    putc(fd, buf[i]);
 72d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 730:	8b 45 f4             	mov    -0xc(%ebp),%eax
 733:	01 d0                	add    %edx,%eax
 735:	0f b6 00             	movzbl (%eax),%eax
 738:	0f be c0             	movsbl %al,%eax
 73b:	89 44 24 04          	mov    %eax,0x4(%esp)
 73f:	8b 45 08             	mov    0x8(%ebp),%eax
 742:	89 04 24             	mov    %eax,(%esp)
 745:	e8 31 ff ff ff       	call   67b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 74a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 74e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 752:	79 d9                	jns    72d <printint+0x8a>
    putc(fd, buf[i]);
}
 754:	83 c4 30             	add    $0x30,%esp
 757:	5b                   	pop    %ebx
 758:	5e                   	pop    %esi
 759:	5d                   	pop    %ebp
 75a:	c3                   	ret    

0000075b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 75b:	55                   	push   %ebp
 75c:	89 e5                	mov    %esp,%ebp
 75e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 761:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 768:	8d 45 0c             	lea    0xc(%ebp),%eax
 76b:	83 c0 04             	add    $0x4,%eax
 76e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 778:	e9 7c 01 00 00       	jmp    8f9 <printf+0x19e>
    c = fmt[i] & 0xff;
 77d:	8b 55 0c             	mov    0xc(%ebp),%edx
 780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 783:	01 d0                	add    %edx,%eax
 785:	0f b6 00             	movzbl (%eax),%eax
 788:	0f be c0             	movsbl %al,%eax
 78b:	25 ff 00 00 00       	and    $0xff,%eax
 790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 793:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 797:	75 2c                	jne    7c5 <printf+0x6a>
      if(c == '%'){
 799:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 79d:	75 0c                	jne    7ab <printf+0x50>
        state = '%';
 79f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7a6:	e9 4a 01 00 00       	jmp    8f5 <printf+0x19a>
      } else {
        putc(fd, c);
 7ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ae:	0f be c0             	movsbl %al,%eax
 7b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b5:	8b 45 08             	mov    0x8(%ebp),%eax
 7b8:	89 04 24             	mov    %eax,(%esp)
 7bb:	e8 bb fe ff ff       	call   67b <putc>
 7c0:	e9 30 01 00 00       	jmp    8f5 <printf+0x19a>
      }
    } else if(state == '%'){
 7c5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7c9:	0f 85 26 01 00 00    	jne    8f5 <printf+0x19a>
      if(c == 'd'){
 7cf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7d3:	75 2d                	jne    802 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7e1:	00 
 7e2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7e9:	00 
 7ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ee:	8b 45 08             	mov    0x8(%ebp),%eax
 7f1:	89 04 24             	mov    %eax,(%esp)
 7f4:	e8 aa fe ff ff       	call   6a3 <printint>
        ap++;
 7f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7fd:	e9 ec 00 00 00       	jmp    8ee <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 802:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 806:	74 06                	je     80e <printf+0xb3>
 808:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 80c:	75 2d                	jne    83b <printf+0xe0>
        printint(fd, *ap, 16, 0);
 80e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 81a:	00 
 81b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 822:	00 
 823:	89 44 24 04          	mov    %eax,0x4(%esp)
 827:	8b 45 08             	mov    0x8(%ebp),%eax
 82a:	89 04 24             	mov    %eax,(%esp)
 82d:	e8 71 fe ff ff       	call   6a3 <printint>
        ap++;
 832:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 836:	e9 b3 00 00 00       	jmp    8ee <printf+0x193>
      } else if(c == 's'){
 83b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 83f:	75 45                	jne    886 <printf+0x12b>
        s = (char*)*ap;
 841:	8b 45 e8             	mov    -0x18(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 849:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 84d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 851:	75 09                	jne    85c <printf+0x101>
          s = "(null)";
 853:	c7 45 f4 60 0b 00 00 	movl   $0xb60,-0xc(%ebp)
        while(*s != 0){
 85a:	eb 1e                	jmp    87a <printf+0x11f>
 85c:	eb 1c                	jmp    87a <printf+0x11f>
          putc(fd, *s);
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	0f b6 00             	movzbl (%eax),%eax
 864:	0f be c0             	movsbl %al,%eax
 867:	89 44 24 04          	mov    %eax,0x4(%esp)
 86b:	8b 45 08             	mov    0x8(%ebp),%eax
 86e:	89 04 24             	mov    %eax,(%esp)
 871:	e8 05 fe ff ff       	call   67b <putc>
          s++;
 876:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	84 c0                	test   %al,%al
 882:	75 da                	jne    85e <printf+0x103>
 884:	eb 68                	jmp    8ee <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 886:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 88a:	75 1d                	jne    8a9 <printf+0x14e>
        putc(fd, *ap);
 88c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 88f:	8b 00                	mov    (%eax),%eax
 891:	0f be c0             	movsbl %al,%eax
 894:	89 44 24 04          	mov    %eax,0x4(%esp)
 898:	8b 45 08             	mov    0x8(%ebp),%eax
 89b:	89 04 24             	mov    %eax,(%esp)
 89e:	e8 d8 fd ff ff       	call   67b <putc>
        ap++;
 8a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8a7:	eb 45                	jmp    8ee <printf+0x193>
      } else if(c == '%'){
 8a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ad:	75 17                	jne    8c6 <printf+0x16b>
        putc(fd, c);
 8af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b2:	0f be c0             	movsbl %al,%eax
 8b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b9:	8b 45 08             	mov    0x8(%ebp),%eax
 8bc:	89 04 24             	mov    %eax,(%esp)
 8bf:	e8 b7 fd ff ff       	call   67b <putc>
 8c4:	eb 28                	jmp    8ee <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8cd:	00 
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	89 04 24             	mov    %eax,(%esp)
 8d4:	e8 a2 fd ff ff       	call   67b <putc>
        putc(fd, c);
 8d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8dc:	0f be c0             	movsbl %al,%eax
 8df:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e3:	8b 45 08             	mov    0x8(%ebp),%eax
 8e6:	89 04 24             	mov    %eax,(%esp)
 8e9:	e8 8d fd ff ff       	call   67b <putc>
      }
      state = 0;
 8ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	01 d0                	add    %edx,%eax
 901:	0f b6 00             	movzbl (%eax),%eax
 904:	84 c0                	test   %al,%al
 906:	0f 85 71 fe ff ff    	jne    77d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 90c:	c9                   	leave  
 90d:	c3                   	ret    

0000090e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90e:	55                   	push   %ebp
 90f:	89 e5                	mov    %esp,%ebp
 911:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 914:	8b 45 08             	mov    0x8(%ebp),%eax
 917:	83 e8 08             	sub    $0x8,%eax
 91a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91d:	a1 68 0e 00 00       	mov    0xe68,%eax
 922:	89 45 fc             	mov    %eax,-0x4(%ebp)
 925:	eb 24                	jmp    94b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92f:	77 12                	ja     943 <free+0x35>
 931:	8b 45 f8             	mov    -0x8(%ebp),%eax
 934:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 937:	77 24                	ja     95d <free+0x4f>
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 00                	mov    (%eax),%eax
 93e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 941:	77 1a                	ja     95d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	8b 00                	mov    (%eax),%eax
 948:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 951:	76 d4                	jbe    927 <free+0x19>
 953:	8b 45 fc             	mov    -0x4(%ebp),%eax
 956:	8b 00                	mov    (%eax),%eax
 958:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95b:	76 ca                	jbe    927 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 960:	8b 40 04             	mov    0x4(%eax),%eax
 963:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96d:	01 c2                	add    %eax,%edx
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	8b 00                	mov    (%eax),%eax
 974:	39 c2                	cmp    %eax,%edx
 976:	75 24                	jne    99c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 978:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97b:	8b 50 04             	mov    0x4(%eax),%edx
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	01 c2                	add    %eax,%edx
 988:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 991:	8b 00                	mov    (%eax),%eax
 993:	8b 10                	mov    (%eax),%edx
 995:	8b 45 f8             	mov    -0x8(%ebp),%eax
 998:	89 10                	mov    %edx,(%eax)
 99a:	eb 0a                	jmp    9a6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 10                	mov    (%eax),%edx
 9a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a9:	8b 40 04             	mov    0x4(%eax),%eax
 9ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b6:	01 d0                	add    %edx,%eax
 9b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9bb:	75 20                	jne    9dd <free+0xcf>
    p->s.size += bp->s.size;
 9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c0:	8b 50 04             	mov    0x4(%eax),%edx
 9c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c6:	8b 40 04             	mov    0x4(%eax),%eax
 9c9:	01 c2                	add    %eax,%edx
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d4:	8b 10                	mov    (%eax),%edx
 9d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d9:	89 10                	mov    %edx,(%eax)
 9db:	eb 08                	jmp    9e5 <free+0xd7>
  } else
    p->s.ptr = bp;
 9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9e3:	89 10                	mov    %edx,(%eax)
  freep = p;
 9e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e8:	a3 68 0e 00 00       	mov    %eax,0xe68
}
 9ed:	c9                   	leave  
 9ee:	c3                   	ret    

000009ef <morecore>:

static Header*
morecore(uint nu)
{
 9ef:	55                   	push   %ebp
 9f0:	89 e5                	mov    %esp,%ebp
 9f2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9f5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9fc:	77 07                	ja     a05 <morecore+0x16>
    nu = 4096;
 9fe:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a05:	8b 45 08             	mov    0x8(%ebp),%eax
 a08:	c1 e0 03             	shl    $0x3,%eax
 a0b:	89 04 24             	mov    %eax,(%esp)
 a0e:	e8 38 fc ff ff       	call   64b <sbrk>
 a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a16:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a1a:	75 07                	jne    a23 <morecore+0x34>
    return 0;
 a1c:	b8 00 00 00 00       	mov    $0x0,%eax
 a21:	eb 22                	jmp    a45 <morecore+0x56>
  hp = (Header*)p;
 a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2c:	8b 55 08             	mov    0x8(%ebp),%edx
 a2f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a35:	83 c0 08             	add    $0x8,%eax
 a38:	89 04 24             	mov    %eax,(%esp)
 a3b:	e8 ce fe ff ff       	call   90e <free>
  return freep;
 a40:	a1 68 0e 00 00       	mov    0xe68,%eax
}
 a45:	c9                   	leave  
 a46:	c3                   	ret    

00000a47 <malloc>:

void*
malloc(uint nbytes)
{
 a47:	55                   	push   %ebp
 a48:	89 e5                	mov    %esp,%ebp
 a4a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a4d:	8b 45 08             	mov    0x8(%ebp),%eax
 a50:	83 c0 07             	add    $0x7,%eax
 a53:	c1 e8 03             	shr    $0x3,%eax
 a56:	83 c0 01             	add    $0x1,%eax
 a59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a5c:	a1 68 0e 00 00       	mov    0xe68,%eax
 a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a68:	75 23                	jne    a8d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a6a:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
 a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a74:	a3 68 0e 00 00       	mov    %eax,0xe68
 a79:	a1 68 0e 00 00       	mov    0xe68,%eax
 a7e:	a3 60 0e 00 00       	mov    %eax,0xe60
    base.s.size = 0;
 a83:	c7 05 64 0e 00 00 00 	movl   $0x0,0xe64
 a8a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a90:	8b 00                	mov    (%eax),%eax
 a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a98:	8b 40 04             	mov    0x4(%eax),%eax
 a9b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a9e:	72 4d                	jb     aed <malloc+0xa6>
      if(p->s.size == nunits)
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	8b 40 04             	mov    0x4(%eax),%eax
 aa6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa9:	75 0c                	jne    ab7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aae:	8b 10                	mov    (%eax),%edx
 ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab3:	89 10                	mov    %edx,(%eax)
 ab5:	eb 26                	jmp    add <malloc+0x96>
      else {
        p->s.size -= nunits;
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	8b 40 04             	mov    0x4(%eax),%eax
 abd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ac0:	89 c2                	mov    %eax,%edx
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acb:	8b 40 04             	mov    0x4(%eax),%eax
 ace:	c1 e0 03             	shl    $0x3,%eax
 ad1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ada:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	a3 68 0e 00 00       	mov    %eax,0xe68
      return (void*)(p + 1);
 ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae8:	83 c0 08             	add    $0x8,%eax
 aeb:	eb 38                	jmp    b25 <malloc+0xde>
    }
    if(p == freep)
 aed:	a1 68 0e 00 00       	mov    0xe68,%eax
 af2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 af5:	75 1b                	jne    b12 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 afa:	89 04 24             	mov    %eax,(%esp)
 afd:	e8 ed fe ff ff       	call   9ef <morecore>
 b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b09:	75 07                	jne    b12 <malloc+0xcb>
        return 0;
 b0b:	b8 00 00 00 00       	mov    $0x0,%eax
 b10:	eb 13                	jmp    b25 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1b:	8b 00                	mov    (%eax),%eax
 b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b20:	e9 70 ff ff ff       	jmp    a95 <malloc+0x4e>
}
 b25:	c9                   	leave  
 b26:	c3                   	ret    
