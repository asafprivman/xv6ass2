
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 40 10 00 00 	movl   $0x1040,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 51                	jmp    72 <grep+0x72>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 bc 01 00 00       	call   1f5 <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	29 c2                	sub    %eax,%edx
  50:	89 d0                	mov    %edx,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	89 44 24 04          	mov    %eax,0x4(%esp)
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 f6 06 00 00       	call   75f <write>
      }
      p = q+1;
  69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6c:	83 c0 01             	add    $0x1,%eax
  6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  72:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  79:	00 
  7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7d:	89 04 24             	mov    %eax,(%esp)
  80:	e8 12 04 00 00       	call   497 <strchr>
  85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8c:	75 93                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8e:	81 7d f0 40 10 00 00 	cmpl   $0x1040,-0x10(%ebp)
  95:	75 07                	jne    9e <grep+0x9e>
      m = 0;
  97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	7e 29                	jle    cd <grep+0xcd>
      m -= p - buf;
  a4:	ba 40 10 00 00       	mov    $0x1040,%edx
  a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ac:	29 c2                	sub    %eax,%edx
  ae:	89 d0                	mov    %edx,%eax
  b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  c1:	c7 04 24 40 10 00 00 	movl   $0x1040,(%esp)
  c8:	e8 0e 05 00 00       	call   5db <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d0:	ba 00 04 00 00       	mov    $0x400,%edx
  d5:	29 c2                	sub    %eax,%edx
  d7:	89 d0                	mov    %edx,%eax
  d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  dc:	81 c2 40 10 00 00    	add    $0x1040,%edx
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 04 24             	mov    %eax,(%esp)
  f0:	e8 62 06 00 00       	call   757 <read>
  f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  fc:	0f 8f 10 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <main>:

int
main(int argc, char *argv[])
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
 10a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 10d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 111:	7f 19                	jg     12c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 113:	c7 44 24 04 a4 0c 00 	movl   $0xca4,0x4(%esp)
 11a:	00 
 11b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 122:	e8 b0 07 00 00       	call   8d7 <printf>
    exit();
 127:	e8 13 06 00 00       	call   73f <exit>
  }
  pattern = argv[1];
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	8b 40 04             	mov    0x4(%eax),%eax
 132:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 136:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 13a:	7f 19                	jg     155 <main+0x51>
    grep(pattern, 0);
 13c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 143:	00 
 144:	8b 44 24 18          	mov    0x18(%esp),%eax
 148:	89 04 24             	mov    %eax,(%esp)
 14b:	e8 b0 fe ff ff       	call   0 <grep>
    exit();
 150:	e8 ea 05 00 00       	call   73f <exit>
  }

  for(i = 2; i < argc; i++){
 155:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 15c:	00 
 15d:	e9 81 00 00 00       	jmp    1e3 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 162:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16d:	8b 45 0c             	mov    0xc(%ebp),%eax
 170:	01 d0                	add    %edx,%eax
 172:	8b 00                	mov    (%eax),%eax
 174:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 17b:	00 
 17c:	89 04 24             	mov    %eax,(%esp)
 17f:	e8 fb 05 00 00       	call   77f <open>
 184:	89 44 24 14          	mov    %eax,0x14(%esp)
 188:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 18d:	79 2f                	jns    1be <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 18f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 193:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	01 d0                	add    %edx,%eax
 19f:	8b 00                	mov    (%eax),%eax
 1a1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a5:	c7 44 24 04 c4 0c 00 	movl   $0xcc4,0x4(%esp)
 1ac:	00 
 1ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b4:	e8 1e 07 00 00       	call   8d7 <printf>
      exit();
 1b9:	e8 81 05 00 00       	call   73f <exit>
    }
    grep(pattern, fd);
 1be:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ca:	89 04 24             	mov    %eax,(%esp)
 1cd:	e8 2e fe ff ff       	call   0 <grep>
    close(fd);
 1d2:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d6:	89 04 24             	mov    %eax,(%esp)
 1d9:	e8 89 05 00 00       	call   767 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1de:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1e3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1e7:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ea:	0f 8c 72 ff ff ff    	jl     162 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1f0:	e8 4a 05 00 00       	call   73f <exit>

