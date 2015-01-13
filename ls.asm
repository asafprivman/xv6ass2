
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 40 04 00 00       	call   452 <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 04                	jmp    20 <fmtname+0x20>
  1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 0a                	jb     32 <fmtname+0x32>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	0f b6 00             	movzbl (%eax),%eax
  2e:	3c 2f                	cmp    $0x2f,%al
  30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
  32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 11 04 00 00       	call   452 <strlen>
  41:	83 f8 0d             	cmp    $0xd,%eax
  44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
  4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 fc 03 00 00       	call   452 <strlen>
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  61:	c7 04 24 0c 10 00 00 	movl   $0x100c,(%esp)
  68:	e8 74 05 00 00       	call   5e1 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 da 03 00 00       	call   452 <strlen>
  78:	ba 0e 00 00 00       	mov    $0xe,%edx
  7d:	89 d3                	mov    %edx,%ebx
  7f:	29 c3                	sub    %eax,%ebx
  81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 c6 03 00 00       	call   452 <strlen>
  8c:	05 0c 10 00 00       	add    $0x100c,%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9c:	00 
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 d4 03 00 00       	call   479 <memset>
  return buf;
  a5:	b8 0c 10 00 00       	mov    $0x100c,%eax
}
  aa:	83 c4 24             	add    $0x24,%esp
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c3:	00 
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 04 24             	mov    %eax,(%esp)
  ca:	e8 b6 06 00 00       	call   785 <open>
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 44 24 08          	mov    %eax,0x8(%esp)
  df:	c7 44 24 04 a9 0c 00 	movl   $0xca9,0x4(%esp)
  e6:	00 
  e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ee:	e8 ea 07 00 00       	call   8dd <printf>
    return;
  f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 90 06 00 00       	call   79d <fstat>
 10d:	85 c0                	test   %eax,%eax
 10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 44 24 08          	mov    %eax,0x8(%esp)
 118:	c7 44 24 04 bd 0c 00 	movl   $0xcbd,0x4(%esp)
 11f:	00 
 120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 127:	e8 b1 07 00 00       	call   8dd <printf>
    close(fd);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 36 06 00 00       	call   76d <close>
    return;
 137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
  }
  
  switch(st.type){
 13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 143:	98                   	cwtl   
 144:	83 f8 01             	cmp    $0x1,%eax
 147:	74 53                	je     19c <ls+0xec>
 149:	83 f8 02             	cmp    $0x2,%eax
 14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 165:	0f bf d8             	movswl %ax,%ebx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 8d fe ff ff       	call   0 <fmtname>
 173:	89 7c 24 14          	mov    %edi,0x14(%esp)
 177:	89 74 24 10          	mov    %esi,0x10(%esp)
 17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17f:	89 44 24 08          	mov    %eax,0x8(%esp)
 183:	c7 44 24 04 d1 0c 00 	movl   $0xcd1,0x4(%esp)
 18a:	00 
 18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 192:	e8 46 07 00 00       	call   8dd <printf>
    break;
 197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 ab 02 00 00       	call   452 <strlen>
 1a7:	83 c0 10             	add    $0x10,%eax
 1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
 1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
 1b1:	c7 44 24 04 de 0c 00 	movl   $0xcde,0x4(%esp)
 1b8:	00 
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 18 07 00 00       	call   8dd <printf>
      break;
 1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 04 02 00 00       	call   3e3 <strcpy>
    p = buf+strlen(buf);
 1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 65 02 00 00       	call   452 <strlen>
 1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f3:	01 d0                	add    %edx,%eax
 1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
 201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 204:	e9 be 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
 209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 210:	66 85 c0             	test   %ax,%ax
 213:	75 05                	jne    21a <ls+0x16a>
        continue;
 215:	e9 ad 00 00 00       	jmp    2c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
 21a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 221:	00 
 222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 228:	83 c0 02             	add    $0x2,%eax
 22b:	89 44 24 04          	mov    %eax,0x4(%esp)
 22f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 a7 03 00 00       	call   5e1 <memmove>
      p[DIRSIZ] = 0;
 23a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23d:	83 c0 0e             	add    $0xe,%eax
 240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 253:	89 04 24             	mov    %eax,(%esp)
 256:	e8 eb 02 00 00       	call   546 <stat>
 25b:	85 c0                	test   %eax,%eax
 25d:	79 20                	jns    27f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
 25f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 265:	89 44 24 08          	mov    %eax,0x8(%esp)
 269:	c7 44 24 04 bd 0c 00 	movl   $0xcbd,0x4(%esp)
 270:	00 
 271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 278:	e8 60 06 00 00       	call   8dd <printf>
        continue;
 27d:	eb 48                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 28b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 292:	0f bf d8             	movswl %ax,%ebx
 295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 29b:	89 04 24             	mov    %eax,(%esp)
 29e:	e8 5d fd ff ff       	call   0 <fmtname>
 2a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a7:	89 74 24 10          	mov    %esi,0x10(%esp)
 2ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	c7 44 24 04 d1 0c 00 	movl   $0xcd1,0x4(%esp)
 2ba:	00 
 2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c2:	e8 16 06 00 00       	call   8dd <printf>
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2ce:	00 
 2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 79 04 00 00       	call   75d <read>
 2e4:	83 f8 10             	cmp    $0x10,%eax
 2e7:	0f 84 1c ff ff ff    	je     209 <ls+0x159>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2ed:	90                   	nop
  }
  close(fd);
 2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f1:	89 04 24             	mov    %eax,(%esp)
 2f4:	e8 74 04 00 00       	call   76d <close>
}
 2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 e4 f0             	and    $0xfffffff0,%esp
 30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 311:	7f 11                	jg     324 <main+0x20>
    ls(".");
 313:	c7 04 24 f1 0c 00 00 	movl   $0xcf1,(%esp)
 31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit();
 31f:	e8 21 04 00 00       	call   745 <exit>
  }
  for(i=1; i<argc; i++)
 324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 32b:	00 
 32c:	eb 1f                	jmp    34d <main+0x49>
    ls(argv[i]);
 32e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	01 d0                	add    %edx,%eax
 33e:	8b 00                	mov    (%eax),%eax
 340:	89 04 24             	mov    %eax,(%esp)
 343:	e8 68 fd ff ff       	call   b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 34d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 351:	3b 45 08             	cmp    0x8(%ebp),%eax
 354:	7c d8                	jl     32e <main+0x2a>
    ls(argv[i]);
  exit();
 356:	e8 ea 03 00 00       	call   745 <exit>

