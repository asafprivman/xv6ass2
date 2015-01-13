
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 d2 10 00 00       	call   10e3 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 74 16 00 00 	mov    0x1674(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 48 16 00 00 	movl   $0x1648,(%esp)
      2b:	e8 27 03 00 00       	call   357 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 9e 10 00 00       	call   10e3 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 be 10 00 00       	call   111b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 4f 16 00 	movl   $0x164f,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 00 12 00 00       	call   127b <printf>
    break;
      7b:	e9 86 01 00 00       	jmp    206 <runcmd+0x206>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 77 10 00 00       	call   110b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 77 10 00 00       	call   1123 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 5f 16 00 	movl   $0x165f,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 ad 11 00 00       	call   127b <printf>
      exit();
      ce:	e8 10 10 00 00       	call   10e3 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
    break;
      e1:	e9 20 01 00 00       	jmp    206 <runcmd+0x206>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      ec:	e8 8c 02 00 00       	call   37d <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 e3 0f 00 00       	call   10eb <wait>
    runcmd(lcmd->right);
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
    break;
     116:	e9 eb 00 00 00       	jmp    206 <runcmd+0x206>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 c7 0f 00 00       	call   10f3 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 6f 16 00 00 	movl   $0x166f,(%esp)
     137:	e8 1b 02 00 00       	call   357 <panic>
    if(fork1() == 0){
     13c:	e8 3c 02 00 00       	call   37d <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 ba 0f 00 00       	call   110b <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 ff 0f 00 00       	call   115b <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 a4 0f 00 00       	call   110b <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 99 0f 00 00       	call   110b <close>
      runcmd(pcmd->left);
     172:	8b 45 e8             	mov    -0x18(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 f8 01 00 00       	call   37d <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 76 0f 00 00       	call   110b <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 bb 0f 00 00       	call   115b <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 60 0f 00 00       	call   110b <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 55 0f 00 00       	call   110b <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 3c 0f 00 00       	call   110b <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 31 0f 00 00       	call   110b <close>
    wait();
     1da:	e8 0c 0f 00 00       	call   10eb <wait>
    wait();
     1df:	e8 07 0f 00 00       	call   10eb <wait>
    break;
     1e4:	eb 20                	jmp    206 <runcmd+0x206>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 8c 01 00 00       	call   37d <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 10                	jne    205 <runcmd+0x205>
      runcmd(bcmd->cmd);
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
    break;
     203:	eb 00                	jmp    205 <runcmd+0x205>
     205:	90                   	nop
  }
  exit();
     206:	e8 d8 0e 00 00       	call   10e3 <exit>

0000020b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     20b:	55                   	push   %ebp
     20c:	89 e5                	mov    %esp,%ebp
     20e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     211:	c7 44 24 04 8c 16 00 	movl   $0x168c,0x4(%esp)
     218:	00 
     219:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     220:	e8 56 10 00 00       	call   127b <printf>
  memset(buf, 0, nbuf);
     225:	8b 45 0c             	mov    0xc(%ebp),%eax
     228:	89 44 24 08          	mov    %eax,0x8(%esp)
     22c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     233:	00 
     234:	8b 45 08             	mov    0x8(%ebp),%eax
     237:	89 04 24             	mov    %eax,(%esp)
     23a:	e8 d8 0b 00 00       	call   e17 <memset>
  gets(buf, nbuf);
     23f:	8b 45 0c             	mov    0xc(%ebp),%eax
     242:	89 44 24 04          	mov    %eax,0x4(%esp)
     246:	8b 45 08             	mov    0x8(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 1d 0c 00 00       	call   e6e <gets>
  if(buf[0] == 0) // EOF
     251:	8b 45 08             	mov    0x8(%ebp),%eax
     254:	0f b6 00             	movzbl (%eax),%eax
     257:	84 c0                	test   %al,%al
     259:	75 07                	jne    262 <getcmd+0x57>
    return -1;
     25b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     260:	eb 05                	jmp    267 <getcmd+0x5c>
  return 0;
     262:	b8 00 00 00 00       	mov    $0x0,%eax
}
     267:	c9                   	leave  
     268:	c3                   	ret    

00000269 <main>:

int
main(void)
{
     269:	55                   	push   %ebp
     26a:	89 e5                	mov    %esp,%ebp
     26c:	83 e4 f0             	and    $0xfffffff0,%esp
     26f:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     272:	eb 15                	jmp    289 <main+0x20>
    if(fd >= 3){
     274:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     279:	7e 0e                	jle    289 <main+0x20>
      close(fd);
     27b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27f:	89 04 24             	mov    %eax,(%esp)
     282:	e8 84 0e 00 00       	call   110b <close>
      break;
     287:	eb 1f                	jmp    2a8 <main+0x3f>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     289:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     290:	00 
     291:	c7 04 24 8f 16 00 00 	movl   $0x168f,(%esp)
     298:	e8 86 0e 00 00       	call   1123 <open>
     29d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a1:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a6:	79 cc                	jns    274 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2a8:	e9 89 00 00 00       	jmp    336 <main+0xcd>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2ad:	0f b6 05 60 1c 00 00 	movzbl 0x1c60,%eax
     2b4:	3c 63                	cmp    $0x63,%al
     2b6:	75 5c                	jne    314 <main+0xab>
     2b8:	0f b6 05 61 1c 00 00 	movzbl 0x1c61,%eax
     2bf:	3c 64                	cmp    $0x64,%al
     2c1:	75 51                	jne    314 <main+0xab>
     2c3:	0f b6 05 62 1c 00 00 	movzbl 0x1c62,%eax
     2ca:	3c 20                	cmp    $0x20,%al
     2cc:	75 46                	jne    314 <main+0xab>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2ce:	c7 04 24 60 1c 00 00 	movl   $0x1c60,(%esp)
     2d5:	e8 16 0b 00 00       	call   df0 <strlen>
     2da:	83 e8 01             	sub    $0x1,%eax
     2dd:	c6 80 60 1c 00 00 00 	movb   $0x0,0x1c60(%eax)
      if(chdir(buf+3) < 0)
     2e4:	c7 04 24 63 1c 00 00 	movl   $0x1c63,(%esp)
     2eb:	e8 63 0e 00 00       	call   1153 <chdir>
     2f0:	85 c0                	test   %eax,%eax
     2f2:	79 1e                	jns    312 <main+0xa9>
        printf(2, "cannot cd %s\n", buf+3);
     2f4:	c7 44 24 08 63 1c 00 	movl   $0x1c63,0x8(%esp)
     2fb:	00 
     2fc:	c7 44 24 04 97 16 00 	movl   $0x1697,0x4(%esp)
     303:	00 
     304:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     30b:	e8 6b 0f 00 00       	call   127b <printf>
      continue;
     310:	eb 24                	jmp    336 <main+0xcd>
     312:	eb 22                	jmp    336 <main+0xcd>
    }
    if(fork1() == 0)
     314:	e8 64 00 00 00       	call   37d <fork1>
     319:	85 c0                	test   %eax,%eax
     31b:	75 14                	jne    331 <main+0xc8>
      runcmd(parsecmd(buf));
     31d:	c7 04 24 60 1c 00 00 	movl   $0x1c60,(%esp)
     324:	e8 c9 03 00 00       	call   6f2 <parsecmd>
     329:	89 04 24             	mov    %eax,(%esp)
     32c:	e8 cf fc ff ff       	call   0 <runcmd>
    wait();
     331:	e8 b5 0d 00 00       	call   10eb <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     336:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     33d:	00 
     33e:	c7 04 24 60 1c 00 00 	movl   $0x1c60,(%esp)
     345:	e8 c1 fe ff ff       	call   20b <getcmd>
     34a:	85 c0                	test   %eax,%eax
     34c:	0f 89 5b ff ff ff    	jns    2ad <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     352:	e8 8c 0d 00 00       	call   10e3 <exit>

00000357 <panic>:
}

void
panic(char *s)
{
     357:	55                   	push   %ebp
     358:	89 e5                	mov    %esp,%ebp
     35a:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	89 44 24 08          	mov    %eax,0x8(%esp)
     364:	c7 44 24 04 a5 16 00 	movl   $0x16a5,0x4(%esp)
     36b:	00 
     36c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     373:	e8 03 0f 00 00       	call   127b <printf>
  exit();
     378:	e8 66 0d 00 00       	call   10e3 <exit>

0000037d <fork1>:
}

int
fork1(void)
{
     37d:	55                   	push   %ebp
     37e:	89 e5                	mov    %esp,%ebp
     380:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     383:	e8 53 0d 00 00       	call   10db <fork>
     388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     38b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     38f:	75 0c                	jne    39d <fork1+0x20>
    panic("fork");
     391:	c7 04 24 a9 16 00 00 	movl   $0x16a9,(%esp)
     398:	e8 ba ff ff ff       	call   357 <panic>
  return pid;
     39d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3a0:	c9                   	leave  
     3a1:	c3                   	ret    

000003a2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3a2:	55                   	push   %ebp
     3a3:	89 e5                	mov    %esp,%ebp
     3a5:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a8:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3af:	e8 b3 11 00 00       	call   1567 <malloc>
     3b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3b7:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3be:	00 
     3bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c6:	00 
     3c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3ca:	89 04 24             	mov    %eax,(%esp)
     3cd:	e8 45 0a 00 00       	call   e17 <memset>
  cmd->type = EXEC;
     3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3de:	c9                   	leave  
     3df:	c3                   	ret    

000003e0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e6:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3ed:	e8 75 11 00 00       	call   1567 <malloc>
     3f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f5:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3fc:	00 
     3fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     404:	00 
     405:	8b 45 f4             	mov    -0xc(%ebp),%eax
     408:	89 04 24             	mov    %eax,(%esp)
     40b:	e8 07 0a 00 00       	call   e17 <memset>
  cmd->type = REDIR;
     410:	8b 45 f4             	mov    -0xc(%ebp),%eax
     413:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     419:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41c:	8b 55 08             	mov    0x8(%ebp),%edx
     41f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     422:	8b 45 f4             	mov    -0xc(%ebp),%eax
     425:	8b 55 0c             	mov    0xc(%ebp),%edx
     428:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     42b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     42e:	8b 55 10             	mov    0x10(%ebp),%edx
     431:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     434:	8b 45 f4             	mov    -0xc(%ebp),%eax
     437:	8b 55 14             	mov    0x14(%ebp),%edx
     43a:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     440:	8b 55 18             	mov    0x18(%ebp),%edx
     443:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     446:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     449:	c9                   	leave  
     44a:	c3                   	ret    

0000044b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     44b:	55                   	push   %ebp
     44c:	89 e5                	mov    %esp,%ebp
     44e:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     451:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     458:	e8 0a 11 00 00       	call   1567 <malloc>
     45d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     460:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     467:	00 
     468:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     46f:	00 
     470:	8b 45 f4             	mov    -0xc(%ebp),%eax
     473:	89 04 24             	mov    %eax,(%esp)
     476:	e8 9c 09 00 00       	call   e17 <memset>
  cmd->type = PIPE;
     47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     484:	8b 45 f4             	mov    -0xc(%ebp),%eax
     487:	8b 55 08             	mov    0x8(%ebp),%edx
     48a:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     48d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     490:	8b 55 0c             	mov    0xc(%ebp),%edx
     493:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     496:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     499:	c9                   	leave  
     49a:	c3                   	ret    

0000049b <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     49b:	55                   	push   %ebp
     49c:	89 e5                	mov    %esp,%ebp
     49e:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a1:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4a8:	e8 ba 10 00 00       	call   1567 <malloc>
     4ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4b0:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4b7:	00 
     4b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4bf:	00 
     4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c3:	89 04 24             	mov    %eax,(%esp)
     4c6:	e8 4c 09 00 00       	call   e17 <memset>
  cmd->type = LIST;
     4cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ce:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d7:	8b 55 08             	mov    0x8(%ebp),%edx
     4da:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e0:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e3:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4e9:	c9                   	leave  
     4ea:	c3                   	ret    

000004eb <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4eb:	55                   	push   %ebp
     4ec:	89 e5                	mov    %esp,%ebp
     4ee:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4f8:	e8 6a 10 00 00       	call   1567 <malloc>
     4fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     500:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     507:	00 
     508:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     50f:	00 
     510:	8b 45 f4             	mov    -0xc(%ebp),%eax
     513:	89 04 24             	mov    %eax,(%esp)
     516:	e8 fc 08 00 00       	call   e17 <memset>
  cmd->type = BACK;
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     524:	8b 45 f4             	mov    -0xc(%ebp),%eax
     527:	8b 55 08             	mov    0x8(%ebp),%edx
     52a:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     530:	c9                   	leave  
     531:	c3                   	ret    

00000532 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     532:	55                   	push   %ebp
     533:	89 e5                	mov    %esp,%ebp
     535:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     538:	8b 45 08             	mov    0x8(%ebp),%eax
     53b:	8b 00                	mov    (%eax),%eax
     53d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     540:	eb 04                	jmp    546 <gettoken+0x14>
    s++;
     542:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     546:	8b 45 f4             	mov    -0xc(%ebp),%eax
     549:	3b 45 0c             	cmp    0xc(%ebp),%eax
     54c:	73 1d                	jae    56b <gettoken+0x39>
     54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     551:	0f b6 00             	movzbl (%eax),%eax
     554:	0f be c0             	movsbl %al,%eax
     557:	89 44 24 04          	mov    %eax,0x4(%esp)
     55b:	c7 04 24 24 1c 00 00 	movl   $0x1c24,(%esp)
     562:	e8 d4 08 00 00       	call   e3b <strchr>
     567:	85 c0                	test   %eax,%eax
     569:	75 d7                	jne    542 <gettoken+0x10>
    s++;
  if(q)
     56b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     56f:	74 08                	je     579 <gettoken+0x47>
    *q = s;
     571:	8b 45 10             	mov    0x10(%ebp),%eax
     574:	8b 55 f4             	mov    -0xc(%ebp),%edx
     577:	89 10                	mov    %edx,(%eax)
  ret = *s;
     579:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57c:	0f b6 00             	movzbl (%eax),%eax
     57f:	0f be c0             	movsbl %al,%eax
     582:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     585:	8b 45 f4             	mov    -0xc(%ebp),%eax
     588:	0f b6 00             	movzbl (%eax),%eax
     58b:	0f be c0             	movsbl %al,%eax
     58e:	83 f8 29             	cmp    $0x29,%eax
     591:	7f 14                	jg     5a7 <gettoken+0x75>
     593:	83 f8 28             	cmp    $0x28,%eax
     596:	7d 28                	jge    5c0 <gettoken+0x8e>
     598:	85 c0                	test   %eax,%eax
     59a:	0f 84 94 00 00 00    	je     634 <gettoken+0x102>
     5a0:	83 f8 26             	cmp    $0x26,%eax
     5a3:	74 1b                	je     5c0 <gettoken+0x8e>
     5a5:	eb 3c                	jmp    5e3 <gettoken+0xb1>
     5a7:	83 f8 3e             	cmp    $0x3e,%eax
     5aa:	74 1a                	je     5c6 <gettoken+0x94>
     5ac:	83 f8 3e             	cmp    $0x3e,%eax
     5af:	7f 0a                	jg     5bb <gettoken+0x89>
     5b1:	83 e8 3b             	sub    $0x3b,%eax
     5b4:	83 f8 01             	cmp    $0x1,%eax
     5b7:	77 2a                	ja     5e3 <gettoken+0xb1>
     5b9:	eb 05                	jmp    5c0 <gettoken+0x8e>
     5bb:	83 f8 7c             	cmp    $0x7c,%eax
     5be:	75 23                	jne    5e3 <gettoken+0xb1>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5c4:	eb 6f                	jmp    635 <gettoken+0x103>
  case '>':
    s++;
     5c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cd:	0f b6 00             	movzbl (%eax),%eax
     5d0:	3c 3e                	cmp    $0x3e,%al
     5d2:	75 0d                	jne    5e1 <gettoken+0xaf>
      ret = '+';
     5d4:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5df:	eb 54                	jmp    635 <gettoken+0x103>
     5e1:	eb 52                	jmp    635 <gettoken+0x103>
  default:
    ret = 'a';
     5e3:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5ea:	eb 04                	jmp    5f0 <gettoken+0xbe>
      s++;
     5ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f6:	73 3a                	jae    632 <gettoken+0x100>
     5f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fb:	0f b6 00             	movzbl (%eax),%eax
     5fe:	0f be c0             	movsbl %al,%eax
     601:	89 44 24 04          	mov    %eax,0x4(%esp)
     605:	c7 04 24 24 1c 00 00 	movl   $0x1c24,(%esp)
     60c:	e8 2a 08 00 00       	call   e3b <strchr>
     611:	85 c0                	test   %eax,%eax
     613:	75 1d                	jne    632 <gettoken+0x100>
     615:	8b 45 f4             	mov    -0xc(%ebp),%eax
     618:	0f b6 00             	movzbl (%eax),%eax
     61b:	0f be c0             	movsbl %al,%eax
     61e:	89 44 24 04          	mov    %eax,0x4(%esp)
     622:	c7 04 24 2a 1c 00 00 	movl   $0x1c2a,(%esp)
     629:	e8 0d 08 00 00       	call   e3b <strchr>
     62e:	85 c0                	test   %eax,%eax
     630:	74 ba                	je     5ec <gettoken+0xba>
      s++;
    break;
     632:	eb 01                	jmp    635 <gettoken+0x103>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     634:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     635:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     639:	74 0a                	je     645 <gettoken+0x113>
    *eq = s;
     63b:	8b 45 14             	mov    0x14(%ebp),%eax
     63e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     641:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     643:	eb 06                	jmp    64b <gettoken+0x119>
     645:	eb 04                	jmp    64b <gettoken+0x119>
    s++;
     647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     651:	73 1d                	jae    670 <gettoken+0x13e>
     653:	8b 45 f4             	mov    -0xc(%ebp),%eax
     656:	0f b6 00             	movzbl (%eax),%eax
     659:	0f be c0             	movsbl %al,%eax
     65c:	89 44 24 04          	mov    %eax,0x4(%esp)
     660:	c7 04 24 24 1c 00 00 	movl   $0x1c24,(%esp)
     667:	e8 cf 07 00 00       	call   e3b <strchr>
     66c:	85 c0                	test   %eax,%eax
     66e:	75 d7                	jne    647 <gettoken+0x115>
    s++;
  *ps = s;
     670:	8b 45 08             	mov    0x8(%ebp),%eax
     673:	8b 55 f4             	mov    -0xc(%ebp),%edx
     676:	89 10                	mov    %edx,(%eax)
  return ret;
     678:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     67b:	c9                   	leave  
     67c:	c3                   	ret    

0000067d <peek>:

int
peek(char **ps, char *es, char *toks)
{
     67d:	55                   	push   %ebp
     67e:	89 e5                	mov    %esp,%ebp
     680:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     683:	8b 45 08             	mov    0x8(%ebp),%eax
     686:	8b 00                	mov    (%eax),%eax
     688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     68b:	eb 04                	jmp    691 <peek+0x14>
    s++;
     68d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     691:	8b 45 f4             	mov    -0xc(%ebp),%eax
     694:	3b 45 0c             	cmp    0xc(%ebp),%eax
     697:	73 1d                	jae    6b6 <peek+0x39>
     699:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69c:	0f b6 00             	movzbl (%eax),%eax
     69f:	0f be c0             	movsbl %al,%eax
     6a2:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a6:	c7 04 24 24 1c 00 00 	movl   $0x1c24,(%esp)
     6ad:	e8 89 07 00 00       	call   e3b <strchr>
     6b2:	85 c0                	test   %eax,%eax
     6b4:	75 d7                	jne    68d <peek+0x10>
    s++;
  *ps = s;
     6b6:	8b 45 08             	mov    0x8(%ebp),%eax
     6b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6bc:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c1:	0f b6 00             	movzbl (%eax),%eax
     6c4:	84 c0                	test   %al,%al
     6c6:	74 23                	je     6eb <peek+0x6e>
     6c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cb:	0f b6 00             	movzbl (%eax),%eax
     6ce:	0f be c0             	movsbl %al,%eax
     6d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d5:	8b 45 10             	mov    0x10(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 5b 07 00 00       	call   e3b <strchr>
     6e0:	85 c0                	test   %eax,%eax
     6e2:	74 07                	je     6eb <peek+0x6e>
     6e4:	b8 01 00 00 00       	mov    $0x1,%eax
     6e9:	eb 05                	jmp    6f0 <peek+0x73>
     6eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6f0:	c9                   	leave  
     6f1:	c3                   	ret    

000006f2 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6f2:	55                   	push   %ebp
     6f3:	89 e5                	mov    %esp,%ebp
     6f5:	53                   	push   %ebx
     6f6:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6fc:	8b 45 08             	mov    0x8(%ebp),%eax
     6ff:	89 04 24             	mov    %eax,(%esp)
     702:	e8 e9 06 00 00       	call   df0 <strlen>
     707:	01 d8                	add    %ebx,%eax
     709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     70f:	89 44 24 04          	mov    %eax,0x4(%esp)
     713:	8d 45 08             	lea    0x8(%ebp),%eax
     716:	89 04 24             	mov    %eax,(%esp)
     719:	e8 60 00 00 00       	call   77e <parseline>
     71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     721:	c7 44 24 08 ae 16 00 	movl   $0x16ae,0x8(%esp)
     728:	00 
     729:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72c:	89 44 24 04          	mov    %eax,0x4(%esp)
     730:	8d 45 08             	lea    0x8(%ebp),%eax
     733:	89 04 24             	mov    %eax,(%esp)
     736:	e8 42 ff ff ff       	call   67d <peek>
  if(s != es){
     73b:	8b 45 08             	mov    0x8(%ebp),%eax
     73e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     741:	74 27                	je     76a <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     743:	8b 45 08             	mov    0x8(%ebp),%eax
     746:	89 44 24 08          	mov    %eax,0x8(%esp)
     74a:	c7 44 24 04 af 16 00 	movl   $0x16af,0x4(%esp)
     751:	00 
     752:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     759:	e8 1d 0b 00 00       	call   127b <printf>
    panic("syntax");
     75e:	c7 04 24 be 16 00 00 	movl   $0x16be,(%esp)
     765:	e8 ed fb ff ff       	call   357 <panic>
  }
  nulterminate(cmd);
     76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     76d:	89 04 24             	mov    %eax,(%esp)
     770:	e8 a3 04 00 00       	call   c18 <nulterminate>
  return cmd;
     775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     778:	83 c4 24             	add    $0x24,%esp
     77b:	5b                   	pop    %ebx
     77c:	5d                   	pop    %ebp
     77d:	c3                   	ret    

0000077e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     77e:	55                   	push   %ebp
     77f:	89 e5                	mov    %esp,%ebp
     781:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     784:	8b 45 0c             	mov    0xc(%ebp),%eax
     787:	89 44 24 04          	mov    %eax,0x4(%esp)
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	89 04 24             	mov    %eax,(%esp)
     791:	e8 bc 00 00 00       	call   852 <parsepipe>
     796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     799:	eb 30                	jmp    7cb <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     79b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7a2:	00 
     7a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7aa:	00 
     7ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ae:	89 44 24 04          	mov    %eax,0x4(%esp)
     7b2:	8b 45 08             	mov    0x8(%ebp),%eax
     7b5:	89 04 24             	mov    %eax,(%esp)
     7b8:	e8 75 fd ff ff       	call   532 <gettoken>
    cmd = backcmd(cmd);
     7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c0:	89 04 24             	mov    %eax,(%esp)
     7c3:	e8 23 fd ff ff       	call   4eb <backcmd>
     7c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7cb:	c7 44 24 08 c5 16 00 	movl   $0x16c5,0x8(%esp)
     7d2:	00 
     7d3:	8b 45 0c             	mov    0xc(%ebp),%eax
     7d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     7da:	8b 45 08             	mov    0x8(%ebp),%eax
     7dd:	89 04 24             	mov    %eax,(%esp)
     7e0:	e8 98 fe ff ff       	call   67d <peek>
     7e5:	85 c0                	test   %eax,%eax
     7e7:	75 b2                	jne    79b <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e9:	c7 44 24 08 c7 16 00 	movl   $0x16c7,0x8(%esp)
     7f0:	00 
     7f1:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f8:	8b 45 08             	mov    0x8(%ebp),%eax
     7fb:	89 04 24             	mov    %eax,(%esp)
     7fe:	e8 7a fe ff ff       	call   67d <peek>
     803:	85 c0                	test   %eax,%eax
     805:	74 46                	je     84d <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     807:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80e:	00 
     80f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     816:	00 
     817:	8b 45 0c             	mov    0xc(%ebp),%eax
     81a:	89 44 24 04          	mov    %eax,0x4(%esp)
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 09 fd ff ff       	call   532 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     829:	8b 45 0c             	mov    0xc(%ebp),%eax
     82c:	89 44 24 04          	mov    %eax,0x4(%esp)
     830:	8b 45 08             	mov    0x8(%ebp),%eax
     833:	89 04 24             	mov    %eax,(%esp)
     836:	e8 43 ff ff ff       	call   77e <parseline>
     83b:	89 44 24 04          	mov    %eax,0x4(%esp)
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	89 04 24             	mov    %eax,(%esp)
     845:	e8 51 fc ff ff       	call   49b <listcmd>
     84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     850:	c9                   	leave  
     851:	c3                   	ret    

00000852 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     852:	55                   	push   %ebp
     853:	89 e5                	mov    %esp,%ebp
     855:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     858:	8b 45 0c             	mov    0xc(%ebp),%eax
     85b:	89 44 24 04          	mov    %eax,0x4(%esp)
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	89 04 24             	mov    %eax,(%esp)
     865:	e8 68 02 00 00       	call   ad2 <parseexec>
     86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     86d:	c7 44 24 08 c9 16 00 	movl   $0x16c9,0x8(%esp)
     874:	00 
     875:	8b 45 0c             	mov    0xc(%ebp),%eax
     878:	89 44 24 04          	mov    %eax,0x4(%esp)
     87c:	8b 45 08             	mov    0x8(%ebp),%eax
     87f:	89 04 24             	mov    %eax,(%esp)
     882:	e8 f6 fd ff ff       	call   67d <peek>
     887:	85 c0                	test   %eax,%eax
     889:	74 46                	je     8d1 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     88b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     892:	00 
     893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     89a:	00 
     89b:	8b 45 0c             	mov    0xc(%ebp),%eax
     89e:	89 44 24 04          	mov    %eax,0x4(%esp)
     8a2:	8b 45 08             	mov    0x8(%ebp),%eax
     8a5:	89 04 24             	mov    %eax,(%esp)
     8a8:	e8 85 fc ff ff       	call   532 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b4:	8b 45 08             	mov    0x8(%ebp),%eax
     8b7:	89 04 24             	mov    %eax,(%esp)
     8ba:	e8 93 ff ff ff       	call   852 <parsepipe>
     8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c6:	89 04 24             	mov    %eax,(%esp)
     8c9:	e8 7d fb ff ff       	call   44b <pipecmd>
     8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8d4:	c9                   	leave  
     8d5:	c3                   	ret    

000008d6 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8d6:	55                   	push   %ebp
     8d7:	89 e5                	mov    %esp,%ebp
     8d9:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8dc:	e9 f6 00 00 00       	jmp    9d7 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     8e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8e8:	00 
     8e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8f0:	00 
     8f1:	8b 45 10             	mov    0x10(%ebp),%eax
     8f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 2f fc ff ff       	call   532 <gettoken>
     903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     906:	8d 45 ec             	lea    -0x14(%ebp),%eax
     909:	89 44 24 0c          	mov    %eax,0xc(%esp)
     90d:	8d 45 f0             	lea    -0x10(%ebp),%eax
     910:	89 44 24 08          	mov    %eax,0x8(%esp)
     914:	8b 45 10             	mov    0x10(%ebp),%eax
     917:	89 44 24 04          	mov    %eax,0x4(%esp)
     91b:	8b 45 0c             	mov    0xc(%ebp),%eax
     91e:	89 04 24             	mov    %eax,(%esp)
     921:	e8 0c fc ff ff       	call   532 <gettoken>
     926:	83 f8 61             	cmp    $0x61,%eax
     929:	74 0c                	je     937 <parseredirs+0x61>
      panic("missing file for redirection");
     92b:	c7 04 24 cb 16 00 00 	movl   $0x16cb,(%esp)
     932:	e8 20 fa ff ff       	call   357 <panic>
    switch(tok){
     937:	8b 45 f4             	mov    -0xc(%ebp),%eax
     93a:	83 f8 3c             	cmp    $0x3c,%eax
     93d:	74 0f                	je     94e <parseredirs+0x78>
     93f:	83 f8 3e             	cmp    $0x3e,%eax
     942:	74 38                	je     97c <parseredirs+0xa6>
     944:	83 f8 2b             	cmp    $0x2b,%eax
     947:	74 61                	je     9aa <parseredirs+0xd4>
     949:	e9 89 00 00 00       	jmp    9d7 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     94e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     951:	8b 45 f0             	mov    -0x10(%ebp),%eax
     954:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     95b:	00 
     95c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     963:	00 
     964:	89 54 24 08          	mov    %edx,0x8(%esp)
     968:	89 44 24 04          	mov    %eax,0x4(%esp)
     96c:	8b 45 08             	mov    0x8(%ebp),%eax
     96f:	89 04 24             	mov    %eax,(%esp)
     972:	e8 69 fa ff ff       	call   3e0 <redircmd>
     977:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     97a:	eb 5b                	jmp    9d7 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     97c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     982:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     989:	00 
     98a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     991:	00 
     992:	89 54 24 08          	mov    %edx,0x8(%esp)
     996:	89 44 24 04          	mov    %eax,0x4(%esp)
     99a:	8b 45 08             	mov    0x8(%ebp),%eax
     99d:	89 04 24             	mov    %eax,(%esp)
     9a0:	e8 3b fa ff ff       	call   3e0 <redircmd>
     9a5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9a8:	eb 2d                	jmp    9d7 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9b0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     9b7:	00 
     9b8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9bf:	00 
     9c0:	89 54 24 08          	mov    %edx,0x8(%esp)
     9c4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c8:	8b 45 08             	mov    0x8(%ebp),%eax
     9cb:	89 04 24             	mov    %eax,(%esp)
     9ce:	e8 0d fa ff ff       	call   3e0 <redircmd>
     9d3:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9d6:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9d7:	c7 44 24 08 e8 16 00 	movl   $0x16e8,0x8(%esp)
     9de:	00 
     9df:	8b 45 10             	mov    0x10(%ebp),%eax
     9e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e6:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e9:	89 04 24             	mov    %eax,(%esp)
     9ec:	e8 8c fc ff ff       	call   67d <peek>
     9f1:	85 c0                	test   %eax,%eax
     9f3:	0f 85 e8 fe ff ff    	jne    8e1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9fc:	c9                   	leave  
     9fd:	c3                   	ret    

000009fe <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9fe:	55                   	push   %ebp
     9ff:	89 e5                	mov    %esp,%ebp
     a01:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a04:	c7 44 24 08 eb 16 00 	movl   $0x16eb,0x8(%esp)
     a0b:	00 
     a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a13:	8b 45 08             	mov    0x8(%ebp),%eax
     a16:	89 04 24             	mov    %eax,(%esp)
     a19:	e8 5f fc ff ff       	call   67d <peek>
     a1e:	85 c0                	test   %eax,%eax
     a20:	75 0c                	jne    a2e <parseblock+0x30>
    panic("parseblock");
     a22:	c7 04 24 ed 16 00 00 	movl   $0x16ed,(%esp)
     a29:	e8 29 f9 ff ff       	call   357 <panic>
  gettoken(ps, es, 0, 0);
     a2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a35:	00 
     a36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a3d:	00 
     a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     a41:	89 44 24 04          	mov    %eax,0x4(%esp)
     a45:	8b 45 08             	mov    0x8(%ebp),%eax
     a48:	89 04 24             	mov    %eax,(%esp)
     a4b:	e8 e2 fa ff ff       	call   532 <gettoken>
  cmd = parseline(ps, es);
     a50:	8b 45 0c             	mov    0xc(%ebp),%eax
     a53:	89 44 24 04          	mov    %eax,0x4(%esp)
     a57:	8b 45 08             	mov    0x8(%ebp),%eax
     a5a:	89 04 24             	mov    %eax,(%esp)
     a5d:	e8 1c fd ff ff       	call   77e <parseline>
     a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a65:	c7 44 24 08 f8 16 00 	movl   $0x16f8,0x8(%esp)
     a6c:	00 
     a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     a70:	89 44 24 04          	mov    %eax,0x4(%esp)
     a74:	8b 45 08             	mov    0x8(%ebp),%eax
     a77:	89 04 24             	mov    %eax,(%esp)
     a7a:	e8 fe fb ff ff       	call   67d <peek>
     a7f:	85 c0                	test   %eax,%eax
     a81:	75 0c                	jne    a8f <parseblock+0x91>
    panic("syntax - missing )");
     a83:	c7 04 24 fa 16 00 00 	movl   $0x16fa,(%esp)
     a8a:	e8 c8 f8 ff ff       	call   357 <panic>
  gettoken(ps, es, 0, 0);
     a8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a96:	00 
     a97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a9e:	00 
     a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa6:	8b 45 08             	mov    0x8(%ebp),%eax
     aa9:	89 04 24             	mov    %eax,(%esp)
     aac:	e8 81 fa ff ff       	call   532 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab8:	8b 45 08             	mov    0x8(%ebp),%eax
     abb:	89 44 24 04          	mov    %eax,0x4(%esp)
     abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac2:	89 04 24             	mov    %eax,(%esp)
     ac5:	e8 0c fe ff ff       	call   8d6 <parseredirs>
     aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ad0:	c9                   	leave  
     ad1:	c3                   	ret    

00000ad2 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     ad2:	55                   	push   %ebp
     ad3:	89 e5                	mov    %esp,%ebp
     ad5:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     ad8:	c7 44 24 08 eb 16 00 	movl   $0x16eb,0x8(%esp)
     adf:	00 
     ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae7:	8b 45 08             	mov    0x8(%ebp),%eax
     aea:	89 04 24             	mov    %eax,(%esp)
     aed:	e8 8b fb ff ff       	call   67d <peek>
     af2:	85 c0                	test   %eax,%eax
     af4:	74 17                	je     b0d <parseexec+0x3b>
    return parseblock(ps, es);
     af6:	8b 45 0c             	mov    0xc(%ebp),%eax
     af9:	89 44 24 04          	mov    %eax,0x4(%esp)
     afd:	8b 45 08             	mov    0x8(%ebp),%eax
     b00:	89 04 24             	mov    %eax,(%esp)
     b03:	e8 f6 fe ff ff       	call   9fe <parseblock>
     b08:	e9 09 01 00 00       	jmp    c16 <parseexec+0x144>

  ret = execcmd();
     b0d:	e8 90 f8 ff ff       	call   3a2 <execcmd>
     b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b18:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     b22:	8b 45 0c             	mov    0xc(%ebp),%eax
     b25:	89 44 24 08          	mov    %eax,0x8(%esp)
     b29:	8b 45 08             	mov    0x8(%ebp),%eax
     b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
     b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b33:	89 04 24             	mov    %eax,(%esp)
     b36:	e8 9b fd ff ff       	call   8d6 <parseredirs>
     b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b3e:	e9 8f 00 00 00       	jmp    bd2 <parseexec+0x100>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b43:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b46:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
     b51:	8b 45 0c             	mov    0xc(%ebp),%eax
     b54:	89 44 24 04          	mov    %eax,0x4(%esp)
     b58:	8b 45 08             	mov    0x8(%ebp),%eax
     b5b:	89 04 24             	mov    %eax,(%esp)
     b5e:	e8 cf f9 ff ff       	call   532 <gettoken>
     b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b6a:	75 05                	jne    b71 <parseexec+0x9f>
      break;
     b6c:	e9 83 00 00 00       	jmp    bf4 <parseexec+0x122>
    if(tok != 'a')
     b71:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b75:	74 0c                	je     b83 <parseexec+0xb1>
      panic("syntax");
     b77:	c7 04 24 be 16 00 00 	movl   $0x16be,(%esp)
     b7e:	e8 d4 f7 ff ff       	call   357 <panic>
    cmd->argv[argc] = q;
     b83:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b86:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b8c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b90:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b99:	83 c1 08             	add    $0x8,%ecx
     b9c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     ba0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     ba4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ba8:	7e 0c                	jle    bb6 <parseexec+0xe4>
      panic("too many args");
     baa:	c7 04 24 0d 17 00 00 	movl   $0x170d,(%esp)
     bb1:	e8 a1 f7 ff ff       	call   357 <panic>
    ret = parseredirs(ret, ps, es);
     bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbd:	8b 45 08             	mov    0x8(%ebp),%eax
     bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bc7:	89 04 24             	mov    %eax,(%esp)
     bca:	e8 07 fd ff ff       	call   8d6 <parseredirs>
     bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     bd2:	c7 44 24 08 1b 17 00 	movl   $0x171b,0x8(%esp)
     bd9:	00 
     bda:	8b 45 0c             	mov    0xc(%ebp),%eax
     bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
     be1:	8b 45 08             	mov    0x8(%ebp),%eax
     be4:	89 04 24             	mov    %eax,(%esp)
     be7:	e8 91 fa ff ff       	call   67d <peek>
     bec:	85 c0                	test   %eax,%eax
     bee:	0f 84 4f ff ff ff    	je     b43 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bfa:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c01:	00 
  cmd->eargv[argc] = 0;
     c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c08:	83 c2 08             	add    $0x8,%edx
     c0b:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c12:	00 
  return ret;
     c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     c16:	c9                   	leave  
     c17:	c3                   	ret    

00000c18 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     c18:	55                   	push   %ebp
     c19:	89 e5                	mov    %esp,%ebp
     c1b:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c22:	75 0a                	jne    c2e <nulterminate+0x16>
    return 0;
     c24:	b8 00 00 00 00       	mov    $0x0,%eax
     c29:	e9 c9 00 00 00       	jmp    cf7 <nulterminate+0xdf>
  
  switch(cmd->type){
     c2e:	8b 45 08             	mov    0x8(%ebp),%eax
     c31:	8b 00                	mov    (%eax),%eax
     c33:	83 f8 05             	cmp    $0x5,%eax
     c36:	0f 87 b8 00 00 00    	ja     cf4 <nulterminate+0xdc>
     c3c:	8b 04 85 20 17 00 00 	mov    0x1720(,%eax,4),%eax
     c43:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c45:	8b 45 08             	mov    0x8(%ebp),%eax
     c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c52:	eb 14                	jmp    c68 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c5a:	83 c2 08             	add    $0x8,%edx
     c5d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c61:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c6e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c72:	85 c0                	test   %eax,%eax
     c74:	75 de                	jne    c54 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c76:	eb 7c                	jmp    cf4 <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c78:	8b 45 08             	mov    0x8(%ebp),%eax
     c7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c81:	8b 40 04             	mov    0x4(%eax),%eax
     c84:	89 04 24             	mov    %eax,(%esp)
     c87:	e8 8c ff ff ff       	call   c18 <nulterminate>
    *rcmd->efile = 0;
     c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c8f:	8b 40 0c             	mov    0xc(%eax),%eax
     c92:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c95:	eb 5d                	jmp    cf4 <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c97:	8b 45 08             	mov    0x8(%ebp),%eax
     c9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ca0:	8b 40 04             	mov    0x4(%eax),%eax
     ca3:	89 04 24             	mov    %eax,(%esp)
     ca6:	e8 6d ff ff ff       	call   c18 <nulterminate>
    nulterminate(pcmd->right);
     cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cae:	8b 40 08             	mov    0x8(%eax),%eax
     cb1:	89 04 24             	mov    %eax,(%esp)
     cb4:	e8 5f ff ff ff       	call   c18 <nulterminate>
    break;
     cb9:	eb 39                	jmp    cf4 <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     cbb:	8b 45 08             	mov    0x8(%ebp),%eax
     cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cc4:	8b 40 04             	mov    0x4(%eax),%eax
     cc7:	89 04 24             	mov    %eax,(%esp)
     cca:	e8 49 ff ff ff       	call   c18 <nulterminate>
    nulterminate(lcmd->right);
     ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cd2:	8b 40 08             	mov    0x8(%eax),%eax
     cd5:	89 04 24             	mov    %eax,(%esp)
     cd8:	e8 3b ff ff ff       	call   c18 <nulterminate>
    break;
     cdd:	eb 15                	jmp    cf4 <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     cdf:	8b 45 08             	mov    0x8(%ebp),%eax
     ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ce8:	8b 40 04             	mov    0x4(%eax),%eax
     ceb:	89 04 24             	mov    %eax,(%esp)
     cee:	e8 25 ff ff ff       	call   c18 <nulterminate>
    break;
     cf3:	90                   	nop
  }
  return cmd;
     cf4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cf7:	c9                   	leave  
     cf8:	c3                   	ret    

00000cf9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     cf9:	55                   	push   %ebp
     cfa:	89 e5                	mov    %esp,%ebp
     cfc:	57                   	push   %edi
     cfd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     cfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d01:	8b 55 10             	mov    0x10(%ebp),%edx
     d04:	8b 45 0c             	mov    0xc(%ebp),%eax
     d07:	89 cb                	mov    %ecx,%ebx
     d09:	89 df                	mov    %ebx,%edi
     d0b:	89 d1                	mov    %edx,%ecx
     d0d:	fc                   	cld    
     d0e:	f3 aa                	rep stos %al,%es:(%edi)
     d10:	89 ca                	mov    %ecx,%edx
     d12:	89 fb                	mov    %edi,%ebx
     d14:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d17:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d1a:	5b                   	pop    %ebx
     d1b:	5f                   	pop    %edi
     d1c:	5d                   	pop    %ebp
     d1d:	c3                   	ret    

00000d1e <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
     d1e:	55                   	push   %ebp
     d1f:	89 e5                	mov    %esp,%ebp
     d21:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
     d24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d2b:	8b 45 08             	mov    0x8(%ebp),%eax
     d2e:	89 04 24             	mov    %eax,(%esp)
     d31:	e8 ba 00 00 00       	call   df0 <strlen>
     d36:	83 e8 01             	sub    $0x1,%eax
     d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
     d3c:	eb 39                	jmp    d77 <reverse+0x59>
         c = s[i];
     d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d41:	8b 45 08             	mov    0x8(%ebp),%eax
     d44:	01 d0                	add    %edx,%eax
     d46:	0f b6 00             	movzbl (%eax),%eax
     d49:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
     d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d4f:	8b 45 08             	mov    0x8(%ebp),%eax
     d52:	01 c2                	add    %eax,%edx
     d54:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     d57:	8b 45 08             	mov    0x8(%ebp),%eax
     d5a:	01 c8                	add    %ecx,%eax
     d5c:	0f b6 00             	movzbl (%eax),%eax
     d5f:	88 02                	mov    %al,(%edx)
         s[j] = c;
     d61:	8b 55 f0             	mov    -0x10(%ebp),%edx
     d64:	8b 45 08             	mov    0x8(%ebp),%eax
     d67:	01 c2                	add    %eax,%edx
     d69:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     d6d:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
     d6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d73:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     d7d:	7c bf                	jl     d3e <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
     d7f:	c9                   	leave  
     d80:	c3                   	ret    

00000d81 <strcpy>:

char*
strcpy(char *s, char *t)
{
     d81:	55                   	push   %ebp
     d82:	89 e5                	mov    %esp,%ebp
     d84:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d87:	8b 45 08             	mov    0x8(%ebp),%eax
     d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d8d:	90                   	nop
     d8e:	8b 45 08             	mov    0x8(%ebp),%eax
     d91:	8d 50 01             	lea    0x1(%eax),%edx
     d94:	89 55 08             	mov    %edx,0x8(%ebp)
     d97:	8b 55 0c             	mov    0xc(%ebp),%edx
     d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
     d9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     da0:	0f b6 12             	movzbl (%edx),%edx
     da3:	88 10                	mov    %dl,(%eax)
     da5:	0f b6 00             	movzbl (%eax),%eax
     da8:	84 c0                	test   %al,%al
     daa:	75 e2                	jne    d8e <strcpy+0xd>
    ;
  return os;
     dac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     daf:	c9                   	leave  
     db0:	c3                   	ret    

00000db1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     db1:	55                   	push   %ebp
     db2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     db4:	eb 08                	jmp    dbe <strcmp+0xd>
    p++, q++;
     db6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     dba:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     dbe:	8b 45 08             	mov    0x8(%ebp),%eax
     dc1:	0f b6 00             	movzbl (%eax),%eax
     dc4:	84 c0                	test   %al,%al
     dc6:	74 10                	je     dd8 <strcmp+0x27>
     dc8:	8b 45 08             	mov    0x8(%ebp),%eax
     dcb:	0f b6 10             	movzbl (%eax),%edx
     dce:	8b 45 0c             	mov    0xc(%ebp),%eax
     dd1:	0f b6 00             	movzbl (%eax),%eax
     dd4:	38 c2                	cmp    %al,%dl
     dd6:	74 de                	je     db6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     dd8:	8b 45 08             	mov    0x8(%ebp),%eax
     ddb:	0f b6 00             	movzbl (%eax),%eax
     dde:	0f b6 d0             	movzbl %al,%edx
     de1:	8b 45 0c             	mov    0xc(%ebp),%eax
     de4:	0f b6 00             	movzbl (%eax),%eax
     de7:	0f b6 c0             	movzbl %al,%eax
     dea:	29 c2                	sub    %eax,%edx
     dec:	89 d0                	mov    %edx,%eax
}
     dee:	5d                   	pop    %ebp
     def:	c3                   	ret    

00000df0 <strlen>:

uint
strlen(char *s)
{
     df0:	55                   	push   %ebp
     df1:	89 e5                	mov    %esp,%ebp
     df3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     df6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     dfd:	eb 04                	jmp    e03 <strlen+0x13>
     dff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     e03:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e06:	8b 45 08             	mov    0x8(%ebp),%eax
     e09:	01 d0                	add    %edx,%eax
     e0b:	0f b6 00             	movzbl (%eax),%eax
     e0e:	84 c0                	test   %al,%al
     e10:	75 ed                	jne    dff <strlen+0xf>
    ;
  return n;
     e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e15:	c9                   	leave  
     e16:	c3                   	ret    

00000e17 <memset>:

void*
memset(void *dst, int c, uint n)
{
     e17:	55                   	push   %ebp
     e18:	89 e5                	mov    %esp,%ebp
     e1a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     e1d:	8b 45 10             	mov    0x10(%ebp),%eax
     e20:	89 44 24 08          	mov    %eax,0x8(%esp)
     e24:	8b 45 0c             	mov    0xc(%ebp),%eax
     e27:	89 44 24 04          	mov    %eax,0x4(%esp)
     e2b:	8b 45 08             	mov    0x8(%ebp),%eax
     e2e:	89 04 24             	mov    %eax,(%esp)
     e31:	e8 c3 fe ff ff       	call   cf9 <stosb>
  return dst;
     e36:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e39:	c9                   	leave  
     e3a:	c3                   	ret    

00000e3b <strchr>:

char*
strchr(const char *s, char c)
{
     e3b:	55                   	push   %ebp
     e3c:	89 e5                	mov    %esp,%ebp
     e3e:	83 ec 04             	sub    $0x4,%esp
     e41:	8b 45 0c             	mov    0xc(%ebp),%eax
     e44:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     e47:	eb 14                	jmp    e5d <strchr+0x22>
    if(*s == c)
     e49:	8b 45 08             	mov    0x8(%ebp),%eax
     e4c:	0f b6 00             	movzbl (%eax),%eax
     e4f:	3a 45 fc             	cmp    -0x4(%ebp),%al
     e52:	75 05                	jne    e59 <strchr+0x1e>
      return (char*)s;
     e54:	8b 45 08             	mov    0x8(%ebp),%eax
     e57:	eb 13                	jmp    e6c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     e59:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     e5d:	8b 45 08             	mov    0x8(%ebp),%eax
     e60:	0f b6 00             	movzbl (%eax),%eax
     e63:	84 c0                	test   %al,%al
     e65:	75 e2                	jne    e49 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e6c:	c9                   	leave  
     e6d:	c3                   	ret    

00000e6e <gets>:

char*
gets(char *buf, int max)
{
     e6e:	55                   	push   %ebp
     e6f:	89 e5                	mov    %esp,%ebp
     e71:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e7b:	eb 4c                	jmp    ec9 <gets+0x5b>
    cc = read(0, &c, 1);
     e7d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e84:	00 
     e85:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e88:	89 44 24 04          	mov    %eax,0x4(%esp)
     e8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e93:	e8 63 02 00 00       	call   10fb <read>
     e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e9f:	7f 02                	jg     ea3 <gets+0x35>
      break;
     ea1:	eb 31                	jmp    ed4 <gets+0x66>
    buf[i++] = c;
     ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ea6:	8d 50 01             	lea    0x1(%eax),%edx
     ea9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     eac:	89 c2                	mov    %eax,%edx
     eae:	8b 45 08             	mov    0x8(%ebp),%eax
     eb1:	01 c2                	add    %eax,%edx
     eb3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     eb7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     eb9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     ebd:	3c 0a                	cmp    $0xa,%al
     ebf:	74 13                	je     ed4 <gets+0x66>
     ec1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     ec5:	3c 0d                	cmp    $0xd,%al
     ec7:	74 0b                	je     ed4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ecc:	83 c0 01             	add    $0x1,%eax
     ecf:	3b 45 0c             	cmp    0xc(%ebp),%eax
     ed2:	7c a9                	jl     e7d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     ed4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ed7:	8b 45 08             	mov    0x8(%ebp),%eax
     eda:	01 d0                	add    %edx,%eax
     edc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ee2:	c9                   	leave  
     ee3:	c3                   	ret    

00000ee4 <stat>:

int
stat(char *n, struct stat *st)
{
     ee4:	55                   	push   %ebp
     ee5:	89 e5                	mov    %esp,%ebp
     ee7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     eea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     ef1:	00 
     ef2:	8b 45 08             	mov    0x8(%ebp),%eax
     ef5:	89 04 24             	mov    %eax,(%esp)
     ef8:	e8 26 02 00 00       	call   1123 <open>
     efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f04:	79 07                	jns    f0d <stat+0x29>
    return -1;
     f06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f0b:	eb 23                	jmp    f30 <stat+0x4c>
  r = fstat(fd, st);
     f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
     f10:	89 44 24 04          	mov    %eax,0x4(%esp)
     f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f17:	89 04 24             	mov    %eax,(%esp)
     f1a:	e8 1c 02 00 00       	call   113b <fstat>
     f1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f25:	89 04 24             	mov    %eax,(%esp)
     f28:	e8 de 01 00 00       	call   110b <close>
  return r;
     f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f30:	c9                   	leave  
     f31:	c3                   	ret    

00000f32 <atoi>:

int
atoi(const char *s)
{
     f32:	55                   	push   %ebp
     f33:	89 e5                	mov    %esp,%ebp
     f35:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     f38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     f3f:	eb 25                	jmp    f66 <atoi+0x34>
    n = n*10 + *s++ - '0';
     f41:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f44:	89 d0                	mov    %edx,%eax
     f46:	c1 e0 02             	shl    $0x2,%eax
     f49:	01 d0                	add    %edx,%eax
     f4b:	01 c0                	add    %eax,%eax
     f4d:	89 c1                	mov    %eax,%ecx
     f4f:	8b 45 08             	mov    0x8(%ebp),%eax
     f52:	8d 50 01             	lea    0x1(%eax),%edx
     f55:	89 55 08             	mov    %edx,0x8(%ebp)
     f58:	0f b6 00             	movzbl (%eax),%eax
     f5b:	0f be c0             	movsbl %al,%eax
     f5e:	01 c8                	add    %ecx,%eax
     f60:	83 e8 30             	sub    $0x30,%eax
     f63:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f66:	8b 45 08             	mov    0x8(%ebp),%eax
     f69:	0f b6 00             	movzbl (%eax),%eax
     f6c:	3c 2f                	cmp    $0x2f,%al
     f6e:	7e 0a                	jle    f7a <atoi+0x48>
     f70:	8b 45 08             	mov    0x8(%ebp),%eax
     f73:	0f b6 00             	movzbl (%eax),%eax
     f76:	3c 39                	cmp    $0x39,%al
     f78:	7e c7                	jle    f41 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f7d:	c9                   	leave  
     f7e:	c3                   	ret    

00000f7f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f7f:	55                   	push   %ebp
     f80:	89 e5                	mov    %esp,%ebp
     f82:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f85:	8b 45 08             	mov    0x8(%ebp),%eax
     f88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f91:	eb 17                	jmp    faa <memmove+0x2b>
    *dst++ = *src++;
     f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f96:	8d 50 01             	lea    0x1(%eax),%edx
     f99:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f9c:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f9f:	8d 4a 01             	lea    0x1(%edx),%ecx
     fa2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     fa5:	0f b6 12             	movzbl (%edx),%edx
     fa8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     faa:	8b 45 10             	mov    0x10(%ebp),%eax
     fad:	8d 50 ff             	lea    -0x1(%eax),%edx
     fb0:	89 55 10             	mov    %edx,0x10(%ebp)
     fb3:	85 c0                	test   %eax,%eax
     fb5:	7f dc                	jg     f93 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
     fba:	c9                   	leave  
     fbb:	c3                   	ret    

00000fbc <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
     fbc:	55                   	push   %ebp
     fbd:	89 e5                	mov    %esp,%ebp
     fbf:	53                   	push   %ebx
     fc0:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
     fc3:	8b 45 08             	mov    0x8(%ebp),%eax
     fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
     fc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fcd:	79 03                	jns    fd2 <itoa+0x16>
         n = -n;          /* make n positive */
     fcf:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
     fd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
     fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fdc:	8d 50 01             	lea    0x1(%eax),%edx
     fdf:	89 55 f4             	mov    %edx,-0xc(%ebp)
     fe2:	89 c2                	mov    %eax,%edx
     fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
     fe7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
     fea:	8b 4d 08             	mov    0x8(%ebp),%ecx
     fed:	ba 67 66 66 66       	mov    $0x66666667,%edx
     ff2:	89 c8                	mov    %ecx,%eax
     ff4:	f7 ea                	imul   %edx
     ff6:	c1 fa 02             	sar    $0x2,%edx
     ff9:	89 c8                	mov    %ecx,%eax
     ffb:	c1 f8 1f             	sar    $0x1f,%eax
     ffe:	29 c2                	sub    %eax,%edx
    1000:	89 d0                	mov    %edx,%eax
    1002:	c1 e0 02             	shl    $0x2,%eax
    1005:	01 d0                	add    %edx,%eax
    1007:	01 c0                	add    %eax,%eax
    1009:	29 c1                	sub    %eax,%ecx
    100b:	89 ca                	mov    %ecx,%edx
    100d:	89 d0                	mov    %edx,%eax
    100f:	83 c0 30             	add    $0x30,%eax
    1012:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
    1014:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1017:	ba 67 66 66 66       	mov    $0x66666667,%edx
    101c:	89 c8                	mov    %ecx,%eax
    101e:	f7 ea                	imul   %edx
    1020:	c1 fa 02             	sar    $0x2,%edx
    1023:	89 c8                	mov    %ecx,%eax
    1025:	c1 f8 1f             	sar    $0x1f,%eax
    1028:	29 c2                	sub    %eax,%edx
    102a:	89 d0                	mov    %edx,%eax
    102c:	89 45 08             	mov    %eax,0x8(%ebp)
    102f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1033:	7f a4                	jg     fd9 <itoa+0x1d>
     if (sign < 0)
    1035:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1039:	79 13                	jns    104e <itoa+0x92>
         s[i++] = '-';
    103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    103e:	8d 50 01             	lea    0x1(%eax),%edx
    1041:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1044:	89 c2                	mov    %eax,%edx
    1046:	8b 45 0c             	mov    0xc(%ebp),%eax
    1049:	01 d0                	add    %edx,%eax
    104b:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
    104e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1051:	8b 45 0c             	mov    0xc(%ebp),%eax
    1054:	01 d0                	add    %edx,%eax
    1056:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
    1059:	8b 45 0c             	mov    0xc(%ebp),%eax
    105c:	89 04 24             	mov    %eax,(%esp)
    105f:	e8 ba fc ff ff       	call   d1e <reverse>
 }
    1064:	83 c4 24             	add    $0x24,%esp
    1067:	5b                   	pop    %ebx
    1068:	5d                   	pop    %ebp
    1069:	c3                   	ret    

0000106a <strcat>:

char *
strcat(char *dest, const char *src)
{
    106a:	55                   	push   %ebp
    106b:	89 e5                	mov    %esp,%ebp
    106d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
    1070:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1077:	eb 04                	jmp    107d <strcat+0x13>
    1079:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    107d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1080:	8b 45 08             	mov    0x8(%ebp),%eax
    1083:	01 d0                	add    %edx,%eax
    1085:	0f b6 00             	movzbl (%eax),%eax
    1088:	84 c0                	test   %al,%al
    108a:	75 ed                	jne    1079 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
    108c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    1093:	eb 20                	jmp    10b5 <strcat+0x4b>
        dest[i+j] = src[j];
    1095:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1098:	8b 55 fc             	mov    -0x4(%ebp),%edx
    109b:	01 d0                	add    %edx,%eax
    109d:	89 c2                	mov    %eax,%edx
    109f:	8b 45 08             	mov    0x8(%ebp),%eax
    10a2:	01 c2                	add    %eax,%edx
    10a4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    10a7:	8b 45 0c             	mov    0xc(%ebp),%eax
    10aa:	01 c8                	add    %ecx,%eax
    10ac:	0f b6 00             	movzbl (%eax),%eax
    10af:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
    10b1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    10b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
    10b8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10bb:	01 d0                	add    %edx,%eax
    10bd:	0f b6 00             	movzbl (%eax),%eax
    10c0:	84 c0                	test   %al,%al
    10c2:	75 d1                	jne    1095 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
    10c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10ca:	01 d0                	add    %edx,%eax
    10cc:	89 c2                	mov    %eax,%edx
    10ce:	8b 45 08             	mov    0x8(%ebp),%eax
    10d1:	01 d0                	add    %edx,%eax
    10d3:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
    10d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    10d9:	c9                   	leave  
    10da:	c3                   	ret    

000010db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    10db:	b8 01 00 00 00       	mov    $0x1,%eax
    10e0:	cd 40                	int    $0x40
    10e2:	c3                   	ret    

000010e3 <exit>:
SYSCALL(exit)
    10e3:	b8 02 00 00 00       	mov    $0x2,%eax
    10e8:	cd 40                	int    $0x40
    10ea:	c3                   	ret    

000010eb <wait>:
SYSCALL(wait)
    10eb:	b8 03 00 00 00       	mov    $0x3,%eax
    10f0:	cd 40                	int    $0x40
    10f2:	c3                   	ret    

000010f3 <pipe>:
SYSCALL(pipe)
    10f3:	b8 04 00 00 00       	mov    $0x4,%eax
    10f8:	cd 40                	int    $0x40
    10fa:	c3                   	ret    

000010fb <read>:
SYSCALL(read)
    10fb:	b8 05 00 00 00       	mov    $0x5,%eax
    1100:	cd 40                	int    $0x40
    1102:	c3                   	ret    

00001103 <write>:
SYSCALL(write)
    1103:	b8 10 00 00 00       	mov    $0x10,%eax
    1108:	cd 40                	int    $0x40
    110a:	c3                   	ret    

0000110b <close>:
SYSCALL(close)
    110b:	b8 15 00 00 00       	mov    $0x15,%eax
    1110:	cd 40                	int    $0x40
    1112:	c3                   	ret    

00001113 <kill>:
SYSCALL(kill)
    1113:	b8 06 00 00 00       	mov    $0x6,%eax
    1118:	cd 40                	int    $0x40
    111a:	c3                   	ret    

0000111b <exec>:
SYSCALL(exec)
    111b:	b8 07 00 00 00       	mov    $0x7,%eax
    1120:	cd 40                	int    $0x40
    1122:	c3                   	ret    

00001123 <open>:
SYSCALL(open)
    1123:	b8 0f 00 00 00       	mov    $0xf,%eax
    1128:	cd 40                	int    $0x40
    112a:	c3                   	ret    

0000112b <mknod>:
SYSCALL(mknod)
    112b:	b8 11 00 00 00       	mov    $0x11,%eax
    1130:	cd 40                	int    $0x40
    1132:	c3                   	ret    

00001133 <unlink>:
SYSCALL(unlink)
    1133:	b8 12 00 00 00       	mov    $0x12,%eax
    1138:	cd 40                	int    $0x40
    113a:	c3                   	ret    

0000113b <fstat>:
SYSCALL(fstat)
    113b:	b8 08 00 00 00       	mov    $0x8,%eax
    1140:	cd 40                	int    $0x40
    1142:	c3                   	ret    

00001143 <link>:
SYSCALL(link)
    1143:	b8 13 00 00 00       	mov    $0x13,%eax
    1148:	cd 40                	int    $0x40
    114a:	c3                   	ret    

0000114b <mkdir>:
SYSCALL(mkdir)
    114b:	b8 14 00 00 00       	mov    $0x14,%eax
    1150:	cd 40                	int    $0x40
    1152:	c3                   	ret    

00001153 <chdir>:
SYSCALL(chdir)
    1153:	b8 09 00 00 00       	mov    $0x9,%eax
    1158:	cd 40                	int    $0x40
    115a:	c3                   	ret    

0000115b <dup>:
SYSCALL(dup)
    115b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1160:	cd 40                	int    $0x40
    1162:	c3                   	ret    

00001163 <getpid>:
SYSCALL(getpid)
    1163:	b8 0b 00 00 00       	mov    $0xb,%eax
    1168:	cd 40                	int    $0x40
    116a:	c3                   	ret    

0000116b <sbrk>:
SYSCALL(sbrk)
    116b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1170:	cd 40                	int    $0x40
    1172:	c3                   	ret    

00001173 <sleep>:
SYSCALL(sleep)
    1173:	b8 0d 00 00 00       	mov    $0xd,%eax
    1178:	cd 40                	int    $0x40
    117a:	c3                   	ret    

0000117b <uptime>:
SYSCALL(uptime)
    117b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1180:	cd 40                	int    $0x40
    1182:	c3                   	ret    

00001183 <wait2>:
SYSCALL(wait2)
    1183:	b8 16 00 00 00       	mov    $0x16,%eax
    1188:	cd 40                	int    $0x40
    118a:	c3                   	ret    

0000118b <set_priority>:
SYSCALL(set_priority)
    118b:	b8 17 00 00 00       	mov    $0x17,%eax
    1190:	cd 40                	int    $0x40
    1192:	c3                   	ret    

00001193 <get_sched_record>:
SYSCALL(get_sched_record)
    1193:	b8 18 00 00 00       	mov    $0x18,%eax
    1198:	cd 40                	int    $0x40
    119a:	c3                   	ret    

0000119b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    119b:	55                   	push   %ebp
    119c:	89 e5                	mov    %esp,%ebp
    119e:	83 ec 18             	sub    $0x18,%esp
    11a1:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    11a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11ae:	00 
    11af:	8d 45 f4             	lea    -0xc(%ebp),%eax
    11b2:	89 44 24 04          	mov    %eax,0x4(%esp)
    11b6:	8b 45 08             	mov    0x8(%ebp),%eax
    11b9:	89 04 24             	mov    %eax,(%esp)
    11bc:	e8 42 ff ff ff       	call   1103 <write>
}
    11c1:	c9                   	leave  
    11c2:	c3                   	ret    

000011c3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    11c3:	55                   	push   %ebp
    11c4:	89 e5                	mov    %esp,%ebp
    11c6:	56                   	push   %esi
    11c7:	53                   	push   %ebx
    11c8:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    11cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    11d2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    11d6:	74 17                	je     11ef <printint+0x2c>
    11d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    11dc:	79 11                	jns    11ef <printint+0x2c>
    neg = 1;
    11de:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    11e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e8:	f7 d8                	neg    %eax
    11ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
    11ed:	eb 06                	jmp    11f5 <printint+0x32>
  } else {
    x = xx;
    11ef:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    11f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    11fc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    11ff:	8d 41 01             	lea    0x1(%ecx),%eax
    1202:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1205:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1208:	8b 45 ec             	mov    -0x14(%ebp),%eax
    120b:	ba 00 00 00 00       	mov    $0x0,%edx
    1210:	f7 f3                	div    %ebx
    1212:	89 d0                	mov    %edx,%eax
    1214:	0f b6 80 32 1c 00 00 	movzbl 0x1c32(%eax),%eax
    121b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    121f:	8b 75 10             	mov    0x10(%ebp),%esi
    1222:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1225:	ba 00 00 00 00       	mov    $0x0,%edx
    122a:	f7 f6                	div    %esi
    122c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    122f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1233:	75 c7                	jne    11fc <printint+0x39>
  if(neg)
    1235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1239:	74 10                	je     124b <printint+0x88>
    buf[i++] = '-';
    123b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    123e:	8d 50 01             	lea    0x1(%eax),%edx
    1241:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1244:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1249:	eb 1f                	jmp    126a <printint+0xa7>
    124b:	eb 1d                	jmp    126a <printint+0xa7>
    putc(fd, buf[i]);
    124d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1250:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1253:	01 d0                	add    %edx,%eax
    1255:	0f b6 00             	movzbl (%eax),%eax
    1258:	0f be c0             	movsbl %al,%eax
    125b:	89 44 24 04          	mov    %eax,0x4(%esp)
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	89 04 24             	mov    %eax,(%esp)
    1265:	e8 31 ff ff ff       	call   119b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    126a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    126e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1272:	79 d9                	jns    124d <printint+0x8a>
    putc(fd, buf[i]);
}
    1274:	83 c4 30             	add    $0x30,%esp
    1277:	5b                   	pop    %ebx
    1278:	5e                   	pop    %esi
    1279:	5d                   	pop    %ebp
    127a:	c3                   	ret    

0000127b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    127b:	55                   	push   %ebp
    127c:	89 e5                	mov    %esp,%ebp
    127e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1281:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1288:	8d 45 0c             	lea    0xc(%ebp),%eax
    128b:	83 c0 04             	add    $0x4,%eax
    128e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1291:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1298:	e9 7c 01 00 00       	jmp    1419 <printf+0x19e>
    c = fmt[i] & 0xff;
    129d:	8b 55 0c             	mov    0xc(%ebp),%edx
    12a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12a3:	01 d0                	add    %edx,%eax
    12a5:	0f b6 00             	movzbl (%eax),%eax
    12a8:	0f be c0             	movsbl %al,%eax
    12ab:	25 ff 00 00 00       	and    $0xff,%eax
    12b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    12b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12b7:	75 2c                	jne    12e5 <printf+0x6a>
      if(c == '%'){
    12b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    12bd:	75 0c                	jne    12cb <printf+0x50>
        state = '%';
    12bf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    12c6:	e9 4a 01 00 00       	jmp    1415 <printf+0x19a>
      } else {
        putc(fd, c);
    12cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12ce:	0f be c0             	movsbl %al,%eax
    12d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d5:	8b 45 08             	mov    0x8(%ebp),%eax
    12d8:	89 04 24             	mov    %eax,(%esp)
    12db:	e8 bb fe ff ff       	call   119b <putc>
    12e0:	e9 30 01 00 00       	jmp    1415 <printf+0x19a>
      }
    } else if(state == '%'){
    12e5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    12e9:	0f 85 26 01 00 00    	jne    1415 <printf+0x19a>
      if(c == 'd'){
    12ef:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    12f3:	75 2d                	jne    1322 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    12f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    12f8:	8b 00                	mov    (%eax),%eax
    12fa:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1301:	00 
    1302:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1309:	00 
    130a:	89 44 24 04          	mov    %eax,0x4(%esp)
    130e:	8b 45 08             	mov    0x8(%ebp),%eax
    1311:	89 04 24             	mov    %eax,(%esp)
    1314:	e8 aa fe ff ff       	call   11c3 <printint>
        ap++;
    1319:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    131d:	e9 ec 00 00 00       	jmp    140e <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1322:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1326:	74 06                	je     132e <printf+0xb3>
    1328:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    132c:	75 2d                	jne    135b <printf+0xe0>
        printint(fd, *ap, 16, 0);
    132e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1331:	8b 00                	mov    (%eax),%eax
    1333:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    133a:	00 
    133b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1342:	00 
    1343:	89 44 24 04          	mov    %eax,0x4(%esp)
    1347:	8b 45 08             	mov    0x8(%ebp),%eax
    134a:	89 04 24             	mov    %eax,(%esp)
    134d:	e8 71 fe ff ff       	call   11c3 <printint>
        ap++;
    1352:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1356:	e9 b3 00 00 00       	jmp    140e <printf+0x193>
      } else if(c == 's'){
    135b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    135f:	75 45                	jne    13a6 <printf+0x12b>
        s = (char*)*ap;
    1361:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1364:	8b 00                	mov    (%eax),%eax
    1366:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1369:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    136d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1371:	75 09                	jne    137c <printf+0x101>
          s = "(null)";
    1373:	c7 45 f4 38 17 00 00 	movl   $0x1738,-0xc(%ebp)
        while(*s != 0){
    137a:	eb 1e                	jmp    139a <printf+0x11f>
    137c:	eb 1c                	jmp    139a <printf+0x11f>
          putc(fd, *s);
    137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1381:	0f b6 00             	movzbl (%eax),%eax
    1384:	0f be c0             	movsbl %al,%eax
    1387:	89 44 24 04          	mov    %eax,0x4(%esp)
    138b:	8b 45 08             	mov    0x8(%ebp),%eax
    138e:	89 04 24             	mov    %eax,(%esp)
    1391:	e8 05 fe ff ff       	call   119b <putc>
          s++;
    1396:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    139a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139d:	0f b6 00             	movzbl (%eax),%eax
    13a0:	84 c0                	test   %al,%al
    13a2:	75 da                	jne    137e <printf+0x103>
    13a4:	eb 68                	jmp    140e <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13a6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    13aa:	75 1d                	jne    13c9 <printf+0x14e>
        putc(fd, *ap);
    13ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
    13af:	8b 00                	mov    (%eax),%eax
    13b1:	0f be c0             	movsbl %al,%eax
    13b4:	89 44 24 04          	mov    %eax,0x4(%esp)
    13b8:	8b 45 08             	mov    0x8(%ebp),%eax
    13bb:	89 04 24             	mov    %eax,(%esp)
    13be:	e8 d8 fd ff ff       	call   119b <putc>
        ap++;
    13c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    13c7:	eb 45                	jmp    140e <printf+0x193>
      } else if(c == '%'){
    13c9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    13cd:	75 17                	jne    13e6 <printf+0x16b>
        putc(fd, c);
    13cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    13d2:	0f be c0             	movsbl %al,%eax
    13d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    13d9:	8b 45 08             	mov    0x8(%ebp),%eax
    13dc:	89 04 24             	mov    %eax,(%esp)
    13df:	e8 b7 fd ff ff       	call   119b <putc>
    13e4:	eb 28                	jmp    140e <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    13e6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    13ed:	00 
    13ee:	8b 45 08             	mov    0x8(%ebp),%eax
    13f1:	89 04 24             	mov    %eax,(%esp)
    13f4:	e8 a2 fd ff ff       	call   119b <putc>
        putc(fd, c);
    13f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    13fc:	0f be c0             	movsbl %al,%eax
    13ff:	89 44 24 04          	mov    %eax,0x4(%esp)
    1403:	8b 45 08             	mov    0x8(%ebp),%eax
    1406:	89 04 24             	mov    %eax,(%esp)
    1409:	e8 8d fd ff ff       	call   119b <putc>
      }
      state = 0;
    140e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1415:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1419:	8b 55 0c             	mov    0xc(%ebp),%edx
    141c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    141f:	01 d0                	add    %edx,%eax
    1421:	0f b6 00             	movzbl (%eax),%eax
    1424:	84 c0                	test   %al,%al
    1426:	0f 85 71 fe ff ff    	jne    129d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    142c:	c9                   	leave  
    142d:	c3                   	ret    

0000142e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    142e:	55                   	push   %ebp
    142f:	89 e5                	mov    %esp,%ebp
    1431:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1434:	8b 45 08             	mov    0x8(%ebp),%eax
    1437:	83 e8 08             	sub    $0x8,%eax
    143a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    143d:	a1 cc 1c 00 00       	mov    0x1ccc,%eax
    1442:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1445:	eb 24                	jmp    146b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1447:	8b 45 fc             	mov    -0x4(%ebp),%eax
    144a:	8b 00                	mov    (%eax),%eax
    144c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    144f:	77 12                	ja     1463 <free+0x35>
    1451:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1457:	77 24                	ja     147d <free+0x4f>
    1459:	8b 45 fc             	mov    -0x4(%ebp),%eax
    145c:	8b 00                	mov    (%eax),%eax
    145e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1461:	77 1a                	ja     147d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1463:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1466:	8b 00                	mov    (%eax),%eax
    1468:	89 45 fc             	mov    %eax,-0x4(%ebp)
    146b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    146e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1471:	76 d4                	jbe    1447 <free+0x19>
    1473:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1476:	8b 00                	mov    (%eax),%eax
    1478:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    147b:	76 ca                	jbe    1447 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    147d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1480:	8b 40 04             	mov    0x4(%eax),%eax
    1483:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    148a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    148d:	01 c2                	add    %eax,%edx
    148f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1492:	8b 00                	mov    (%eax),%eax
    1494:	39 c2                	cmp    %eax,%edx
    1496:	75 24                	jne    14bc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1498:	8b 45 f8             	mov    -0x8(%ebp),%eax
    149b:	8b 50 04             	mov    0x4(%eax),%edx
    149e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14a1:	8b 00                	mov    (%eax),%eax
    14a3:	8b 40 04             	mov    0x4(%eax),%eax
    14a6:	01 c2                	add    %eax,%edx
    14a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    14ab:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    14ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14b1:	8b 00                	mov    (%eax),%eax
    14b3:	8b 10                	mov    (%eax),%edx
    14b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    14b8:	89 10                	mov    %edx,(%eax)
    14ba:	eb 0a                	jmp    14c6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    14bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14bf:	8b 10                	mov    (%eax),%edx
    14c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    14c4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    14c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14c9:	8b 40 04             	mov    0x4(%eax),%eax
    14cc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    14d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14d6:	01 d0                	add    %edx,%eax
    14d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    14db:	75 20                	jne    14fd <free+0xcf>
    p->s.size += bp->s.size;
    14dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14e0:	8b 50 04             	mov    0x4(%eax),%edx
    14e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    14e6:	8b 40 04             	mov    0x4(%eax),%eax
    14e9:	01 c2                	add    %eax,%edx
    14eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14ee:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    14f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    14f4:	8b 10                	mov    (%eax),%edx
    14f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    14f9:	89 10                	mov    %edx,(%eax)
    14fb:	eb 08                	jmp    1505 <free+0xd7>
  } else
    p->s.ptr = bp;
    14fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1500:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1503:	89 10                	mov    %edx,(%eax)
  freep = p;
    1505:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1508:	a3 cc 1c 00 00       	mov    %eax,0x1ccc
}
    150d:	c9                   	leave  
    150e:	c3                   	ret    

0000150f <morecore>:

static Header*
morecore(uint nu)
{
    150f:	55                   	push   %ebp
    1510:	89 e5                	mov    %esp,%ebp
    1512:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1515:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    151c:	77 07                	ja     1525 <morecore+0x16>
    nu = 4096;
    151e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1525:	8b 45 08             	mov    0x8(%ebp),%eax
    1528:	c1 e0 03             	shl    $0x3,%eax
    152b:	89 04 24             	mov    %eax,(%esp)
    152e:	e8 38 fc ff ff       	call   116b <sbrk>
    1533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1536:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    153a:	75 07                	jne    1543 <morecore+0x34>
    return 0;
    153c:	b8 00 00 00 00       	mov    $0x0,%eax
    1541:	eb 22                	jmp    1565 <morecore+0x56>
  hp = (Header*)p;
    1543:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1546:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1549:	8b 45 f0             	mov    -0x10(%ebp),%eax
    154c:	8b 55 08             	mov    0x8(%ebp),%edx
    154f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1552:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1555:	83 c0 08             	add    $0x8,%eax
    1558:	89 04 24             	mov    %eax,(%esp)
    155b:	e8 ce fe ff ff       	call   142e <free>
  return freep;
    1560:	a1 cc 1c 00 00       	mov    0x1ccc,%eax
}
    1565:	c9                   	leave  
    1566:	c3                   	ret    

00001567 <malloc>:

void*
malloc(uint nbytes)
{
    1567:	55                   	push   %ebp
    1568:	89 e5                	mov    %esp,%ebp
    156a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    156d:	8b 45 08             	mov    0x8(%ebp),%eax
    1570:	83 c0 07             	add    $0x7,%eax
    1573:	c1 e8 03             	shr    $0x3,%eax
    1576:	83 c0 01             	add    $0x1,%eax
    1579:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    157c:	a1 cc 1c 00 00       	mov    0x1ccc,%eax
    1581:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1584:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1588:	75 23                	jne    15ad <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    158a:	c7 45 f0 c4 1c 00 00 	movl   $0x1cc4,-0x10(%ebp)
    1591:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1594:	a3 cc 1c 00 00       	mov    %eax,0x1ccc
    1599:	a1 cc 1c 00 00       	mov    0x1ccc,%eax
    159e:	a3 c4 1c 00 00       	mov    %eax,0x1cc4
    base.s.size = 0;
    15a3:	c7 05 c8 1c 00 00 00 	movl   $0x0,0x1cc8
    15aa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15b0:	8b 00                	mov    (%eax),%eax
    15b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    15b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b8:	8b 40 04             	mov    0x4(%eax),%eax
    15bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    15be:	72 4d                	jb     160d <malloc+0xa6>
      if(p->s.size == nunits)
    15c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c3:	8b 40 04             	mov    0x4(%eax),%eax
    15c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    15c9:	75 0c                	jne    15d7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    15cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ce:	8b 10                	mov    (%eax),%edx
    15d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15d3:	89 10                	mov    %edx,(%eax)
    15d5:	eb 26                	jmp    15fd <malloc+0x96>
      else {
        p->s.size -= nunits;
    15d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15da:	8b 40 04             	mov    0x4(%eax),%eax
    15dd:	2b 45 ec             	sub    -0x14(%ebp),%eax
    15e0:	89 c2                	mov    %eax,%edx
    15e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15e5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    15e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15eb:	8b 40 04             	mov    0x4(%eax),%eax
    15ee:	c1 e0 03             	shl    $0x3,%eax
    15f1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    15f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    15fa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    15fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1600:	a3 cc 1c 00 00       	mov    %eax,0x1ccc
      return (void*)(p + 1);
    1605:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1608:	83 c0 08             	add    $0x8,%eax
    160b:	eb 38                	jmp    1645 <malloc+0xde>
    }
    if(p == freep)
    160d:	a1 cc 1c 00 00       	mov    0x1ccc,%eax
    1612:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1615:	75 1b                	jne    1632 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1617:	8b 45 ec             	mov    -0x14(%ebp),%eax
    161a:	89 04 24             	mov    %eax,(%esp)
    161d:	e8 ed fe ff ff       	call   150f <morecore>
    1622:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1629:	75 07                	jne    1632 <malloc+0xcb>
        return 0;
    162b:	b8 00 00 00 00       	mov    $0x0,%eax
    1630:	eb 13                	jmp    1645 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1632:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1635:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1638:	8b 45 f4             	mov    -0xc(%ebp),%eax
    163b:	8b 00                	mov    (%eax),%eax
    163d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1640:	e9 70 ff ff ff       	jmp    15b5 <malloc+0x4e>
}
    1645:	c9                   	leave  
    1646:	c3                   	ret    