000001f5 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	0f b6 00             	movzbl (%eax),%eax
 201:	3c 5e                	cmp    $0x5e,%al
 203:	75 17                	jne    21c <match+0x27>
    return matchhere(re+1, text);
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8d 50 01             	lea    0x1(%eax),%edx
 20b:	8b 45 0c             	mov    0xc(%ebp),%eax
 20e:	89 44 24 04          	mov    %eax,0x4(%esp)
 212:	89 14 24             	mov    %edx,(%esp)
 215:	e8 36 00 00 00       	call   250 <matchhere>
 21a:	eb 32                	jmp    24e <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	89 44 24 04          	mov    %eax,0x4(%esp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	89 04 24             	mov    %eax,(%esp)
 229:	e8 22 00 00 00       	call   250 <matchhere>
 22e:	85 c0                	test   %eax,%eax
 230:	74 07                	je     239 <match+0x44>
      return 1;
 232:	b8 01 00 00 00       	mov    $0x1,%eax
 237:	eb 15                	jmp    24e <match+0x59>
  }while(*text++ != '\0');
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	8d 50 01             	lea    0x1(%eax),%edx
 23f:	89 55 0c             	mov    %edx,0xc(%ebp)
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	75 d3                	jne    21c <match+0x27>
  return 0;
 249:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	84 c0                	test   %al,%al
 25e:	75 0a                	jne    26a <matchhere+0x1a>
    return 1;
 260:	b8 01 00 00 00       	mov    $0x1,%eax
 265:	e9 9b 00 00 00       	jmp    305 <matchhere+0xb5>
  if(re[1] == '*')
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	83 c0 01             	add    $0x1,%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2a                	cmp    $0x2a,%al
 275:	75 24                	jne    29b <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	8d 48 02             	lea    0x2(%eax),%ecx
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	0f b6 00             	movzbl (%eax),%eax
 283:	0f be c0             	movsbl %al,%eax
 286:	8b 55 0c             	mov    0xc(%ebp),%edx
 289:	89 54 24 08          	mov    %edx,0x8(%esp)
 28d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 291:	89 04 24             	mov    %eax,(%esp)
 294:	e8 6e 00 00 00       	call   307 <matchstar>
 299:	eb 6a                	jmp    305 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	3c 24                	cmp    $0x24,%al
 2a3:	75 1d                	jne    2c2 <matchhere+0x72>
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	84 c0                	test   %al,%al
 2b0:	75 10                	jne    2c2 <matchhere+0x72>
    return *text == '\0';
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	84 c0                	test   %al,%al
 2ba:	0f 94 c0             	sete   %al
 2bd:	0f b6 c0             	movzbl %al,%eax
 2c0:	eb 43                	jmp    305 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c5:	0f b6 00             	movzbl (%eax),%eax
 2c8:	84 c0                	test   %al,%al
 2ca:	74 34                	je     300 <matchhere+0xb0>
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	3c 2e                	cmp    $0x2e,%al
 2d4:	74 10                	je     2e6 <matchhere+0x96>
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	0f b6 10             	movzbl (%eax),%edx
 2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	38 c2                	cmp    %al,%dl
 2e4:	75 1a                	jne    300 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e9:	8d 50 01             	lea    0x1(%eax),%edx
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	83 c0 01             	add    $0x1,%eax
 2f2:	89 54 24 04          	mov    %edx,0x4(%esp)
 2f6:	89 04 24             	mov    %eax,(%esp)
 2f9:	e8 52 ff ff ff       	call   250 <matchhere>
 2fe:	eb 05                	jmp    305 <matchhere+0xb5>
  return 0;
 300:	b8 00 00 00 00       	mov    $0x0,%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 30d:	8b 45 10             	mov    0x10(%ebp),%eax
 310:	89 44 24 04          	mov    %eax,0x4(%esp)
 314:	8b 45 0c             	mov    0xc(%ebp),%eax
 317:	89 04 24             	mov    %eax,(%esp)
 31a:	e8 31 ff ff ff       	call   250 <matchhere>
 31f:	85 c0                	test   %eax,%eax
 321:	74 07                	je     32a <matchstar+0x23>
      return 1;
 323:	b8 01 00 00 00       	mov    $0x1,%eax
 328:	eb 29                	jmp    353 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 32a:	8b 45 10             	mov    0x10(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	84 c0                	test   %al,%al
 332:	74 1a                	je     34e <matchstar+0x47>
 334:	8b 45 10             	mov    0x10(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 10             	mov    %edx,0x10(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	3b 45 08             	cmp    0x8(%ebp),%eax
 346:	74 c5                	je     30d <matchstar+0x6>
 348:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 34c:	74 bf                	je     30d <matchstar+0x6>
  return 0;
 34e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	57                   	push   %edi
 359:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 35a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35d:	8b 55 10             	mov    0x10(%ebp),%edx
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	89 cb                	mov    %ecx,%ebx
 365:	89 df                	mov    %ebx,%edi
 367:	89 d1                	mov    %edx,%ecx
 369:	fc                   	cld    
 36a:	f3 aa                	rep stos %al,%es:(%edi)
 36c:	89 ca                	mov    %ecx,%edx
 36e:	89 fb                	mov    %edi,%ebx
 370:	89 5d 08             	mov    %ebx,0x8(%ebp)
 373:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 376:	5b                   	pop    %ebx
 377:	5f                   	pop    %edi
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    

0000037a <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp
 37d:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 380:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	89 04 24             	mov    %eax,(%esp)
 38d:	e8 ba 00 00 00       	call   44c <strlen>
 392:	83 e8 01             	sub    $0x1,%eax
 395:	89 45 f0             	mov    %eax,-0x10(%ebp)
 398:	eb 39                	jmp    3d3 <reverse+0x59>
         c = s[i];
 39a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
 3a0:	01 d0                	add    %edx,%eax
 3a2:	0f b6 00             	movzbl (%eax),%eax
 3a5:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
 3a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	01 c2                	add    %eax,%edx
 3b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	01 c8                	add    %ecx,%eax
 3b8:	0f b6 00             	movzbl (%eax),%eax
 3bb:	88 02                	mov    %al,(%edx)
         s[j] = c;
 3bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	01 c2                	add    %eax,%edx
 3c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3c9:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 3cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 3cf:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 3d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 3d9:	7c bf                	jl     39a <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 3db:	c9                   	leave  
 3dc:	c3                   	ret    

000003dd <strcpy>:

char*
strcpy(char *s, char *t)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3e9:	90                   	nop
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 08             	mov    %edx,0x8(%ebp)
 3f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 3f6:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3fc:	0f b6 12             	movzbl (%edx),%edx
 3ff:	88 10                	mov    %dl,(%eax)
 401:	0f b6 00             	movzbl (%eax),%eax
 404:	84 c0                	test   %al,%al
 406:	75 e2                	jne    3ea <strcpy+0xd>
    ;
  return os;
 408:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40b:	c9                   	leave  
 40c:	c3                   	ret    

0000040d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 40d:	55                   	push   %ebp
 40e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 410:	eb 08                	jmp    41a <strcmp+0xd>
    p++, q++;
 412:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 416:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	84 c0                	test   %al,%al
 422:	74 10                	je     434 <strcmp+0x27>
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	0f b6 10             	movzbl (%eax),%edx
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	38 c2                	cmp    %al,%dl
 432:	74 de                	je     412 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	0f b6 00             	movzbl (%eax),%eax
 43a:	0f b6 d0             	movzbl %al,%edx
 43d:	8b 45 0c             	mov    0xc(%ebp),%eax
 440:	0f b6 00             	movzbl (%eax),%eax
 443:	0f b6 c0             	movzbl %al,%eax
 446:	29 c2                	sub    %eax,%edx
 448:	89 d0                	mov    %edx,%eax
}
 44a:	5d                   	pop    %ebp
 44b:	c3                   	ret    

0000044c <strlen>:

uint
strlen(char *s)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 452:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 459:	eb 04                	jmp    45f <strlen+0x13>
 45b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 45f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	01 d0                	add    %edx,%eax
 467:	0f b6 00             	movzbl (%eax),%eax
 46a:	84 c0                	test   %al,%al
 46c:	75 ed                	jne    45b <strlen+0xf>
    ;
  return n;
 46e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 471:	c9                   	leave  
 472:	c3                   	ret    

00000473 <memset>:

void*
memset(void *dst, int c, uint n)
{
 473:	55                   	push   %ebp
 474:	89 e5                	mov    %esp,%ebp
 476:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 479:	8b 45 10             	mov    0x10(%ebp),%eax
 47c:	89 44 24 08          	mov    %eax,0x8(%esp)
 480:	8b 45 0c             	mov    0xc(%ebp),%eax
 483:	89 44 24 04          	mov    %eax,0x4(%esp)
 487:	8b 45 08             	mov    0x8(%ebp),%eax
 48a:	89 04 24             	mov    %eax,(%esp)
 48d:	e8 c3 fe ff ff       	call   355 <stosb>
  return dst;
 492:	8b 45 08             	mov    0x8(%ebp),%eax
}
 495:	c9                   	leave  
 496:	c3                   	ret    

00000497 <strchr>:

char*
strchr(const char *s, char c)
{
 497:	55                   	push   %ebp
 498:	89 e5                	mov    %esp,%ebp
 49a:	83 ec 04             	sub    $0x4,%esp
 49d:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4a3:	eb 14                	jmp    4b9 <strchr+0x22>
    if(*s == c)
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	0f b6 00             	movzbl (%eax),%eax
 4ab:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4ae:	75 05                	jne    4b5 <strchr+0x1e>
      return (char*)s;
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	eb 13                	jmp    4c8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	0f b6 00             	movzbl (%eax),%eax
 4bf:	84 c0                	test   %al,%al
 4c1:	75 e2                	jne    4a5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 4c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4c8:	c9                   	leave  
 4c9:	c3                   	ret    

000004ca <gets>:

char*
gets(char *buf, int max)
{
 4ca:	55                   	push   %ebp
 4cb:	89 e5                	mov    %esp,%ebp
 4cd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4d7:	eb 4c                	jmp    525 <gets+0x5b>
    cc = read(0, &c, 1);
 4d9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e0:	00 
 4e1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4ef:	e8 63 02 00 00       	call   757 <read>
 4f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fb:	7f 02                	jg     4ff <gets+0x35>
      break;
 4fd:	eb 31                	jmp    530 <gets+0x66>
    buf[i++] = c;
 4ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 502:	8d 50 01             	lea    0x1(%eax),%edx
 505:	89 55 f4             	mov    %edx,-0xc(%ebp)
 508:	89 c2                	mov    %eax,%edx
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
 50d:	01 c2                	add    %eax,%edx
 50f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 513:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 515:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 519:	3c 0a                	cmp    $0xa,%al
 51b:	74 13                	je     530 <gets+0x66>
 51d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 521:	3c 0d                	cmp    $0xd,%al
 523:	74 0b                	je     530 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 525:	8b 45 f4             	mov    -0xc(%ebp),%eax
 528:	83 c0 01             	add    $0x1,%eax
 52b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 52e:	7c a9                	jl     4d9 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 530:	8b 55 f4             	mov    -0xc(%ebp),%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	01 d0                	add    %edx,%eax
 538:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 53e:	c9                   	leave  
 53f:	c3                   	ret    

00000540 <stat>:

int
stat(char *n, struct stat *st)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 546:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 54d:	00 
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 04 24             	mov    %eax,(%esp)
 554:	e8 26 02 00 00       	call   77f <open>
 559:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 55c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 560:	79 07                	jns    569 <stat+0x29>
    return -1;
 562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 567:	eb 23                	jmp    58c <stat+0x4c>
  r = fstat(fd, st);
 569:	8b 45 0c             	mov    0xc(%ebp),%eax
 56c:	89 44 24 04          	mov    %eax,0x4(%esp)
 570:	8b 45 f4             	mov    -0xc(%ebp),%eax
 573:	89 04 24             	mov    %eax,(%esp)
 576:	e8 1c 02 00 00       	call   797 <fstat>
 57b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 57e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 581:	89 04 24             	mov    %eax,(%esp)
 584:	e8 de 01 00 00       	call   767 <close>
  return r;
 589:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 58c:	c9                   	leave  
 58d:	c3                   	ret    

0000058e <atoi>:

int
atoi(const char *s)
{
 58e:	55                   	push   %ebp
 58f:	89 e5                	mov    %esp,%ebp
 591:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 594:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 59b:	eb 25                	jmp    5c2 <atoi+0x34>
    n = n*10 + *s++ - '0';
 59d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5a0:	89 d0                	mov    %edx,%eax
 5a2:	c1 e0 02             	shl    $0x2,%eax
 5a5:	01 d0                	add    %edx,%eax
 5a7:	01 c0                	add    %eax,%eax
 5a9:	89 c1                	mov    %eax,%ecx
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	8d 50 01             	lea    0x1(%eax),%edx
 5b1:	89 55 08             	mov    %edx,0x8(%ebp)
 5b4:	0f b6 00             	movzbl (%eax),%eax
 5b7:	0f be c0             	movsbl %al,%eax
 5ba:	01 c8                	add    %ecx,%eax
 5bc:	83 e8 30             	sub    $0x30,%eax
 5bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	0f b6 00             	movzbl (%eax),%eax
 5c8:	3c 2f                	cmp    $0x2f,%al
 5ca:	7e 0a                	jle    5d6 <atoi+0x48>
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	0f b6 00             	movzbl (%eax),%eax
 5d2:	3c 39                	cmp    $0x39,%al
 5d4:	7e c7                	jle    59d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 5d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5d9:	c9                   	leave  
 5da:	c3                   	ret    

000005db <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5db:	55                   	push   %ebp
 5dc:	89 e5                	mov    %esp,%ebp
 5de:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5ed:	eb 17                	jmp    606 <memmove+0x2b>
    *dst++ = *src++;
 5ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f2:	8d 50 01             	lea    0x1(%eax),%edx
 5f5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5fb:	8d 4a 01             	lea    0x1(%edx),%ecx
 5fe:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 601:	0f b6 12             	movzbl (%edx),%edx
 604:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 606:	8b 45 10             	mov    0x10(%ebp),%eax
 609:	8d 50 ff             	lea    -0x1(%eax),%edx
 60c:	89 55 10             	mov    %edx,0x10(%ebp)
 60f:	85 c0                	test   %eax,%eax
 611:	7f dc                	jg     5ef <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 613:	8b 45 08             	mov    0x8(%ebp),%eax
}
 616:	c9                   	leave  
 617:	c3                   	ret    

00000618 <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	53                   	push   %ebx
 61c:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	89 45 f0             	mov    %eax,-0x10(%ebp)
 625:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 629:	79 03                	jns    62e <itoa+0x16>
         n = -n;          /* make n positive */
 62b:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 62e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 635:	8b 45 f4             	mov    -0xc(%ebp),%eax
 638:	8d 50 01             	lea    0x1(%eax),%edx
 63b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 63e:	89 c2                	mov    %eax,%edx
 640:	8b 45 0c             	mov    0xc(%ebp),%eax
 643:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 646:	8b 4d 08             	mov    0x8(%ebp),%ecx
 649:	ba 67 66 66 66       	mov    $0x66666667,%edx
 64e:	89 c8                	mov    %ecx,%eax
 650:	f7 ea                	imul   %edx
 652:	c1 fa 02             	sar    $0x2,%edx
 655:	89 c8                	mov    %ecx,%eax
 657:	c1 f8 1f             	sar    $0x1f,%eax
 65a:	29 c2                	sub    %eax,%edx
 65c:	89 d0                	mov    %edx,%eax
 65e:	c1 e0 02             	shl    $0x2,%eax
 661:	01 d0                	add    %edx,%eax
 663:	01 c0                	add    %eax,%eax
 665:	29 c1                	sub    %eax,%ecx
 667:	89 ca                	mov    %ecx,%edx
 669:	89 d0                	mov    %edx,%eax
 66b:	83 c0 30             	add    $0x30,%eax
 66e:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 670:	8b 4d 08             	mov    0x8(%ebp),%ecx
 673:	ba 67 66 66 66       	mov    $0x66666667,%edx
 678:	89 c8                	mov    %ecx,%eax
 67a:	f7 ea                	imul   %edx
 67c:	c1 fa 02             	sar    $0x2,%edx
 67f:	89 c8                	mov    %ecx,%eax
 681:	c1 f8 1f             	sar    $0x1f,%eax
 684:	29 c2                	sub    %eax,%edx
 686:	89 d0                	mov    %edx,%eax
 688:	89 45 08             	mov    %eax,0x8(%ebp)
 68b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 68f:	7f a4                	jg     635 <itoa+0x1d>
     if (sign < 0)
 691:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 695:	79 13                	jns    6aa <itoa+0x92>
         s[i++] = '-';
 697:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69a:	8d 50 01             	lea    0x1(%eax),%edx
 69d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a0:	89 c2                	mov    %eax,%edx
 6a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a5:	01 d0                	add    %edx,%eax
 6a7:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 6aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b0:	01 d0                	add    %edx,%eax
 6b2:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 6b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b8:	89 04 24             	mov    %eax,(%esp)
 6bb:	e8 ba fc ff ff       	call   37a <reverse>
 }
 6c0:	83 c4 24             	add    $0x24,%esp
 6c3:	5b                   	pop    %ebx
 6c4:	5d                   	pop    %ebp
 6c5:	c3                   	ret    

000006c6 <strcat>:

char *
strcat(char *dest, const char *src)
{
 6c6:	55                   	push   %ebp
 6c7:	89 e5                	mov    %esp,%ebp
 6c9:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 6cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6d3:	eb 04                	jmp    6d9 <strcat+0x13>
 6d5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	01 d0                	add    %edx,%eax
 6e1:	0f b6 00             	movzbl (%eax),%eax
 6e4:	84 c0                	test   %al,%al
 6e6:	75 ed                	jne    6d5 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 6e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 6ef:	eb 20                	jmp    711 <strcat+0x4b>
        dest[i+j] = src[j];
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6f7:	01 d0                	add    %edx,%eax
 6f9:	89 c2                	mov    %eax,%edx
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	01 c2                	add    %eax,%edx
 700:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 703:	8b 45 0c             	mov    0xc(%ebp),%eax
 706:	01 c8                	add    %ecx,%eax
 708:	0f b6 00             	movzbl (%eax),%eax
 70b:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 70d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 711:	8b 55 f8             	mov    -0x8(%ebp),%edx
 714:	8b 45 0c             	mov    0xc(%ebp),%eax
 717:	01 d0                	add    %edx,%eax
 719:	0f b6 00             	movzbl (%eax),%eax
 71c:	84 c0                	test   %al,%al
 71e:	75 d1                	jne    6f1 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	8b 55 fc             	mov    -0x4(%ebp),%edx
 726:	01 d0                	add    %edx,%eax
 728:	89 c2                	mov    %eax,%edx
 72a:	8b 45 08             	mov    0x8(%ebp),%eax
 72d:	01 d0                	add    %edx,%eax
 72f:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 732:	8b 45 08             	mov    0x8(%ebp),%eax
}
 735:	c9                   	leave  
 736:	c3                   	ret    

00000737 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 737:	b8 01 00 00 00       	mov    $0x1,%eax
 73c:	cd 40                	int    $0x40
 73e:	c3                   	ret    

0000073f <exit>:
SYSCALL(exit)
 73f:	b8 02 00 00 00       	mov    $0x2,%eax
 744:	cd 40                	int    $0x40
 746:	c3                   	ret    

00000747 <wait>:
SYSCALL(wait)
 747:	b8 03 00 00 00       	mov    $0x3,%eax
 74c:	cd 40                	int    $0x40
 74e:	c3                   	ret    

0000074f <pipe>:
SYSCALL(pipe)
 74f:	b8 04 00 00 00       	mov    $0x4,%eax
 754:	cd 40                	int    $0x40
 756:	c3                   	ret    

00000757 <read>:
SYSCALL(read)
 757:	b8 05 00 00 00       	mov    $0x5,%eax
 75c:	cd 40                	int    $0x40
 75e:	c3                   	ret    

0000075f <write>:
SYSCALL(write)
 75f:	b8 10 00 00 00       	mov    $0x10,%eax
 764:	cd 40                	int    $0x40
 766:	c3                   	ret    

00000767 <close>:
SYSCALL(close)
 767:	b8 15 00 00 00       	mov    $0x15,%eax
 76c:	cd 40                	int    $0x40
 76e:	c3                   	ret    

0000076f <kill>:
SYSCALL(kill)
 76f:	b8 06 00 00 00       	mov    $0x6,%eax
 774:	cd 40                	int    $0x40
 776:	c3                   	ret    

00000777 <exec>:
SYSCALL(exec)
 777:	b8 07 00 00 00       	mov    $0x7,%eax
 77c:	cd 40                	int    $0x40
 77e:	c3                   	ret    

0000077f <open>:
SYSCALL(open)
 77f:	b8 0f 00 00 00       	mov    $0xf,%eax
 784:	cd 40                	int    $0x40
 786:	c3                   	ret    

00000787 <mknod>:
SYSCALL(mknod)
 787:	b8 11 00 00 00       	mov    $0x11,%eax
 78c:	cd 40                	int    $0x40
 78e:	c3                   	ret    

0000078f <unlink>:
SYSCALL(unlink)
 78f:	b8 12 00 00 00       	mov    $0x12,%eax
 794:	cd 40                	int    $0x40
 796:	c3                   	ret    

00000797 <fstat>:
SYSCALL(fstat)
 797:	b8 08 00 00 00       	mov    $0x8,%eax
 79c:	cd 40                	int    $0x40
 79e:	c3                   	ret    

0000079f <link>:
SYSCALL(link)
 79f:	b8 13 00 00 00       	mov    $0x13,%eax
 7a4:	cd 40                	int    $0x40
 7a6:	c3                   	ret    

000007a7 <mkdir>:
SYSCALL(mkdir)
 7a7:	b8 14 00 00 00       	mov    $0x14,%eax
 7ac:	cd 40                	int    $0x40
 7ae:	c3                   	ret    

000007af <chdir>:
SYSCALL(chdir)
 7af:	b8 09 00 00 00       	mov    $0x9,%eax
 7b4:	cd 40                	int    $0x40
 7b6:	c3                   	ret    

000007b7 <dup>:
SYSCALL(dup)
 7b7:	b8 0a 00 00 00       	mov    $0xa,%eax
 7bc:	cd 40                	int    $0x40
 7be:	c3                   	ret    

000007bf <getpid>:
SYSCALL(getpid)
 7bf:	b8 0b 00 00 00       	mov    $0xb,%eax
 7c4:	cd 40                	int    $0x40
 7c6:	c3                   	ret    

000007c7 <sbrk>:
SYSCALL(sbrk)
 7c7:	b8 0c 00 00 00       	mov    $0xc,%eax
 7cc:	cd 40                	int    $0x40
 7ce:	c3                   	ret    

000007cf <sleep>:
SYSCALL(sleep)
 7cf:	b8 0d 00 00 00       	mov    $0xd,%eax
 7d4:	cd 40                	int    $0x40
 7d6:	c3                   	ret    

000007d7 <uptime>:
SYSCALL(uptime)
 7d7:	b8 0e 00 00 00       	mov    $0xe,%eax
 7dc:	cd 40                	int    $0x40
 7de:	c3                   	ret    

000007df <wait2>:
SYSCALL(wait2)
 7df:	b8 16 00 00 00       	mov    $0x16,%eax
 7e4:	cd 40                	int    $0x40
 7e6:	c3                   	ret    

000007e7 <set_priority>:
SYSCALL(set_priority)
 7e7:	b8 17 00 00 00       	mov    $0x17,%eax
 7ec:	cd 40                	int    $0x40
 7ee:	c3                   	ret    

000007ef <get_sched_record>:
SYSCALL(get_sched_record)
 7ef:	b8 18 00 00 00       	mov    $0x18,%eax
 7f4:	cd 40                	int    $0x40
 7f6:	c3                   	ret    

000007f7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7f7:	55                   	push   %ebp
 7f8:	89 e5                	mov    %esp,%ebp
 7fa:	83 ec 18             	sub    $0x18,%esp
 7fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 800:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 803:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 80a:	00 
 80b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 80e:	89 44 24 04          	mov    %eax,0x4(%esp)
 812:	8b 45 08             	mov    0x8(%ebp),%eax
 815:	89 04 24             	mov    %eax,(%esp)
 818:	e8 42 ff ff ff       	call   75f <write>
}
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 81f:	55                   	push   %ebp
 820:	89 e5                	mov    %esp,%ebp
 822:	56                   	push   %esi
 823:	53                   	push   %ebx
 824:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 827:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 82e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 832:	74 17                	je     84b <printint+0x2c>
 834:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 838:	79 11                	jns    84b <printint+0x2c>
    neg = 1;
 83a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 841:	8b 45 0c             	mov    0xc(%ebp),%eax
 844:	f7 d8                	neg    %eax
 846:	89 45 ec             	mov    %eax,-0x14(%ebp)
 849:	eb 06                	jmp    851 <printint+0x32>
  } else {
    x = xx;
 84b:	8b 45 0c             	mov    0xc(%ebp),%eax
 84e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 858:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 85b:	8d 41 01             	lea    0x1(%ecx),%eax
 85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 861:	8b 5d 10             	mov    0x10(%ebp),%ebx
 864:	8b 45 ec             	mov    -0x14(%ebp),%eax
 867:	ba 00 00 00 00       	mov    $0x0,%edx
 86c:	f7 f3                	div    %ebx
 86e:	89 d0                	mov    %edx,%eax
 870:	0f b6 80 0c 10 00 00 	movzbl 0x100c(%eax),%eax
 877:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 87b:	8b 75 10             	mov    0x10(%ebp),%esi
 87e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 881:	ba 00 00 00 00       	mov    $0x0,%edx
 886:	f7 f6                	div    %esi
 888:	89 45 ec             	mov    %eax,-0x14(%ebp)
 88b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 88f:	75 c7                	jne    858 <printint+0x39>
  if(neg)
 891:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 895:	74 10                	je     8a7 <printint+0x88>
    buf[i++] = '-';
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8d 50 01             	lea    0x1(%eax),%edx
 89d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8a0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8a5:	eb 1f                	jmp    8c6 <printint+0xa7>
 8a7:	eb 1d                	jmp    8c6 <printint+0xa7>
    putc(fd, buf[i]);
 8a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	01 d0                	add    %edx,%eax
 8b1:	0f b6 00             	movzbl (%eax),%eax
 8b4:	0f be c0             	movsbl %al,%eax
 8b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	89 04 24             	mov    %eax,(%esp)
 8c1:	e8 31 ff ff ff       	call   7f7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 8c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 8ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ce:	79 d9                	jns    8a9 <printint+0x8a>
    putc(fd, buf[i]);
}
 8d0:	83 c4 30             	add    $0x30,%esp
 8d3:	5b                   	pop    %ebx
 8d4:	5e                   	pop    %esi
 8d5:	5d                   	pop    %ebp
 8d6:	c3                   	ret    

000008d7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8d7:	55                   	push   %ebp
 8d8:	89 e5                	mov    %esp,%ebp
 8da:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8e4:	8d 45 0c             	lea    0xc(%ebp),%eax
 8e7:	83 c0 04             	add    $0x4,%eax
 8ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8f4:	e9 7c 01 00 00       	jmp    a75 <printf+0x19e>
    c = fmt[i] & 0xff;
 8f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	01 d0                	add    %edx,%eax
 901:	0f b6 00             	movzbl (%eax),%eax
 904:	0f be c0             	movsbl %al,%eax
 907:	25 ff 00 00 00       	and    $0xff,%eax
 90c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 90f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 913:	75 2c                	jne    941 <printf+0x6a>
      if(c == '%'){
 915:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 919:	75 0c                	jne    927 <printf+0x50>
        state = '%';
 91b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 922:	e9 4a 01 00 00       	jmp    a71 <printf+0x19a>
      } else {
        putc(fd, c);
 927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 92a:	0f be c0             	movsbl %al,%eax
 92d:	89 44 24 04          	mov    %eax,0x4(%esp)
 931:	8b 45 08             	mov    0x8(%ebp),%eax
 934:	89 04 24             	mov    %eax,(%esp)
 937:	e8 bb fe ff ff       	call   7f7 <putc>
 93c:	e9 30 01 00 00       	jmp    a71 <printf+0x19a>
      }
    } else if(state == '%'){
 941:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 945:	0f 85 26 01 00 00    	jne    a71 <printf+0x19a>
      if(c == 'd'){
 94b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 94f:	75 2d                	jne    97e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 951:	8b 45 e8             	mov    -0x18(%ebp),%eax
 954:	8b 00                	mov    (%eax),%eax
 956:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 95d:	00 
 95e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 965:	00 
 966:	89 44 24 04          	mov    %eax,0x4(%esp)
 96a:	8b 45 08             	mov    0x8(%ebp),%eax
 96d:	89 04 24             	mov    %eax,(%esp)
 970:	e8 aa fe ff ff       	call   81f <printint>
        ap++;
 975:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 979:	e9 ec 00 00 00       	jmp    a6a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 97e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 982:	74 06                	je     98a <printf+0xb3>
 984:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 988:	75 2d                	jne    9b7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 98a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 98d:	8b 00                	mov    (%eax),%eax
 98f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 996:	00 
 997:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 99e:	00 
 99f:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	89 04 24             	mov    %eax,(%esp)
 9a9:	e8 71 fe ff ff       	call   81f <printint>
        ap++;
 9ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9b2:	e9 b3 00 00 00       	jmp    a6a <printf+0x193>
      } else if(c == 's'){
 9b7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9bb:	75 45                	jne    a02 <printf+0x12b>
        s = (char*)*ap;
 9bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9c0:	8b 00                	mov    (%eax),%eax
 9c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9cd:	75 09                	jne    9d8 <printf+0x101>
          s = "(null)";
 9cf:	c7 45 f4 da 0c 00 00 	movl   $0xcda,-0xc(%ebp)
        while(*s != 0){
 9d6:	eb 1e                	jmp    9f6 <printf+0x11f>
 9d8:	eb 1c                	jmp    9f6 <printf+0x11f>
          putc(fd, *s);
 9da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dd:	0f b6 00             	movzbl (%eax),%eax
 9e0:	0f be c0             	movsbl %al,%eax
 9e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 9e7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ea:	89 04 24             	mov    %eax,(%esp)
 9ed:	e8 05 fe ff ff       	call   7f7 <putc>
          s++;
 9f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f9:	0f b6 00             	movzbl (%eax),%eax
 9fc:	84 c0                	test   %al,%al
 9fe:	75 da                	jne    9da <printf+0x103>
 a00:	eb 68                	jmp    a6a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a02:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a06:	75 1d                	jne    a25 <printf+0x14e>
        putc(fd, *ap);
 a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a0b:	8b 00                	mov    (%eax),%eax
 a0d:	0f be c0             	movsbl %al,%eax
 a10:	89 44 24 04          	mov    %eax,0x4(%esp)
 a14:	8b 45 08             	mov    0x8(%ebp),%eax
 a17:	89 04 24             	mov    %eax,(%esp)
 a1a:	e8 d8 fd ff ff       	call   7f7 <putc>
        ap++;
 a1f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a23:	eb 45                	jmp    a6a <printf+0x193>
      } else if(c == '%'){
 a25:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a29:	75 17                	jne    a42 <printf+0x16b>
        putc(fd, c);
 a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a2e:	0f be c0             	movsbl %al,%eax
 a31:	89 44 24 04          	mov    %eax,0x4(%esp)
 a35:	8b 45 08             	mov    0x8(%ebp),%eax
 a38:	89 04 24             	mov    %eax,(%esp)
 a3b:	e8 b7 fd ff ff       	call   7f7 <putc>
 a40:	eb 28                	jmp    a6a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a42:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a49:	00 
 a4a:	8b 45 08             	mov    0x8(%ebp),%eax
 a4d:	89 04 24             	mov    %eax,(%esp)
 a50:	e8 a2 fd ff ff       	call   7f7 <putc>
        putc(fd, c);
 a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a58:	0f be c0             	movsbl %al,%eax
 a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
 a5f:	8b 45 08             	mov    0x8(%ebp),%eax
 a62:	89 04 24             	mov    %eax,(%esp)
 a65:	e8 8d fd ff ff       	call   7f7 <putc>
      }
      state = 0;
 a6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a71:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a75:	8b 55 0c             	mov    0xc(%ebp),%edx
 a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7b:	01 d0                	add    %edx,%eax
 a7d:	0f b6 00             	movzbl (%eax),%eax
 a80:	84 c0                	test   %al,%al
 a82:	0f 85 71 fe ff ff    	jne    8f9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a88:	c9                   	leave  
 a89:	c3                   	ret    

00000a8a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a8a:	55                   	push   %ebp
 a8b:	89 e5                	mov    %esp,%ebp
 a8d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a90:	8b 45 08             	mov    0x8(%ebp),%eax
 a93:	83 e8 08             	sub    $0x8,%eax
 a96:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a99:	a1 28 10 00 00       	mov    0x1028,%eax
 a9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 aa1:	eb 24                	jmp    ac7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa6:	8b 00                	mov    (%eax),%eax
 aa8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aab:	77 12                	ja     abf <free+0x35>
 aad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ab3:	77 24                	ja     ad9 <free+0x4f>
 ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab8:	8b 00                	mov    (%eax),%eax
 aba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 abd:	77 1a                	ja     ad9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac2:	8b 00                	mov    (%eax),%eax
 ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ac7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 acd:	76 d4                	jbe    aa3 <free+0x19>
 acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad2:	8b 00                	mov    (%eax),%eax
 ad4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ad7:	76 ca                	jbe    aa3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 ad9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 adc:	8b 40 04             	mov    0x4(%eax),%eax
 adf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ae6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae9:	01 c2                	add    %eax,%edx
 aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aee:	8b 00                	mov    (%eax),%eax
 af0:	39 c2                	cmp    %eax,%edx
 af2:	75 24                	jne    b18 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 af4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af7:	8b 50 04             	mov    0x4(%eax),%edx
 afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afd:	8b 00                	mov    (%eax),%eax
 aff:	8b 40 04             	mov    0x4(%eax),%eax
 b02:	01 c2                	add    %eax,%edx
 b04:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b07:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b0d:	8b 00                	mov    (%eax),%eax
 b0f:	8b 10                	mov    (%eax),%edx
 b11:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b14:	89 10                	mov    %edx,(%eax)
 b16:	eb 0a                	jmp    b22 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1b:	8b 10                	mov    (%eax),%edx
 b1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b20:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b25:	8b 40 04             	mov    0x4(%eax),%eax
 b28:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b32:	01 d0                	add    %edx,%eax
 b34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b37:	75 20                	jne    b59 <free+0xcf>
    p->s.size += bp->s.size;
 b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b3c:	8b 50 04             	mov    0x4(%eax),%edx
 b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b42:	8b 40 04             	mov    0x4(%eax),%eax
 b45:	01 c2                	add    %eax,%edx
 b47:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b50:	8b 10                	mov    (%eax),%edx
 b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b55:	89 10                	mov    %edx,(%eax)
 b57:	eb 08                	jmp    b61 <free+0xd7>
  } else
    p->s.ptr = bp;
 b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b5f:	89 10                	mov    %edx,(%eax)
  freep = p;
 b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b64:	a3 28 10 00 00       	mov    %eax,0x1028
}
 b69:	c9                   	leave  
 b6a:	c3                   	ret    