0000035b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	57                   	push   %edi
 35f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 360:	8b 4d 08             	mov    0x8(%ebp),%ecx
 363:	8b 55 10             	mov    0x10(%ebp),%edx
 366:	8b 45 0c             	mov    0xc(%ebp),%eax
 369:	89 cb                	mov    %ecx,%ebx
 36b:	89 df                	mov    %ebx,%edi
 36d:	89 d1                	mov    %edx,%ecx
 36f:	fc                   	cld    
 370:	f3 aa                	rep stos %al,%es:(%edi)
 372:	89 ca                	mov    %ecx,%edx
 374:	89 fb                	mov    %edi,%ebx
 376:	89 5d 08             	mov    %ebx,0x8(%ebp)
 379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37c:	5b                   	pop    %ebx
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 386:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	89 04 24             	mov    %eax,(%esp)
 393:	e8 ba 00 00 00       	call   452 <strlen>
 398:	83 e8 01             	sub    $0x1,%eax
 39b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 39e:	eb 39                	jmp    3d9 <reverse+0x59>
         c = s[i];
 3a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	01 d0                	add    %edx,%eax
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
 3ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	01 c2                	add    %eax,%edx
 3b6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	01 c8                	add    %ecx,%eax
 3be:	0f b6 00             	movzbl (%eax),%eax
 3c1:	88 02                	mov    %al,(%edx)
         s[j] = c;
 3c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
 3c9:	01 c2                	add    %eax,%edx
 3cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3cf:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 3d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 3d5:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 3d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 3df:	7c bf                	jl     3a0 <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 3e1:	c9                   	leave  
 3e2:	c3                   	ret    

000003e3 <strcpy>:

char*
strcpy(char *s, char *t)
{
 3e3:	55                   	push   %ebp
 3e4:	89 e5                	mov    %esp,%ebp
 3e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3ef:	90                   	nop
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	8d 50 01             	lea    0x1(%eax),%edx
 3f6:	89 55 08             	mov    %edx,0x8(%ebp)
 3f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 3fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 3ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 402:	0f b6 12             	movzbl (%edx),%edx
 405:	88 10                	mov    %dl,(%eax)
 407:	0f b6 00             	movzbl (%eax),%eax
 40a:	84 c0                	test   %al,%al
 40c:	75 e2                	jne    3f0 <strcpy+0xd>
    ;
  return os;
 40e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 416:	eb 08                	jmp    420 <strcmp+0xd>
    p++, q++;
 418:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 41c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	0f b6 00             	movzbl (%eax),%eax
 426:	84 c0                	test   %al,%al
 428:	74 10                	je     43a <strcmp+0x27>
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 10             	movzbl (%eax),%edx
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	0f b6 00             	movzbl (%eax),%eax
 436:	38 c2                	cmp    %al,%dl
 438:	74 de                	je     418 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	0f b6 00             	movzbl (%eax),%eax
 440:	0f b6 d0             	movzbl %al,%edx
 443:	8b 45 0c             	mov    0xc(%ebp),%eax
 446:	0f b6 00             	movzbl (%eax),%eax
 449:	0f b6 c0             	movzbl %al,%eax
 44c:	29 c2                	sub    %eax,%edx
 44e:	89 d0                	mov    %edx,%eax
}
 450:	5d                   	pop    %ebp
 451:	c3                   	ret    

00000452 <strlen>:

uint
strlen(char *s)
{
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 45f:	eb 04                	jmp    465 <strlen+0x13>
 461:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 465:	8b 55 fc             	mov    -0x4(%ebp),%edx
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	01 d0                	add    %edx,%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	84 c0                	test   %al,%al
 472:	75 ed                	jne    461 <strlen+0xf>
    ;
  return n;
 474:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 477:	c9                   	leave  
 478:	c3                   	ret    

00000479 <memset>:

void*
memset(void *dst, int c, uint n)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 47f:	8b 45 10             	mov    0x10(%ebp),%eax
 482:	89 44 24 08          	mov    %eax,0x8(%esp)
 486:	8b 45 0c             	mov    0xc(%ebp),%eax
 489:	89 44 24 04          	mov    %eax,0x4(%esp)
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	89 04 24             	mov    %eax,(%esp)
 493:	e8 c3 fe ff ff       	call   35b <stosb>
  return dst;
 498:	8b 45 08             	mov    0x8(%ebp),%eax
}
 49b:	c9                   	leave  
 49c:	c3                   	ret    