00000b6b <morecore>:

static Header*
morecore(uint nu)
{
 b6b:	55                   	push   %ebp
 b6c:	89 e5                	mov    %esp,%ebp
 b6e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b71:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b78:	77 07                	ja     b81 <morecore+0x16>
    nu = 4096;
 b7a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b81:	8b 45 08             	mov    0x8(%ebp),%eax
 b84:	c1 e0 03             	shl    $0x3,%eax
 b87:	89 04 24             	mov    %eax,(%esp)
 b8a:	e8 38 fc ff ff       	call   7c7 <sbrk>
 b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b92:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b96:	75 07                	jne    b9f <morecore+0x34>
    return 0;
 b98:	b8 00 00 00 00       	mov    $0x0,%eax
 b9d:	eb 22                	jmp    bc1 <morecore+0x56>
  hp = (Header*)p;
 b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba8:	8b 55 08             	mov    0x8(%ebp),%edx
 bab:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb1:	83 c0 08             	add    $0x8,%eax
 bb4:	89 04 24             	mov    %eax,(%esp)
 bb7:	e8 ce fe ff ff       	call   a8a <free>
  return freep;
 bbc:	a1 28 10 00 00       	mov    0x1028,%eax
}
 bc1:	c9                   	leave  
 bc2:	c3                   	ret    