0000049d <strchr>:

char*
strchr(const char *s, char c)
{
 49d:	55                   	push   %ebp
 49e:	89 e5                	mov    %esp,%ebp
 4a0:	83 ec 04             	sub    $0x4,%esp
 4a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4a9:	eb 14                	jmp    4bf <strchr+0x22>
    if(*s == c)
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	0f b6 00             	movzbl (%eax),%eax
 4b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4b4:	75 05                	jne    4bb <strchr+0x1e>
      return (char*)s;
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	eb 13                	jmp    4ce <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	0f b6 00             	movzbl (%eax),%eax
 4c5:	84 c0                	test   %al,%al
 4c7:	75 e2                	jne    4ab <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 4c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4ce:	c9                   	leave  
 4cf:	c3                   	ret    

000004d0 <gets>:

char*
gets(char *buf, int max)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4dd:	eb 4c                	jmp    52b <gets+0x5b>
    cc = read(0, &c, 1);
 4df:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e6:	00 
 4e7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4f5:	e8 63 02 00 00       	call   75d <read>
 4fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 501:	7f 02                	jg     505 <gets+0x35>
      break;
 503:	eb 31                	jmp    536 <gets+0x66>
    buf[i++] = c;
 505:	8b 45 f4             	mov    -0xc(%ebp),%eax
 508:	8d 50 01             	lea    0x1(%eax),%edx
 50b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 50e:	89 c2                	mov    %eax,%edx
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	01 c2                	add    %eax,%edx
 515:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 519:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 51b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 51f:	3c 0a                	cmp    $0xa,%al
 521:	74 13                	je     536 <gets+0x66>
 523:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 527:	3c 0d                	cmp    $0xd,%al
 529:	74 0b                	je     536 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 52b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52e:	83 c0 01             	add    $0x1,%eax
 531:	3b 45 0c             	cmp    0xc(%ebp),%eax
 534:	7c a9                	jl     4df <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 536:	8b 55 f4             	mov    -0xc(%ebp),%edx
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	01 d0                	add    %edx,%eax
 53e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 541:	8b 45 08             	mov    0x8(%ebp),%eax
}
 544:	c9                   	leave  
 545:	c3                   	ret    

00000546 <stat>:

int
stat(char *n, struct stat *st)
{
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 54c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 553:	00 
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	89 04 24             	mov    %eax,(%esp)
 55a:	e8 26 02 00 00       	call   785 <open>
 55f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 566:	79 07                	jns    56f <stat+0x29>
    return -1;
 568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 56d:	eb 23                	jmp    592 <stat+0x4c>
  r = fstat(fd, st);
 56f:	8b 45 0c             	mov    0xc(%ebp),%eax
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	8b 45 f4             	mov    -0xc(%ebp),%eax
 579:	89 04 24             	mov    %eax,(%esp)
 57c:	e8 1c 02 00 00       	call   79d <fstat>
 581:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 584:	8b 45 f4             	mov    -0xc(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 de 01 00 00       	call   76d <close>
  return r;
 58f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 592:	c9                   	leave  
 593:	c3                   	ret    

00000594 <atoi>:

int
atoi(const char *s)
{
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 59a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5a1:	eb 25                	jmp    5c8 <atoi+0x34>
    n = n*10 + *s++ - '0';
 5a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5a6:	89 d0                	mov    %edx,%eax
 5a8:	c1 e0 02             	shl    $0x2,%eax
 5ab:	01 d0                	add    %edx,%eax
 5ad:	01 c0                	add    %eax,%eax
 5af:	89 c1                	mov    %eax,%ecx
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	8d 50 01             	lea    0x1(%eax),%edx
 5b7:	89 55 08             	mov    %edx,0x8(%ebp)
 5ba:	0f b6 00             	movzbl (%eax),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	01 c8                	add    %ecx,%eax
 5c2:	83 e8 30             	sub    $0x30,%eax
 5c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	3c 2f                	cmp    $0x2f,%al
 5d0:	7e 0a                	jle    5dc <atoi+0x48>
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	0f b6 00             	movzbl (%eax),%eax
 5d8:	3c 39                	cmp    $0x39,%al
 5da:	7e c7                	jle    5a3 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 5dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5df:	c9                   	leave  
 5e0:	c3                   	ret    

000005e1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5e1:	55                   	push   %ebp
 5e2:	89 e5                	mov    %esp,%ebp
 5e4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5f3:	eb 17                	jmp    60c <memmove+0x2b>
    *dst++ = *src++;
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	8d 50 01             	lea    0x1(%eax),%edx
 5fb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 601:	8d 4a 01             	lea    0x1(%edx),%ecx
 604:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 607:	0f b6 12             	movzbl (%edx),%edx
 60a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 60c:	8b 45 10             	mov    0x10(%ebp),%eax
 60f:	8d 50 ff             	lea    -0x1(%eax),%edx
 612:	89 55 10             	mov    %edx,0x10(%ebp)
 615:	85 c0                	test   %eax,%eax
 617:	7f dc                	jg     5f5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 619:	8b 45 08             	mov    0x8(%ebp),%eax
}
 61c:	c9                   	leave  
 61d:	c3                   	ret    

0000061e <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 61e:	55                   	push   %ebp
 61f:	89 e5                	mov    %esp,%ebp
 621:	53                   	push   %ebx
 622:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 625:	8b 45 08             	mov    0x8(%ebp),%eax
 628:	89 45 f0             	mov    %eax,-0x10(%ebp)
 62b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 62f:	79 03                	jns    634 <itoa+0x16>
         n = -n;          /* make n positive */
 631:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 634:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 63b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63e:	8d 50 01             	lea    0x1(%eax),%edx
 641:	89 55 f4             	mov    %edx,-0xc(%ebp)
 644:	89 c2                	mov    %eax,%edx
 646:	8b 45 0c             	mov    0xc(%ebp),%eax
 649:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 64c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 64f:	ba 67 66 66 66       	mov    $0x66666667,%edx
 654:	89 c8                	mov    %ecx,%eax
 656:	f7 ea                	imul   %edx
 658:	c1 fa 02             	sar    $0x2,%edx
 65b:	89 c8                	mov    %ecx,%eax
 65d:	c1 f8 1f             	sar    $0x1f,%eax
 660:	29 c2                	sub    %eax,%edx
 662:	89 d0                	mov    %edx,%eax
 664:	c1 e0 02             	shl    $0x2,%eax
 667:	01 d0                	add    %edx,%eax
 669:	01 c0                	add    %eax,%eax
 66b:	29 c1                	sub    %eax,%ecx
 66d:	89 ca                	mov    %ecx,%edx
 66f:	89 d0                	mov    %edx,%eax
 671:	83 c0 30             	add    $0x30,%eax
 674:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 676:	8b 4d 08             	mov    0x8(%ebp),%ecx
 679:	ba 67 66 66 66       	mov    $0x66666667,%edx
 67e:	89 c8                	mov    %ecx,%eax
 680:	f7 ea                	imul   %edx
 682:	c1 fa 02             	sar    $0x2,%edx
 685:	89 c8                	mov    %ecx,%eax
 687:	c1 f8 1f             	sar    $0x1f,%eax
 68a:	29 c2                	sub    %eax,%edx
 68c:	89 d0                	mov    %edx,%eax
 68e:	89 45 08             	mov    %eax,0x8(%ebp)
 691:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 695:	7f a4                	jg     63b <itoa+0x1d>
     if (sign < 0)
 697:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 69b:	79 13                	jns    6b0 <itoa+0x92>
         s[i++] = '-';
 69d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a0:	8d 50 01             	lea    0x1(%eax),%edx
 6a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a6:	89 c2                	mov    %eax,%edx
 6a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ab:	01 d0                	add    %edx,%eax
 6ad:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 6b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b6:	01 d0                	add    %edx,%eax
 6b8:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 6bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6be:	89 04 24             	mov    %eax,(%esp)
 6c1:	e8 ba fc ff ff       	call   380 <reverse>
 }
 6c6:	83 c4 24             	add    $0x24,%esp
 6c9:	5b                   	pop    %ebx
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    

000006cc <strcat>:

char *
strcat(char *dest, const char *src)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 6d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6d9:	eb 04                	jmp    6df <strcat+0x13>
 6db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6df:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	01 d0                	add    %edx,%eax
 6e7:	0f b6 00             	movzbl (%eax),%eax
 6ea:	84 c0                	test   %al,%al
 6ec:	75 ed                	jne    6db <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 6ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 6f5:	eb 20                	jmp    717 <strcat+0x4b>
        dest[i+j] = src[j];
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6fd:	01 d0                	add    %edx,%eax
 6ff:	89 c2                	mov    %eax,%edx
 701:	8b 45 08             	mov    0x8(%ebp),%eax
 704:	01 c2                	add    %eax,%edx
 706:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 709:	8b 45 0c             	mov    0xc(%ebp),%eax
 70c:	01 c8                	add    %ecx,%eax
 70e:	0f b6 00             	movzbl (%eax),%eax
 711:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 713:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 717:	8b 55 f8             	mov    -0x8(%ebp),%edx
 71a:	8b 45 0c             	mov    0xc(%ebp),%eax
 71d:	01 d0                	add    %edx,%eax
 71f:	0f b6 00             	movzbl (%eax),%eax
 722:	84 c0                	test   %al,%al
 724:	75 d1                	jne    6f7 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	8b 55 fc             	mov    -0x4(%ebp),%edx
 72c:	01 d0                	add    %edx,%eax
 72e:	89 c2                	mov    %eax,%edx
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	01 d0                	add    %edx,%eax
 735:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 738:	8b 45 08             	mov    0x8(%ebp),%eax
}
 73b:	c9                   	leave  
 73c:	c3                   	ret    

0000073d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 73d:	b8 01 00 00 00       	mov    $0x1,%eax
 742:	cd 40                	int    $0x40
 744:	c3                   	ret    

00000745 <exit>:
SYSCALL(exit)
 745:	b8 02 00 00 00       	mov    $0x2,%eax
 74a:	cd 40                	int    $0x40
 74c:	c3                   	ret    

0000074d <wait>:
SYSCALL(wait)
 74d:	b8 03 00 00 00       	mov    $0x3,%eax
 752:	cd 40                	int    $0x40
 754:	c3                   	ret    