00000bc3 <malloc>:

void*
malloc(uint nbytes)
{
 bc3:	55                   	push   %ebp
 bc4:	89 e5                	mov    %esp,%ebp
 bc6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bc9:	8b 45 08             	mov    0x8(%ebp),%eax
 bcc:	83 c0 07             	add    $0x7,%eax
 bcf:	c1 e8 03             	shr    $0x3,%eax
 bd2:	83 c0 01             	add    $0x1,%eax
 bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bd8:	a1 28 10 00 00       	mov    0x1028,%eax
 bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 be0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 be4:	75 23                	jne    c09 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 be6:	c7 45 f0 20 10 00 00 	movl   $0x1020,-0x10(%ebp)
 bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf0:	a3 28 10 00 00       	mov    %eax,0x1028
 bf5:	a1 28 10 00 00       	mov    0x1028,%eax
 bfa:	a3 20 10 00 00       	mov    %eax,0x1020
    base.s.size = 0;
 bff:	c7 05 24 10 00 00 00 	movl   $0x0,0x1024
 c06:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c0c:	8b 00                	mov    (%eax),%eax
 c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c14:	8b 40 04             	mov    0x4(%eax),%eax
 c17:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c1a:	72 4d                	jb     c69 <malloc+0xa6>
      if(p->s.size == nunits)
 c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1f:	8b 40 04             	mov    0x4(%eax),%eax
 c22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c25:	75 0c                	jne    c33 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2a:	8b 10                	mov    (%eax),%edx
 c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c2f:	89 10                	mov    %edx,(%eax)
 c31:	eb 26                	jmp    c59 <malloc+0x96>
      else {
        p->s.size -= nunits;
 c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c36:	8b 40 04             	mov    0x4(%eax),%eax
 c39:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c3c:	89 c2                	mov    %eax,%edx
 c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c41:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c47:	8b 40 04             	mov    0x4(%eax),%eax
 c4a:	c1 e0 03             	shl    $0x3,%eax
 c4d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c53:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c56:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c5c:	a3 28 10 00 00       	mov    %eax,0x1028
      return (void*)(p + 1);
 c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c64:	83 c0 08             	add    $0x8,%eax
 c67:	eb 38                	jmp    ca1 <malloc+0xde>
    }
    if(p == freep)
 c69:	a1 28 10 00 00       	mov    0x1028,%eax
 c6e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c71:	75 1b                	jne    c8e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c76:	89 04 24             	mov    %eax,(%esp)
 c79:	e8 ed fe ff ff       	call   b6b <morecore>
 c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c85:	75 07                	jne    c8e <malloc+0xcb>
        return 0;
 c87:	b8 00 00 00 00       	mov    $0x0,%eax
 c8c:	eb 13                	jmp    ca1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c97:	8b 00                	mov    (%eax),%eax
 c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c9c:	e9 70 ff ff ff       	jmp    c11 <malloc+0x4e>
}
 ca1:	c9                   	leave  
 ca2:	c3                   	ret    