00000755 <pipe>:
SYSCALL(pipe)
 755:	b8 04 00 00 00       	mov    $0x4,%eax
 75a:	cd 40                	int    $0x40
 75c:	c3                   	ret    

0000075d <read>:
SYSCALL(read)
 75d:	b8 05 00 00 00       	mov    $0x5,%eax
 762:	cd 40                	int    $0x40
 764:	c3                   	ret    

00000765 <write>:
SYSCALL(write)
 765:	b8 10 00 00 00       	mov    $0x10,%eax
 76a:	cd 40                	int    $0x40
 76c:	c3                   	ret    

0000076d <close>:
SYSCALL(close)
 76d:	b8 15 00 00 00       	mov    $0x15,%eax
 772:	cd 40                	int    $0x40
 774:	c3                   	ret    

00000775 <kill>:
SYSCALL(kill)
 775:	b8 06 00 00 00       	mov    $0x6,%eax
 77a:	cd 40                	int    $0x40
 77c:	c3                   	ret    

0000077d <exec>:
SYSCALL(exec)
 77d:	b8 07 00 00 00       	mov    $0x7,%eax
 782:	cd 40                	int    $0x40
 784:	c3                   	ret    

00000785 <open>:
SYSCALL(open)
 785:	b8 0f 00 00 00       	mov    $0xf,%eax
 78a:	cd 40                	int    $0x40
 78c:	c3                   	ret    

0000078d <mknod>:
SYSCALL(mknod)
 78d:	b8 11 00 00 00       	mov    $0x11,%eax
 792:	cd 40                	int    $0x40
 794:	c3                   	ret    

00000795 <unlink>:
SYSCALL(unlink)
 795:	b8 12 00 00 00       	mov    $0x12,%eax
 79a:	cd 40                	int    $0x40
 79c:	c3                   	ret    

0000079d <fstat>:
SYSCALL(fstat)
 79d:	b8 08 00 00 00       	mov    $0x8,%eax
 7a2:	cd 40                	int    $0x40
 7a4:	c3                   	ret    

000007a5 <link>:
SYSCALL(link)
 7a5:	b8 13 00 00 00       	mov    $0x13,%eax
 7aa:	cd 40                	int    $0x40
 7ac:	c3                   	ret    

000007ad <mkdir>:
SYSCALL(mkdir)
 7ad:	b8 14 00 00 00       	mov    $0x14,%eax
 7b2:	cd 40                	int    $0x40
 7b4:	c3                   	ret    

000007b5 <chdir>:
SYSCALL(chdir)
 7b5:	b8 09 00 00 00       	mov    $0x9,%eax
 7ba:	cd 40                	int    $0x40
 7bc:	c3                   	ret    

000007bd <dup>:
SYSCALL(dup)
 7bd:	b8 0a 00 00 00       	mov    $0xa,%eax
 7c2:	cd 40                	int    $0x40
 7c4:	c3                   	ret    

000007c5 <getpid>:
SYSCALL(getpid)
 7c5:	b8 0b 00 00 00       	mov    $0xb,%eax
 7ca:	cd 40                	int    $0x40
 7cc:	c3                   	ret    

000007cd <sbrk>:
SYSCALL(sbrk)
 7cd:	b8 0c 00 00 00       	mov    $0xc,%eax
 7d2:	cd 40                	int    $0x40
 7d4:	c3                   	ret    

000007d5 <sleep>:
SYSCALL(sleep)
 7d5:	b8 0d 00 00 00       	mov    $0xd,%eax
 7da:	cd 40                	int    $0x40
 7dc:	c3                   	ret    

000007dd <uptime>:
SYSCALL(uptime)
 7dd:	b8 0e 00 00 00       	mov    $0xe,%eax
 7e2:	cd 40                	int    $0x40
 7e4:	c3                   	ret    

000007e5 <wait2>:
SYSCALL(wait2)
 7e5:	b8 16 00 00 00       	mov    $0x16,%eax
 7ea:	cd 40                	int    $0x40
 7ec:	c3                   	ret    

000007ed <set_priority>:
SYSCALL(set_priority)
 7ed:	b8 17 00 00 00       	mov    $0x17,%eax
 7f2:	cd 40                	int    $0x40
 7f4:	c3                   	ret    

000007f5 <get_sched_record>:
SYSCALL(get_sched_record)
 7f5:	b8 18 00 00 00       	mov    $0x18,%eax
 7fa:	cd 40                	int    $0x40
 7fc:	c3                   	ret    

000007fd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7fd:	55                   	push   %ebp
 7fe:	89 e5                	mov    %esp,%ebp
 800:	83 ec 18             	sub    $0x18,%esp
 803:	8b 45 0c             	mov    0xc(%ebp),%eax
 806:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 809:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 810:	00 
 811:	8d 45 f4             	lea    -0xc(%ebp),%eax
 814:	89 44 24 04          	mov    %eax,0x4(%esp)
 818:	8b 45 08             	mov    0x8(%ebp),%eax
 81b:	89 04 24             	mov    %eax,(%esp)
 81e:	e8 42 ff ff ff       	call   765 <write>
}
 823:	c9                   	leave  
 824:	c3                   	ret    

00000825 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 825:	55                   	push   %ebp
 826:	89 e5                	mov    %esp,%ebp
 828:	56                   	push   %esi
 829:	53                   	push   %ebx
 82a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 82d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 834:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 838:	74 17                	je     851 <printint+0x2c>
 83a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 83e:	79 11                	jns    851 <printint+0x2c>
    neg = 1;
 840:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 847:	8b 45 0c             	mov    0xc(%ebp),%eax
 84a:	f7 d8                	neg    %eax
 84c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 84f:	eb 06                	jmp    857 <printint+0x32>
  } else {
    x = xx;
 851:	8b 45 0c             	mov    0xc(%ebp),%eax
 854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 85e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 861:	8d 41 01             	lea    0x1(%ecx),%eax
 864:	89 45 f4             	mov    %eax,-0xc(%ebp)
 867:	8b 5d 10             	mov    0x10(%ebp),%ebx
 86a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86d:	ba 00 00 00 00       	mov    $0x0,%edx
 872:	f7 f3                	div    %ebx
 874:	89 d0                	mov    %edx,%eax
 876:	0f b6 80 f8 0f 00 00 	movzbl 0xff8(%eax),%eax
 87d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 881:	8b 75 10             	mov    0x10(%ebp),%esi
 884:	8b 45 ec             	mov    -0x14(%ebp),%eax
 887:	ba 00 00 00 00       	mov    $0x0,%edx
 88c:	f7 f6                	div    %esi
 88e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 891:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 895:	75 c7                	jne    85e <printint+0x39>
  if(neg)
 897:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 89b:	74 10                	je     8ad <printint+0x88>
    buf[i++] = '-';
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	8d 50 01             	lea    0x1(%eax),%edx
 8a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8a6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8ab:	eb 1f                	jmp    8cc <printint+0xa7>
 8ad:	eb 1d                	jmp    8cc <printint+0xa7>
    putc(fd, buf[i]);
 8af:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	01 d0                	add    %edx,%eax
 8b7:	0f b6 00             	movzbl (%eax),%eax
 8ba:	0f be c0             	movsbl %al,%eax
 8bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c1:	8b 45 08             	mov    0x8(%ebp),%eax
 8c4:	89 04 24             	mov    %eax,(%esp)
 8c7:	e8 31 ff ff ff       	call   7fd <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 8cc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 8d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d4:	79 d9                	jns    8af <printint+0x8a>
    putc(fd, buf[i]);
}
 8d6:	83 c4 30             	add    $0x30,%esp
 8d9:	5b                   	pop    %ebx
 8da:	5e                   	pop    %esi
 8db:	5d                   	pop    %ebp
 8dc:	c3                   	ret    

000008dd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8dd:	55                   	push   %ebp
 8de:	89 e5                	mov    %esp,%ebp
 8e0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8ea:	8d 45 0c             	lea    0xc(%ebp),%eax
 8ed:	83 c0 04             	add    $0x4,%eax
 8f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8fa:	e9 7c 01 00 00       	jmp    a7b <printf+0x19e>
    c = fmt[i] & 0xff;
 8ff:	8b 55 0c             	mov    0xc(%ebp),%edx
 902:	8b 45 f0             	mov    -0x10(%ebp),%eax
 905:	01 d0                	add    %edx,%eax
 907:	0f b6 00             	movzbl (%eax),%eax
 90a:	0f be c0             	movsbl %al,%eax
 90d:	25 ff 00 00 00       	and    $0xff,%eax
 912:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 915:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 919:	75 2c                	jne    947 <printf+0x6a>
      if(c == '%'){
 91b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 91f:	75 0c                	jne    92d <printf+0x50>
        state = '%';
 921:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 928:	e9 4a 01 00 00       	jmp    a77 <printf+0x19a>
      } else {
        putc(fd, c);
 92d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 930:	0f be c0             	movsbl %al,%eax
 933:	89 44 24 04          	mov    %eax,0x4(%esp)
 937:	8b 45 08             	mov    0x8(%ebp),%eax
 93a:	89 04 24             	mov    %eax,(%esp)
 93d:	e8 bb fe ff ff       	call   7fd <putc>
 942:	e9 30 01 00 00       	jmp    a77 <printf+0x19a>
      }
    } else if(state == '%'){
 947:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 94b:	0f 85 26 01 00 00    	jne    a77 <printf+0x19a>
      if(c == 'd'){
 951:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 955:	75 2d                	jne    984 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 957:	8b 45 e8             	mov    -0x18(%ebp),%eax
 95a:	8b 00                	mov    (%eax),%eax
 95c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 963:	00 
 964:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 96b:	00 
 96c:	89 44 24 04          	mov    %eax,0x4(%esp)
 970:	8b 45 08             	mov    0x8(%ebp),%eax
 973:	89 04 24             	mov    %eax,(%esp)
 976:	e8 aa fe ff ff       	call   825 <printint>
        ap++;
 97b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 97f:	e9 ec 00 00 00       	jmp    a70 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 984:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 988:	74 06                	je     990 <printf+0xb3>
 98a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 98e:	75 2d                	jne    9bd <printf+0xe0>
        printint(fd, *ap, 16, 0);
 990:	8b 45 e8             	mov    -0x18(%ebp),%eax
 993:	8b 00                	mov    (%eax),%eax
 995:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 99c:	00 
 99d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 9a4:	00 
 9a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a9:	8b 45 08             	mov    0x8(%ebp),%eax
 9ac:	89 04 24             	mov    %eax,(%esp)
 9af:	e8 71 fe ff ff       	call   825 <printint>
        ap++;
 9b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9b8:	e9 b3 00 00 00       	jmp    a70 <printf+0x193>
      } else if(c == 's'){
 9bd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9c1:	75 45                	jne    a08 <printf+0x12b>
        s = (char*)*ap;
 9c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9c6:	8b 00                	mov    (%eax),%eax
 9c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9d3:	75 09                	jne    9de <printf+0x101>
          s = "(null)";
 9d5:	c7 45 f4 f3 0c 00 00 	movl   $0xcf3,-0xc(%ebp)
        while(*s != 0){
 9dc:	eb 1e                	jmp    9fc <printf+0x11f>
 9de:	eb 1c                	jmp    9fc <printf+0x11f>
          putc(fd, *s);
 9e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e3:	0f b6 00             	movzbl (%eax),%eax
 9e6:	0f be c0             	movsbl %al,%eax
 9e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ed:	8b 45 08             	mov    0x8(%ebp),%eax
 9f0:	89 04 24             	mov    %eax,(%esp)
 9f3:	e8 05 fe ff ff       	call   7fd <putc>
          s++;
 9f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ff:	0f b6 00             	movzbl (%eax),%eax
 a02:	84 c0                	test   %al,%al
 a04:	75 da                	jne    9e0 <printf+0x103>
 a06:	eb 68                	jmp    a70 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a08:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a0c:	75 1d                	jne    a2b <printf+0x14e>
        putc(fd, *ap);
 a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a11:	8b 00                	mov    (%eax),%eax
 a13:	0f be c0             	movsbl %al,%eax
 a16:	89 44 24 04          	mov    %eax,0x4(%esp)
 a1a:	8b 45 08             	mov    0x8(%ebp),%eax
 a1d:	89 04 24             	mov    %eax,(%esp)
 a20:	e8 d8 fd ff ff       	call   7fd <putc>
        ap++;
 a25:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a29:	eb 45                	jmp    a70 <printf+0x193>
      } else if(c == '%'){
 a2b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a2f:	75 17                	jne    a48 <printf+0x16b>
        putc(fd, c);
 a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a34:	0f be c0             	movsbl %al,%eax
 a37:	89 44 24 04          	mov    %eax,0x4(%esp)
 a3b:	8b 45 08             	mov    0x8(%ebp),%eax
 a3e:	89 04 24             	mov    %eax,(%esp)
 a41:	e8 b7 fd ff ff       	call   7fd <putc>
 a46:	eb 28                	jmp    a70 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a48:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a4f:	00 
 a50:	8b 45 08             	mov    0x8(%ebp),%eax
 a53:	89 04 24             	mov    %eax,(%esp)
 a56:	e8 a2 fd ff ff       	call   7fd <putc>
        putc(fd, c);
 a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a5e:	0f be c0             	movsbl %al,%eax
 a61:	89 44 24 04          	mov    %eax,0x4(%esp)
 a65:	8b 45 08             	mov    0x8(%ebp),%eax
 a68:	89 04 24             	mov    %eax,(%esp)
 a6b:	e8 8d fd ff ff       	call   7fd <putc>
      }
      state = 0;
 a70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a77:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
 a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a81:	01 d0                	add    %edx,%eax
 a83:	0f b6 00             	movzbl (%eax),%eax
 a86:	84 c0                	test   %al,%al
 a88:	0f 85 71 fe ff ff    	jne    8ff <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a8e:	c9                   	leave  
 a8f:	c3                   	ret    

00000a90 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a96:	8b 45 08             	mov    0x8(%ebp),%eax
 a99:	83 e8 08             	sub    $0x8,%eax
 a9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9f:	a1 24 10 00 00       	mov    0x1024,%eax
 aa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 aa7:	eb 24                	jmp    acd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aac:	8b 00                	mov    (%eax),%eax
 aae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ab1:	77 12                	ja     ac5 <free+0x35>
 ab3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ab9:	77 24                	ja     adf <free+0x4f>
 abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abe:	8b 00                	mov    (%eax),%eax
 ac0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ac3:	77 1a                	ja     adf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac8:	8b 00                	mov    (%eax),%eax
 aca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ad3:	76 d4                	jbe    aa9 <free+0x19>
 ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad8:	8b 00                	mov    (%eax),%eax
 ada:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 add:	76 ca                	jbe    aa9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 adf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae2:	8b 40 04             	mov    0x4(%eax),%eax
 ae5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 aec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aef:	01 c2                	add    %eax,%edx
 af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af4:	8b 00                	mov    (%eax),%eax
 af6:	39 c2                	cmp    %eax,%edx
 af8:	75 24                	jne    b1e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 afa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 afd:	8b 50 04             	mov    0x4(%eax),%edx
 b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b03:	8b 00                	mov    (%eax),%eax
 b05:	8b 40 04             	mov    0x4(%eax),%eax
 b08:	01 c2                	add    %eax,%edx
 b0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b13:	8b 00                	mov    (%eax),%eax
 b15:	8b 10                	mov    (%eax),%edx
 b17:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b1a:	89 10                	mov    %edx,(%eax)
 b1c:	eb 0a                	jmp    b28 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b21:	8b 10                	mov    (%eax),%edx
 b23:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b26:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2b:	8b 40 04             	mov    0x4(%eax),%eax
 b2e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b38:	01 d0                	add    %edx,%eax
 b3a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b3d:	75 20                	jne    b5f <free+0xcf>
    p->s.size += bp->s.size;
 b3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b42:	8b 50 04             	mov    0x4(%eax),%edx
 b45:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b48:	8b 40 04             	mov    0x4(%eax),%eax
 b4b:	01 c2                	add    %eax,%edx
 b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b50:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b56:	8b 10                	mov    (%eax),%edx
 b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5b:	89 10                	mov    %edx,(%eax)
 b5d:	eb 08                	jmp    b67 <free+0xd7>
  } else
    p->s.ptr = bp;
 b5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b62:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b65:	89 10                	mov    %edx,(%eax)
  freep = p;
 b67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b6a:	a3 24 10 00 00       	mov    %eax,0x1024
}
 b6f:	c9                   	leave  
 b70:	c3                   	ret    

00000b71 <morecore>:

static Header*
morecore(uint nu)
{
 b71:	55                   	push   %ebp
 b72:	89 e5                	mov    %esp,%ebp
 b74:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b77:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b7e:	77 07                	ja     b87 <morecore+0x16>
    nu = 4096;
 b80:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b87:	8b 45 08             	mov    0x8(%ebp),%eax
 b8a:	c1 e0 03             	shl    $0x3,%eax
 b8d:	89 04 24             	mov    %eax,(%esp)
 b90:	e8 38 fc ff ff       	call   7cd <sbrk>
 b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b98:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b9c:	75 07                	jne    ba5 <morecore+0x34>
    return 0;
 b9e:	b8 00 00 00 00       	mov    $0x0,%eax
 ba3:	eb 22                	jmp    bc7 <morecore+0x56>
  hp = (Header*)p;
 ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bae:	8b 55 08             	mov    0x8(%ebp),%edx
 bb1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb7:	83 c0 08             	add    $0x8,%eax
 bba:	89 04 24             	mov    %eax,(%esp)
 bbd:	e8 ce fe ff ff       	call   a90 <free>
  return freep;
 bc2:	a1 24 10 00 00       	mov    0x1024,%eax
}
 bc7:	c9                   	leave  
 bc8:	c3                   	ret    

00000bc9 <malloc>:

void*
malloc(uint nbytes)
{
 bc9:	55                   	push   %ebp
 bca:	89 e5                	mov    %esp,%ebp
 bcc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bcf:	8b 45 08             	mov    0x8(%ebp),%eax
 bd2:	83 c0 07             	add    $0x7,%eax
 bd5:	c1 e8 03             	shr    $0x3,%eax
 bd8:	83 c0 01             	add    $0x1,%eax
 bdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bde:	a1 24 10 00 00       	mov    0x1024,%eax
 be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bea:	75 23                	jne    c0f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 bec:	c7 45 f0 1c 10 00 00 	movl   $0x101c,-0x10(%ebp)
 bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf6:	a3 24 10 00 00       	mov    %eax,0x1024
 bfb:	a1 24 10 00 00       	mov    0x1024,%eax
 c00:	a3 1c 10 00 00       	mov    %eax,0x101c
    base.s.size = 0;
 c05:	c7 05 20 10 00 00 00 	movl   $0x0,0x1020
 c0c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c12:	8b 00                	mov    (%eax),%eax
 c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1a:	8b 40 04             	mov    0x4(%eax),%eax
 c1d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c20:	72 4d                	jb     c6f <malloc+0xa6>
      if(p->s.size == nunits)
 c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c25:	8b 40 04             	mov    0x4(%eax),%eax
 c28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c2b:	75 0c                	jne    c39 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c30:	8b 10                	mov    (%eax),%edx
 c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c35:	89 10                	mov    %edx,(%eax)
 c37:	eb 26                	jmp    c5f <malloc+0x96>
      else {
        p->s.size -= nunits;
 c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c3c:	8b 40 04             	mov    0x4(%eax),%eax
 c3f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c42:	89 c2                	mov    %eax,%edx
 c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c47:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4d:	8b 40 04             	mov    0x4(%eax),%eax
 c50:	c1 e0 03             	shl    $0x3,%eax
 c53:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c59:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c5c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c62:	a3 24 10 00 00       	mov    %eax,0x1024
      return (void*)(p + 1);
 c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c6a:	83 c0 08             	add    $0x8,%eax
 c6d:	eb 38                	jmp    ca7 <malloc+0xde>
    }
    if(p == freep)
 c6f:	a1 24 10 00 00       	mov    0x1024,%eax
 c74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c77:	75 1b                	jne    c94 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c7c:	89 04 24             	mov    %eax,(%esp)
 c7f:	e8 ed fe ff ff       	call   b71 <morecore>
 c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c8b:	75 07                	jne    c94 <malloc+0xcb>
        return 0;
 c8d:	b8 00 00 00 00       	mov    $0x0,%eax
 c92:	eb 13                	jmp    ca7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9d:	8b 00                	mov    (%eax),%eax
 c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ca2:	e9 70 ff ff ff       	jmp    c17 <malloc+0x4e>
}
 ca7:	c9                   	leave  
 ca8:	c3                   	ret    
