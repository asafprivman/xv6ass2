
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 60 c6 10 80       	mov    $0x8010c660,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b8 33 10 80       	mov    $0x801033b8,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 f4 81 10 	movl   $0x801081f4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 75 4b 00 00       	call   80104bc3 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 22 4b 00 00       	call   80104be4 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 3d 4b 00 00       	call   80104c46 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 ed 47 00 00       	call   80104911 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 c5 4a 00 00       	call   80104c46 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 fb 81 10 80 	movl   $0x801081fb,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 bc 25 00 00       	call   80102794 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 0c 82 10 80 	movl   $0x8010820c,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 7f 25 00 00       	call   80102794 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 13 82 10 80 	movl   $0x80108213,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 a3 49 00 00       	call   80104be4 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 4b 47 00 00       	call   801049ed <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 98 49 00 00       	call   80104c46 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bb:	e8 24 48 00 00       	call   80104be4 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 1a 82 10 80 	movl   $0x8010821a,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 23 82 10 80 	movl   $0x80108223,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100533:	e8 0e 47 00 00       	call   80104c46 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 2a 82 10 80 	movl   $0x8010822a,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 39 82 10 80 	movl   $0x80108239,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 01 47 00 00       	call   80104c95 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 3b 82 10 80 	movl   $0x8010823b,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 50 48 00 00       	call   80104f07 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 90 10 80       	mov    0x80109000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 52 47 00 00       	call   80104e38 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 cb 60 00 00       	call   80106846 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 bf 60 00 00       	call   80106846 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 b3 60 00 00       	call   80106846 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 a6 60 00 00       	call   80106846 <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801007ba:	e8 25 44 00 00       	call   80104be4 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 a4 42 00 00       	call   80104a93 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100816:	a1 58 de 10 80       	mov    0x8010de58,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100840:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010087c:	a1 54 de 10 80       	mov    0x8010de54,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 5c de 10 80    	mov    %edx,0x8010de5c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 d4 dd 10 80    	mov    %al,-0x7fef222c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008d5:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008e7:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008ec:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
801008f3:	e8 f5 40 00 00       	call   801049ed <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100914:	e8 2d 43 00 00       	call   80104c46 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 70 10 00 00       	call   8010199c <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100939:	e8 a6 42 00 00       	call   80104be4 <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100959:	e8 e8 42 00 00       	call   80104c46 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 e5 0e 00 00       	call   8010184e <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100982:	e8 8a 3f 00 00       	call   80104911 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
8010098d:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 54 de 10 80    	mov    %edx,0x8010de54
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801009fe:	e8 43 42 00 00       	call   80104c46 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 40 0e 00 00       	call   8010184e <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 71 0f 00 00       	call   8010199c <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a32:	e8 ad 41 00 00       	call   80104be4 <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a6c:	e8 d5 41 00 00       	call   80104c46 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 d2 0d 00 00       	call   8010184e <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 3f 82 10 	movl   $0x8010823f,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a96:	e8 28 41 00 00       	call   80104bc3 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 47 82 10 	movl   $0x80108247,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100aaa:	e8 14 41 00 00       	call   80104bc3 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 0c e8 10 80 1a 	movl   $0x80100a1a,0x8010e80c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 08 e8 10 80 1b 	movl   $0x8010091b,0x8010e808
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 8c 2f 00 00       	call   80103a65 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 63 1e 00 00       	call   80102950 <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100aef:	55                   	push   %ebp
80100af0:	89 e5                	mov    %esp,%ebp
80100af2:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100af8:	8b 45 08             	mov    0x8(%ebp),%eax
80100afb:	89 04 24             	mov    %eax,(%esp)
80100afe:	e8 f6 18 00 00       	call   801023f9 <namei>
80100b03:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b06:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0a:	75 0a                	jne    80100b16 <exec+0x27>
    return -1;
80100b0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b11:	e9 e5 03 00 00       	jmp    80100efb <exec+0x40c>
  ilock(ip);
80100b16:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b19:	89 04 24             	mov    %eax,(%esp)
80100b1c:	e8 2d 0d 00 00       	call   8010184e <ilock>
  pgdir = 0;
80100b21:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b28:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b2f:	00 
80100b30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b37:	00 
80100b38:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b42:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b45:	89 04 24             	mov    %eax,(%esp)
80100b48:	e8 0e 12 00 00       	call   80101d5b <readi>
80100b4d:	83 f8 33             	cmp    $0x33,%eax
80100b50:	77 05                	ja     80100b57 <exec+0x68>
    goto bad;
80100b52:	e9 7d 03 00 00       	jmp    80100ed4 <exec+0x3e5>
  if(elf.magic != ELF_MAGIC)
80100b57:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b5d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b62:	74 05                	je     80100b69 <exec+0x7a>
    goto bad;
80100b64:	e9 6b 03 00 00       	jmp    80100ed4 <exec+0x3e5>

  if((pgdir = setupkvm(kalloc)) == 0)
80100b69:	c7 04 24 d5 2a 10 80 	movl   $0x80102ad5,(%esp)
80100b70:	e8 22 6e 00 00       	call   80107997 <setupkvm>
80100b75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b78:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b7c:	75 05                	jne    80100b83 <exec+0x94>
    goto bad;
80100b7e:	e9 51 03 00 00       	jmp    80100ed4 <exec+0x3e5>

  // Load program into memory.
  sz = 0;
80100b83:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b91:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b97:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b9a:	e9 cb 00 00 00       	jmp    80100c6a <exec+0x17b>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ba2:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100ba9:	00 
80100baa:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bae:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bbb:	89 04 24             	mov    %eax,(%esp)
80100bbe:	e8 98 11 00 00       	call   80101d5b <readi>
80100bc3:	83 f8 20             	cmp    $0x20,%eax
80100bc6:	74 05                	je     80100bcd <exec+0xde>
      goto bad;
80100bc8:	e9 07 03 00 00       	jmp    80100ed4 <exec+0x3e5>
    if(ph.type != ELF_PROG_LOAD)
80100bcd:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bd3:	83 f8 01             	cmp    $0x1,%eax
80100bd6:	74 05                	je     80100bdd <exec+0xee>
      continue;
80100bd8:	e9 80 00 00 00       	jmp    80100c5d <exec+0x16e>
    if(ph.memsz < ph.filesz)
80100bdd:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be3:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100be9:	39 c2                	cmp    %eax,%edx
80100beb:	73 05                	jae    80100bf2 <exec+0x103>
      goto bad;
80100bed:	e9 e2 02 00 00       	jmp    80100ed4 <exec+0x3e5>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf2:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bf8:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100bfe:	01 d0                	add    %edx,%eax
80100c00:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c0e:	89 04 24             	mov    %eax,(%esp)
80100c11:	e8 4f 71 00 00       	call   80107d65 <allocuvm>
80100c16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c19:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c1d:	75 05                	jne    80100c24 <exec+0x135>
      goto bad;
80100c1f:	e9 b0 02 00 00       	jmp    80100ed4 <exec+0x3e5>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c24:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c2a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c30:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c36:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c3a:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c3e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c41:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c45:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c4c:	89 04 24             	mov    %eax,(%esp)
80100c4f:	e8 26 70 00 00       	call   80107c7a <loaduvm>
80100c54:	85 c0                	test   %eax,%eax
80100c56:	79 05                	jns    80100c5d <exec+0x16e>
      goto bad;
80100c58:	e9 77 02 00 00       	jmp    80100ed4 <exec+0x3e5>
  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c5d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c61:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c64:	83 c0 20             	add    $0x20,%eax
80100c67:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6a:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c71:	0f b7 c0             	movzwl %ax,%eax
80100c74:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c77:	0f 8f 22 ff ff ff    	jg     80100b9f <exec+0xb0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c80:	89 04 24             	mov    %eax,(%esp)
80100c83:	e8 4a 0e 00 00       	call   80101ad2 <iunlockput>
  ip = 0;
80100c88:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c92:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca2:	05 00 20 00 00       	add    $0x2000,%eax
80100ca7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cae:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cb5:	89 04 24             	mov    %eax,(%esp)
80100cb8:	e8 a8 70 00 00       	call   80107d65 <allocuvm>
80100cbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cc4:	75 05                	jne    80100ccb <exec+0x1dc>
    goto bad;
80100cc6:	e9 09 02 00 00       	jmp    80100ed4 <exec+0x3e5>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cce:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cda:	89 04 24             	mov    %eax,(%esp)
80100cdd:	e8 b3 72 00 00       	call   80107f95 <clearpteu>
  sp = sz;
80100ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce5:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cef:	e9 9a 00 00 00       	jmp    80100d8e <exec+0x29f>
    if(argc >= MAXARG)
80100cf4:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100cf8:	76 05                	jbe    80100cff <exec+0x210>
      goto bad;
80100cfa:	e9 d5 01 00 00       	jmp    80100ed4 <exec+0x3e5>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d09:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d0c:	01 d0                	add    %edx,%eax
80100d0e:	8b 00                	mov    (%eax),%eax
80100d10:	89 04 24             	mov    %eax,(%esp)
80100d13:	e8 8a 43 00 00       	call   801050a2 <strlen>
80100d18:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d1b:	29 c2                	sub    %eax,%edx
80100d1d:	89 d0                	mov    %edx,%eax
80100d1f:	83 e8 01             	sub    $0x1,%eax
80100d22:	83 e0 fc             	and    $0xfffffffc,%eax
80100d25:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d32:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d35:	01 d0                	add    %edx,%eax
80100d37:	8b 00                	mov    (%eax),%eax
80100d39:	89 04 24             	mov    %eax,(%esp)
80100d3c:	e8 61 43 00 00       	call   801050a2 <strlen>
80100d41:	83 c0 01             	add    $0x1,%eax
80100d44:	89 c2                	mov    %eax,%edx
80100d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d49:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d50:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d53:	01 c8                	add    %ecx,%eax
80100d55:	8b 00                	mov    (%eax),%eax
80100d57:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d5b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d62:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d69:	89 04 24             	mov    %eax,(%esp)
80100d6c:	e8 d8 73 00 00       	call   80108149 <copyout>
80100d71:	85 c0                	test   %eax,%eax
80100d73:	79 05                	jns    80100d7a <exec+0x28b>
      goto bad;
80100d75:	e9 5a 01 00 00       	jmp    80100ed4 <exec+0x3e5>
    ustack[3+argc] = sp;
80100d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7d:	8d 50 03             	lea    0x3(%eax),%edx
80100d80:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d83:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d8a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d98:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9b:	01 d0                	add    %edx,%eax
80100d9d:	8b 00                	mov    (%eax),%eax
80100d9f:	85 c0                	test   %eax,%eax
80100da1:	0f 85 4d ff ff ff    	jne    80100cf4 <exec+0x205>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100daa:	83 c0 03             	add    $0x3,%eax
80100dad:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100db4:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100db8:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dbf:	ff ff ff 
  ustack[1] = argc;
80100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc5:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dce:	83 c0 01             	add    $0x1,%eax
80100dd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ddb:	29 d0                	sub    %edx,%eax
80100ddd:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de6:	83 c0 04             	add    $0x4,%eax
80100de9:	c1 e0 02             	shl    $0x2,%eax
80100dec:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df2:	83 c0 04             	add    $0x4,%eax
80100df5:	c1 e0 02             	shl    $0x2,%eax
80100df8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100dfc:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e02:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e06:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e09:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e10:	89 04 24             	mov    %eax,(%esp)
80100e13:	e8 31 73 00 00       	call   80108149 <copyout>
80100e18:	85 c0                	test   %eax,%eax
80100e1a:	79 05                	jns    80100e21 <exec+0x332>
    goto bad;
80100e1c:	e9 b3 00 00 00       	jmp    80100ed4 <exec+0x3e5>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e21:	8b 45 08             	mov    0x8(%ebp),%eax
80100e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e2d:	eb 17                	jmp    80100e46 <exec+0x357>
    if(*s == '/')
80100e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e32:	0f b6 00             	movzbl (%eax),%eax
80100e35:	3c 2f                	cmp    $0x2f,%al
80100e37:	75 09                	jne    80100e42 <exec+0x353>
      last = s+1;
80100e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3c:	83 c0 01             	add    $0x1,%eax
80100e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e49:	0f b6 00             	movzbl (%eax),%eax
80100e4c:	84 c0                	test   %al,%al
80100e4e:	75 df                	jne    80100e2f <exec+0x340>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e56:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e59:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e60:	00 
80100e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e64:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e68:	89 14 24             	mov    %edx,(%esp)
80100e6b:	e8 e8 41 00 00       	call   80105058 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e76:	8b 40 04             	mov    0x4(%eax),%eax
80100e79:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e82:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e85:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e91:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e99:	8b 40 18             	mov    0x18(%eax),%eax
80100e9c:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ea2:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ea5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eab:	8b 40 18             	mov    0x18(%eax),%eax
80100eae:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eb1:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100eb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eba:	89 04 24             	mov    %eax,(%esp)
80100ebd:	e8 c6 6b 00 00       	call   80107a88 <switchuvm>
  freevm(oldpgdir);
80100ec2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ec5:	89 04 24             	mov    %eax,(%esp)
80100ec8:	e8 2e 70 00 00       	call   80107efb <freevm>
  return 0;
80100ecd:	b8 00 00 00 00       	mov    $0x0,%eax
80100ed2:	eb 27                	jmp    80100efb <exec+0x40c>

 bad:
  if(pgdir)
80100ed4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ed8:	74 0b                	je     80100ee5 <exec+0x3f6>
    freevm(pgdir);
80100eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100edd:	89 04 24             	mov    %eax,(%esp)
80100ee0:	e8 16 70 00 00       	call   80107efb <freevm>
  if(ip)
80100ee5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ee9:	74 0b                	je     80100ef6 <exec+0x407>
    iunlockput(ip);
80100eeb:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100eee:	89 04 24             	mov    %eax,(%esp)
80100ef1:	e8 dc 0b 00 00       	call   80101ad2 <iunlockput>
  return -1;
80100ef6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100efb:	c9                   	leave  
80100efc:	c3                   	ret    

80100efd <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100efd:	55                   	push   %ebp
80100efe:	89 e5                	mov    %esp,%ebp
80100f00:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f03:	c7 44 24 04 4d 82 10 	movl   $0x8010824d,0x4(%esp)
80100f0a:	80 
80100f0b:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f12:	e8 ac 3c 00 00       	call   80104bc3 <initlock>
}
80100f17:	c9                   	leave  
80100f18:	c3                   	ret    

80100f19 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f19:	55                   	push   %ebp
80100f1a:	89 e5                	mov    %esp,%ebp
80100f1c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f1f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f26:	e8 b9 3c 00 00       	call   80104be4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f2b:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f32:	eb 29                	jmp    80100f5d <filealloc+0x44>
    if(f->ref == 0){
80100f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f37:	8b 40 04             	mov    0x4(%eax),%eax
80100f3a:	85 c0                	test   %eax,%eax
80100f3c:	75 1b                	jne    80100f59 <filealloc+0x40>
      f->ref = 1;
80100f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f41:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f48:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f4f:	e8 f2 3c 00 00       	call   80104c46 <release>
      return f;
80100f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f57:	eb 1e                	jmp    80100f77 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f59:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f5d:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
80100f64:	72 ce                	jb     80100f34 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f66:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f6d:	e8 d4 3c 00 00       	call   80104c46 <release>
  return 0;
80100f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f77:	c9                   	leave  
80100f78:	c3                   	ret    

80100f79 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f79:	55                   	push   %ebp
80100f7a:	89 e5                	mov    %esp,%ebp
80100f7c:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f7f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f86:	e8 59 3c 00 00       	call   80104be4 <acquire>
  if(f->ref < 1)
80100f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f8e:	8b 40 04             	mov    0x4(%eax),%eax
80100f91:	85 c0                	test   %eax,%eax
80100f93:	7f 0c                	jg     80100fa1 <filedup+0x28>
    panic("filedup");
80100f95:	c7 04 24 54 82 10 80 	movl   $0x80108254,(%esp)
80100f9c:	e8 99 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa4:	8b 40 04             	mov    0x4(%eax),%eax
80100fa7:	8d 50 01             	lea    0x1(%eax),%edx
80100faa:	8b 45 08             	mov    0x8(%ebp),%eax
80100fad:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb0:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fb7:	e8 8a 3c 00 00       	call   80104c46 <release>
  return f;
80100fbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fbf:	c9                   	leave  
80100fc0:	c3                   	ret    

80100fc1 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fc1:	55                   	push   %ebp
80100fc2:	89 e5                	mov    %esp,%ebp
80100fc4:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fc7:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fce:	e8 11 3c 00 00       	call   80104be4 <acquire>
  if(f->ref < 1)
80100fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd6:	8b 40 04             	mov    0x4(%eax),%eax
80100fd9:	85 c0                	test   %eax,%eax
80100fdb:	7f 0c                	jg     80100fe9 <fileclose+0x28>
    panic("fileclose");
80100fdd:	c7 04 24 5c 82 10 80 	movl   $0x8010825c,(%esp)
80100fe4:	e8 51 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80100fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fec:	8b 40 04             	mov    0x4(%eax),%eax
80100fef:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff5:	89 50 04             	mov    %edx,0x4(%eax)
80100ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffb:	8b 40 04             	mov    0x4(%eax),%eax
80100ffe:	85 c0                	test   %eax,%eax
80101000:	7e 11                	jle    80101013 <fileclose+0x52>
    release(&ftable.lock);
80101002:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101009:	e8 38 3c 00 00       	call   80104c46 <release>
8010100e:	e9 82 00 00 00       	jmp    80101095 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101013:	8b 45 08             	mov    0x8(%ebp),%eax
80101016:	8b 10                	mov    (%eax),%edx
80101018:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010101b:	8b 50 04             	mov    0x4(%eax),%edx
8010101e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101021:	8b 50 08             	mov    0x8(%eax),%edx
80101024:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101027:	8b 50 0c             	mov    0xc(%eax),%edx
8010102a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010102d:	8b 50 10             	mov    0x10(%eax),%edx
80101030:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101033:	8b 40 14             	mov    0x14(%eax),%eax
80101036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101039:	8b 45 08             	mov    0x8(%ebp),%eax
8010103c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101043:	8b 45 08             	mov    0x8(%ebp),%eax
80101046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010104c:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101053:	e8 ee 3b 00 00       	call   80104c46 <release>
  
  if(ff.type == FD_PIPE)
80101058:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010105b:	83 f8 01             	cmp    $0x1,%eax
8010105e:	75 18                	jne    80101078 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101060:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101064:	0f be d0             	movsbl %al,%edx
80101067:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010106a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010106e:	89 04 24             	mov    %eax,(%esp)
80101071:	e8 9f 2c 00 00       	call   80103d15 <pipeclose>
80101076:	eb 1d                	jmp    80101095 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101078:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107b:	83 f8 02             	cmp    $0x2,%eax
8010107e:	75 15                	jne    80101095 <fileclose+0xd4>
    begin_trans();
80101080:	e8 53 21 00 00       	call   801031d8 <begin_trans>
    iput(ff.ip);
80101085:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101088:	89 04 24             	mov    %eax,(%esp)
8010108b:	e8 71 09 00 00       	call   80101a01 <iput>
    commit_trans();
80101090:	e8 8c 21 00 00       	call   80103221 <commit_trans>
  }
}
80101095:	c9                   	leave  
80101096:	c3                   	ret    

80101097 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101097:	55                   	push   %ebp
80101098:	89 e5                	mov    %esp,%ebp
8010109a:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
8010109d:	8b 45 08             	mov    0x8(%ebp),%eax
801010a0:	8b 00                	mov    (%eax),%eax
801010a2:	83 f8 02             	cmp    $0x2,%eax
801010a5:	75 38                	jne    801010df <filestat+0x48>
    ilock(f->ip);
801010a7:	8b 45 08             	mov    0x8(%ebp),%eax
801010aa:	8b 40 10             	mov    0x10(%eax),%eax
801010ad:	89 04 24             	mov    %eax,(%esp)
801010b0:	e8 99 07 00 00       	call   8010184e <ilock>
    stati(f->ip, st);
801010b5:	8b 45 08             	mov    0x8(%ebp),%eax
801010b8:	8b 40 10             	mov    0x10(%eax),%eax
801010bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801010be:	89 54 24 04          	mov    %edx,0x4(%esp)
801010c2:	89 04 24             	mov    %eax,(%esp)
801010c5:	e8 4c 0c 00 00       	call   80101d16 <stati>
    iunlock(f->ip);
801010ca:	8b 45 08             	mov    0x8(%ebp),%eax
801010cd:	8b 40 10             	mov    0x10(%eax),%eax
801010d0:	89 04 24             	mov    %eax,(%esp)
801010d3:	e8 c4 08 00 00       	call   8010199c <iunlock>
    return 0;
801010d8:	b8 00 00 00 00       	mov    $0x0,%eax
801010dd:	eb 05                	jmp    801010e4 <filestat+0x4d>
  }
  return -1;
801010df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e4:	c9                   	leave  
801010e5:	c3                   	ret    

801010e6 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010e6:	55                   	push   %ebp
801010e7:	89 e5                	mov    %esp,%ebp
801010e9:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010ec:	8b 45 08             	mov    0x8(%ebp),%eax
801010ef:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801010f3:	84 c0                	test   %al,%al
801010f5:	75 0a                	jne    80101101 <fileread+0x1b>
    return -1;
801010f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010fc:	e9 9f 00 00 00       	jmp    801011a0 <fileread+0xba>
  if(f->type == FD_PIPE)
80101101:	8b 45 08             	mov    0x8(%ebp),%eax
80101104:	8b 00                	mov    (%eax),%eax
80101106:	83 f8 01             	cmp    $0x1,%eax
80101109:	75 1e                	jne    80101129 <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010110b:	8b 45 08             	mov    0x8(%ebp),%eax
8010110e:	8b 40 0c             	mov    0xc(%eax),%eax
80101111:	8b 55 10             	mov    0x10(%ebp),%edx
80101114:	89 54 24 08          	mov    %edx,0x8(%esp)
80101118:	8b 55 0c             	mov    0xc(%ebp),%edx
8010111b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010111f:	89 04 24             	mov    %eax,(%esp)
80101122:	e8 6f 2d 00 00       	call   80103e96 <piperead>
80101127:	eb 77                	jmp    801011a0 <fileread+0xba>
  if(f->type == FD_INODE){
80101129:	8b 45 08             	mov    0x8(%ebp),%eax
8010112c:	8b 00                	mov    (%eax),%eax
8010112e:	83 f8 02             	cmp    $0x2,%eax
80101131:	75 61                	jne    80101194 <fileread+0xae>
    ilock(f->ip);
80101133:	8b 45 08             	mov    0x8(%ebp),%eax
80101136:	8b 40 10             	mov    0x10(%eax),%eax
80101139:	89 04 24             	mov    %eax,(%esp)
8010113c:	e8 0d 07 00 00       	call   8010184e <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101141:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101144:	8b 45 08             	mov    0x8(%ebp),%eax
80101147:	8b 50 14             	mov    0x14(%eax),%edx
8010114a:	8b 45 08             	mov    0x8(%ebp),%eax
8010114d:	8b 40 10             	mov    0x10(%eax),%eax
80101150:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101154:	89 54 24 08          	mov    %edx,0x8(%esp)
80101158:	8b 55 0c             	mov    0xc(%ebp),%edx
8010115b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010115f:	89 04 24             	mov    %eax,(%esp)
80101162:	e8 f4 0b 00 00       	call   80101d5b <readi>
80101167:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010116a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010116e:	7e 11                	jle    80101181 <fileread+0x9b>
      f->off += r;
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	8b 50 14             	mov    0x14(%eax),%edx
80101176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101179:	01 c2                	add    %eax,%edx
8010117b:	8b 45 08             	mov    0x8(%ebp),%eax
8010117e:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101181:	8b 45 08             	mov    0x8(%ebp),%eax
80101184:	8b 40 10             	mov    0x10(%eax),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 0d 08 00 00       	call   8010199c <iunlock>
    return r;
8010118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101192:	eb 0c                	jmp    801011a0 <fileread+0xba>
  }
  panic("fileread");
80101194:	c7 04 24 66 82 10 80 	movl   $0x80108266,(%esp)
8010119b:	e8 9a f3 ff ff       	call   8010053a <panic>
}
801011a0:	c9                   	leave  
801011a1:	c3                   	ret    

801011a2 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a2:	55                   	push   %ebp
801011a3:	89 e5                	mov    %esp,%ebp
801011a5:	53                   	push   %ebx
801011a6:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011a9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ac:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011b0:	84 c0                	test   %al,%al
801011b2:	75 0a                	jne    801011be <filewrite+0x1c>
    return -1;
801011b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011b9:	e9 20 01 00 00       	jmp    801012de <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011be:	8b 45 08             	mov    0x8(%ebp),%eax
801011c1:	8b 00                	mov    (%eax),%eax
801011c3:	83 f8 01             	cmp    $0x1,%eax
801011c6:	75 21                	jne    801011e9 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011c8:	8b 45 08             	mov    0x8(%ebp),%eax
801011cb:	8b 40 0c             	mov    0xc(%eax),%eax
801011ce:	8b 55 10             	mov    0x10(%ebp),%edx
801011d1:	89 54 24 08          	mov    %edx,0x8(%esp)
801011d5:	8b 55 0c             	mov    0xc(%ebp),%edx
801011d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801011dc:	89 04 24             	mov    %eax,(%esp)
801011df:	e8 c3 2b 00 00       	call   80103da7 <pipewrite>
801011e4:	e9 f5 00 00 00       	jmp    801012de <filewrite+0x13c>
  if(f->type == FD_INODE){
801011e9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ec:	8b 00                	mov    (%eax),%eax
801011ee:	83 f8 02             	cmp    $0x2,%eax
801011f1:	0f 85 db 00 00 00    	jne    801012d2 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011f7:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801011fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101205:	e9 a8 00 00 00       	jmp    801012b2 <filewrite+0x110>
      int n1 = n - i;
8010120a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010120d:	8b 55 10             	mov    0x10(%ebp),%edx
80101210:	29 c2                	sub    %eax,%edx
80101212:	89 d0                	mov    %edx,%eax
80101214:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101217:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010121a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010121d:	7e 06                	jle    80101225 <filewrite+0x83>
        n1 = max;
8010121f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101222:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
80101225:	e8 ae 1f 00 00       	call   801031d8 <begin_trans>
      ilock(f->ip);
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	8b 40 10             	mov    0x10(%eax),%eax
80101230:	89 04 24             	mov    %eax,(%esp)
80101233:	e8 16 06 00 00       	call   8010184e <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101238:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010123b:	8b 45 08             	mov    0x8(%ebp),%eax
8010123e:	8b 50 14             	mov    0x14(%eax),%edx
80101241:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101244:	8b 45 0c             	mov    0xc(%ebp),%eax
80101247:	01 c3                	add    %eax,%ebx
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 40 10             	mov    0x10(%eax),%eax
8010124f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101253:	89 54 24 08          	mov    %edx,0x8(%esp)
80101257:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010125b:	89 04 24             	mov    %eax,(%esp)
8010125e:	e8 5c 0c 00 00       	call   80101ebf <writei>
80101263:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101266:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010126a:	7e 11                	jle    8010127d <filewrite+0xdb>
        f->off += r;
8010126c:	8b 45 08             	mov    0x8(%ebp),%eax
8010126f:	8b 50 14             	mov    0x14(%eax),%edx
80101272:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101275:	01 c2                	add    %eax,%edx
80101277:	8b 45 08             	mov    0x8(%ebp),%eax
8010127a:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010127d:	8b 45 08             	mov    0x8(%ebp),%eax
80101280:	8b 40 10             	mov    0x10(%eax),%eax
80101283:	89 04 24             	mov    %eax,(%esp)
80101286:	e8 11 07 00 00       	call   8010199c <iunlock>
      commit_trans();
8010128b:	e8 91 1f 00 00       	call   80103221 <commit_trans>

      if(r < 0)
80101290:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101294:	79 02                	jns    80101298 <filewrite+0xf6>
        break;
80101296:	eb 26                	jmp    801012be <filewrite+0x11c>
      if(r != n1)
80101298:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010129b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010129e:	74 0c                	je     801012ac <filewrite+0x10a>
        panic("short filewrite");
801012a0:	c7 04 24 6f 82 10 80 	movl   $0x8010826f,(%esp)
801012a7:	e8 8e f2 ff ff       	call   8010053a <panic>
      i += r;
801012ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012af:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801012b8:	0f 8c 4c ff ff ff    	jl     8010120a <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c1:	3b 45 10             	cmp    0x10(%ebp),%eax
801012c4:	75 05                	jne    801012cb <filewrite+0x129>
801012c6:	8b 45 10             	mov    0x10(%ebp),%eax
801012c9:	eb 05                	jmp    801012d0 <filewrite+0x12e>
801012cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012d0:	eb 0c                	jmp    801012de <filewrite+0x13c>
  }
  panic("filewrite");
801012d2:	c7 04 24 7f 82 10 80 	movl   $0x8010827f,(%esp)
801012d9:	e8 5c f2 ff ff       	call   8010053a <panic>
}
801012de:	83 c4 24             	add    $0x24,%esp
801012e1:	5b                   	pop    %ebx
801012e2:	5d                   	pop    %ebp
801012e3:	c3                   	ret    

801012e4 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012e4:	55                   	push   %ebp
801012e5:	89 e5                	mov    %esp,%ebp
801012e7:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012ea:	8b 45 08             	mov    0x8(%ebp),%eax
801012ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012f4:	00 
801012f5:	89 04 24             	mov    %eax,(%esp)
801012f8:	e8 a9 ee ff ff       	call   801001a6 <bread>
801012fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101300:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101303:	83 c0 18             	add    $0x18,%eax
80101306:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010130d:	00 
8010130e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101312:	8b 45 0c             	mov    0xc(%ebp),%eax
80101315:	89 04 24             	mov    %eax,(%esp)
80101318:	e8 ea 3b 00 00       	call   80104f07 <memmove>
  brelse(bp);
8010131d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 ef ee ff ff       	call   80100217 <brelse>
}
80101328:	c9                   	leave  
80101329:	c3                   	ret    

8010132a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010132a:	55                   	push   %ebp
8010132b:	89 e5                	mov    %esp,%ebp
8010132d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101330:	8b 55 0c             	mov    0xc(%ebp),%edx
80101333:	8b 45 08             	mov    0x8(%ebp),%eax
80101336:	89 54 24 04          	mov    %edx,0x4(%esp)
8010133a:	89 04 24             	mov    %eax,(%esp)
8010133d:	e8 64 ee ff ff       	call   801001a6 <bread>
80101342:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101348:	83 c0 18             	add    $0x18,%eax
8010134b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101352:	00 
80101353:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010135a:	00 
8010135b:	89 04 24             	mov    %eax,(%esp)
8010135e:	e8 d5 3a 00 00       	call   80104e38 <memset>
  log_write(bp);
80101363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101366:	89 04 24             	mov    %eax,(%esp)
80101369:	e8 0b 1f 00 00       	call   80103279 <log_write>
  brelse(bp);
8010136e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101371:	89 04 24             	mov    %eax,(%esp)
80101374:	e8 9e ee ff ff       	call   80100217 <brelse>
}
80101379:	c9                   	leave  
8010137a:	c3                   	ret    

8010137b <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010137b:	55                   	push   %ebp
8010137c:	89 e5                	mov    %esp,%ebp
8010137e:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101388:	8b 45 08             	mov    0x8(%ebp),%eax
8010138b:	8d 55 d8             	lea    -0x28(%ebp),%edx
8010138e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101392:	89 04 24             	mov    %eax,(%esp)
80101395:	e8 4a ff ff ff       	call   801012e4 <readsb>
  for(b = 0; b < sb.size; b += BPB){
8010139a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013a1:	e9 07 01 00 00       	jmp    801014ad <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a9:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013af:	85 c0                	test   %eax,%eax
801013b1:	0f 48 c2             	cmovs  %edx,%eax
801013b4:	c1 f8 0c             	sar    $0xc,%eax
801013b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013ba:	c1 ea 03             	shr    $0x3,%edx
801013bd:	01 d0                	add    %edx,%eax
801013bf:	83 c0 03             	add    $0x3,%eax
801013c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801013c6:	8b 45 08             	mov    0x8(%ebp),%eax
801013c9:	89 04 24             	mov    %eax,(%esp)
801013cc:	e8 d5 ed ff ff       	call   801001a6 <bread>
801013d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013db:	e9 9d 00 00 00       	jmp    8010147d <balloc+0x102>
      m = 1 << (bi % 8);
801013e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013e3:	99                   	cltd   
801013e4:	c1 ea 1d             	shr    $0x1d,%edx
801013e7:	01 d0                	add    %edx,%eax
801013e9:	83 e0 07             	and    $0x7,%eax
801013ec:	29 d0                	sub    %edx,%eax
801013ee:	ba 01 00 00 00       	mov    $0x1,%edx
801013f3:	89 c1                	mov    %eax,%ecx
801013f5:	d3 e2                	shl    %cl,%edx
801013f7:	89 d0                	mov    %edx,%eax
801013f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013ff:	8d 50 07             	lea    0x7(%eax),%edx
80101402:	85 c0                	test   %eax,%eax
80101404:	0f 48 c2             	cmovs  %edx,%eax
80101407:	c1 f8 03             	sar    $0x3,%eax
8010140a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010140d:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101412:	0f b6 c0             	movzbl %al,%eax
80101415:	23 45 e8             	and    -0x18(%ebp),%eax
80101418:	85 c0                	test   %eax,%eax
8010141a:	75 5d                	jne    80101479 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
8010141c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010141f:	8d 50 07             	lea    0x7(%eax),%edx
80101422:	85 c0                	test   %eax,%eax
80101424:	0f 48 c2             	cmovs  %edx,%eax
80101427:	c1 f8 03             	sar    $0x3,%eax
8010142a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010142d:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101432:	89 d1                	mov    %edx,%ecx
80101434:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101437:	09 ca                	or     %ecx,%edx
80101439:	89 d1                	mov    %edx,%ecx
8010143b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143e:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101442:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101445:	89 04 24             	mov    %eax,(%esp)
80101448:	e8 2c 1e 00 00       	call   80103279 <log_write>
        brelse(bp);
8010144d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101450:	89 04 24             	mov    %eax,(%esp)
80101453:	e8 bf ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101458:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010145b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010145e:	01 c2                	add    %eax,%edx
80101460:	8b 45 08             	mov    0x8(%ebp),%eax
80101463:	89 54 24 04          	mov    %edx,0x4(%esp)
80101467:	89 04 24             	mov    %eax,(%esp)
8010146a:	e8 bb fe ff ff       	call   8010132a <bzero>
        return b + bi;
8010146f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101472:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101475:	01 d0                	add    %edx,%eax
80101477:	eb 4e                	jmp    801014c7 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101479:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010147d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101484:	7f 15                	jg     8010149b <balloc+0x120>
80101486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101489:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010148c:	01 d0                	add    %edx,%eax
8010148e:	89 c2                	mov    %eax,%edx
80101490:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101493:	39 c2                	cmp    %eax,%edx
80101495:	0f 82 45 ff ff ff    	jb     801013e0 <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010149b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149e:	89 04 24             	mov    %eax,(%esp)
801014a1:	e8 71 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014a6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014b3:	39 c2                	cmp    %eax,%edx
801014b5:	0f 82 eb fe ff ff    	jb     801013a6 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014bb:	c7 04 24 89 82 10 80 	movl   $0x80108289,(%esp)
801014c2:	e8 73 f0 ff ff       	call   8010053a <panic>
}
801014c7:	c9                   	leave  
801014c8:	c3                   	ret    

801014c9 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c9:	55                   	push   %ebp
801014ca:	89 e5                	mov    %esp,%ebp
801014cc:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014cf:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801014d6:	8b 45 08             	mov    0x8(%ebp),%eax
801014d9:	89 04 24             	mov    %eax,(%esp)
801014dc:	e8 03 fe ff ff       	call   801012e4 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801014e4:	c1 e8 0c             	shr    $0xc,%eax
801014e7:	89 c2                	mov    %eax,%edx
801014e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014ec:	c1 e8 03             	shr    $0x3,%eax
801014ef:	01 d0                	add    %edx,%eax
801014f1:	8d 50 03             	lea    0x3(%eax),%edx
801014f4:	8b 45 08             	mov    0x8(%ebp),%eax
801014f7:	89 54 24 04          	mov    %edx,0x4(%esp)
801014fb:	89 04 24             	mov    %eax,(%esp)
801014fe:	e8 a3 ec ff ff       	call   801001a6 <bread>
80101503:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101506:	8b 45 0c             	mov    0xc(%ebp),%eax
80101509:	25 ff 0f 00 00       	and    $0xfff,%eax
8010150e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101511:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101514:	99                   	cltd   
80101515:	c1 ea 1d             	shr    $0x1d,%edx
80101518:	01 d0                	add    %edx,%eax
8010151a:	83 e0 07             	and    $0x7,%eax
8010151d:	29 d0                	sub    %edx,%eax
8010151f:	ba 01 00 00 00       	mov    $0x1,%edx
80101524:	89 c1                	mov    %eax,%ecx
80101526:	d3 e2                	shl    %cl,%edx
80101528:	89 d0                	mov    %edx,%eax
8010152a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101530:	8d 50 07             	lea    0x7(%eax),%edx
80101533:	85 c0                	test   %eax,%eax
80101535:	0f 48 c2             	cmovs  %edx,%eax
80101538:	c1 f8 03             	sar    $0x3,%eax
8010153b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010153e:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101543:	0f b6 c0             	movzbl %al,%eax
80101546:	23 45 ec             	and    -0x14(%ebp),%eax
80101549:	85 c0                	test   %eax,%eax
8010154b:	75 0c                	jne    80101559 <bfree+0x90>
    panic("freeing free block");
8010154d:	c7 04 24 9f 82 10 80 	movl   $0x8010829f,(%esp)
80101554:	e8 e1 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101559:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010155c:	8d 50 07             	lea    0x7(%eax),%edx
8010155f:	85 c0                	test   %eax,%eax
80101561:	0f 48 c2             	cmovs  %edx,%eax
80101564:	c1 f8 03             	sar    $0x3,%eax
80101567:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156a:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010156f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101572:	f7 d1                	not    %ecx
80101574:	21 ca                	and    %ecx,%edx
80101576:	89 d1                	mov    %edx,%ecx
80101578:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010157b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101582:	89 04 24             	mov    %eax,(%esp)
80101585:	e8 ef 1c 00 00       	call   80103279 <log_write>
  brelse(bp);
8010158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010158d:	89 04 24             	mov    %eax,(%esp)
80101590:	e8 82 ec ff ff       	call   80100217 <brelse>
}
80101595:	c9                   	leave  
80101596:	c3                   	ret    

80101597 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101597:	55                   	push   %ebp
80101598:	89 e5                	mov    %esp,%ebp
8010159a:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
8010159d:	c7 44 24 04 b2 82 10 	movl   $0x801082b2,0x4(%esp)
801015a4:	80 
801015a5:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801015ac:	e8 12 36 00 00       	call   80104bc3 <initlock>
}
801015b1:	c9                   	leave  
801015b2:	c3                   	ret    

801015b3 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015b3:	55                   	push   %ebp
801015b4:	89 e5                	mov    %esp,%ebp
801015b6:	83 ec 38             	sub    $0x38,%esp
801015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801015bc:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015c0:	8b 45 08             	mov    0x8(%ebp),%eax
801015c3:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801015ca:	89 04 24             	mov    %eax,(%esp)
801015cd:	e8 12 fd ff ff       	call   801012e4 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015d2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015d9:	e9 98 00 00 00       	jmp    80101676 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	83 c0 02             	add    $0x2,%eax
801015e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801015eb:	8b 45 08             	mov    0x8(%ebp),%eax
801015ee:	89 04 24             	mov    %eax,(%esp)
801015f1:	e8 b0 eb ff ff       	call   801001a6 <bread>
801015f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fc:	8d 50 18             	lea    0x18(%eax),%edx
801015ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101602:	83 e0 07             	and    $0x7,%eax
80101605:	c1 e0 06             	shl    $0x6,%eax
80101608:	01 d0                	add    %edx,%eax
8010160a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010160d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101610:	0f b7 00             	movzwl (%eax),%eax
80101613:	66 85 c0             	test   %ax,%ax
80101616:	75 4f                	jne    80101667 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101618:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010161f:	00 
80101620:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101627:	00 
80101628:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162b:	89 04 24             	mov    %eax,(%esp)
8010162e:	e8 05 38 00 00       	call   80104e38 <memset>
      dip->type = type;
80101633:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101636:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010163a:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101640:	89 04 24             	mov    %eax,(%esp)
80101643:	e8 31 1c 00 00       	call   80103279 <log_write>
      brelse(bp);
80101648:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164b:	89 04 24             	mov    %eax,(%esp)
8010164e:	e8 c4 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101656:	89 44 24 04          	mov    %eax,0x4(%esp)
8010165a:	8b 45 08             	mov    0x8(%ebp),%eax
8010165d:	89 04 24             	mov    %eax,(%esp)
80101660:	e8 e5 00 00 00       	call   8010174a <iget>
80101665:	eb 29                	jmp    80101690 <ialloc+0xdd>
    }
    brelse(bp);
80101667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166a:	89 04 24             	mov    %eax,(%esp)
8010166d:	e8 a5 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101672:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101676:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010167c:	39 c2                	cmp    %eax,%edx
8010167e:	0f 82 5a ff ff ff    	jb     801015de <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101684:	c7 04 24 b9 82 10 80 	movl   $0x801082b9,(%esp)
8010168b:	e8 aa ee ff ff       	call   8010053a <panic>
}
80101690:	c9                   	leave  
80101691:	c3                   	ret    

80101692 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101692:	55                   	push   %ebp
80101693:	89 e5                	mov    %esp,%ebp
80101695:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101698:	8b 45 08             	mov    0x8(%ebp),%eax
8010169b:	8b 40 04             	mov    0x4(%eax),%eax
8010169e:	c1 e8 03             	shr    $0x3,%eax
801016a1:	8d 50 02             	lea    0x2(%eax),%edx
801016a4:	8b 45 08             	mov    0x8(%ebp),%eax
801016a7:	8b 00                	mov    (%eax),%eax
801016a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801016ad:	89 04 24             	mov    %eax,(%esp)
801016b0:	e8 f1 ea ff ff       	call   801001a6 <bread>
801016b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016bb:	8d 50 18             	lea    0x18(%eax),%edx
801016be:	8b 45 08             	mov    0x8(%ebp),%eax
801016c1:	8b 40 04             	mov    0x4(%eax),%eax
801016c4:	83 e0 07             	and    $0x7,%eax
801016c7:	c1 e0 06             	shl    $0x6,%eax
801016ca:	01 d0                	add    %edx,%eax
801016cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016cf:	8b 45 08             	mov    0x8(%ebp),%eax
801016d2:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016d9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016dc:	8b 45 08             	mov    0x8(%ebp),%eax
801016df:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e6:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801016ea:	8b 45 08             	mov    0x8(%ebp),%eax
801016ed:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f4:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801016f8:	8b 45 08             	mov    0x8(%ebp),%eax
801016fb:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101702:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101706:	8b 45 08             	mov    0x8(%ebp),%eax
80101709:	8b 50 18             	mov    0x18(%eax),%edx
8010170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170f:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101712:	8b 45 08             	mov    0x8(%ebp),%eax
80101715:	8d 50 1c             	lea    0x1c(%eax),%edx
80101718:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171b:	83 c0 0c             	add    $0xc,%eax
8010171e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101725:	00 
80101726:	89 54 24 04          	mov    %edx,0x4(%esp)
8010172a:	89 04 24             	mov    %eax,(%esp)
8010172d:	e8 d5 37 00 00       	call   80104f07 <memmove>
  log_write(bp);
80101732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101735:	89 04 24             	mov    %eax,(%esp)
80101738:	e8 3c 1b 00 00       	call   80103279 <log_write>
  brelse(bp);
8010173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101740:	89 04 24             	mov    %eax,(%esp)
80101743:	e8 cf ea ff ff       	call   80100217 <brelse>
}
80101748:	c9                   	leave  
80101749:	c3                   	ret    

8010174a <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010174a:	55                   	push   %ebp
8010174b:	89 e5                	mov    %esp,%ebp
8010174d:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101750:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101757:	e8 88 34 00 00       	call   80104be4 <acquire>

  // Is the inode already cached?
  empty = 0;
8010175c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101763:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
8010176a:	eb 59                	jmp    801017c5 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176f:	8b 40 08             	mov    0x8(%eax),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 35                	jle    801017ab <iget+0x61>
80101776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101779:	8b 00                	mov    (%eax),%eax
8010177b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010177e:	75 2b                	jne    801017ab <iget+0x61>
80101780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101783:	8b 40 04             	mov    0x4(%eax),%eax
80101786:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101789:	75 20                	jne    801017ab <iget+0x61>
      ip->ref++;
8010178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178e:	8b 40 08             	mov    0x8(%eax),%eax
80101791:	8d 50 01             	lea    0x1(%eax),%edx
80101794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101797:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010179a:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017a1:	e8 a0 34 00 00       	call   80104c46 <release>
      return ip;
801017a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a9:	eb 6f                	jmp    8010181a <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017af:	75 10                	jne    801017c1 <iget+0x77>
801017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b4:	8b 40 08             	mov    0x8(%eax),%eax
801017b7:	85 c0                	test   %eax,%eax
801017b9:	75 06                	jne    801017c1 <iget+0x77>
      empty = ip;
801017bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017be:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017c1:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017c5:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
801017cc:	72 9e                	jb     8010176c <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017d2:	75 0c                	jne    801017e0 <iget+0x96>
    panic("iget: no inodes");
801017d4:	c7 04 24 cb 82 10 80 	movl   $0x801082cb,(%esp)
801017db:	e8 5a ed ff ff       	call   8010053a <panic>

  ip = empty;
801017e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e9:	8b 55 08             	mov    0x8(%ebp),%edx
801017ec:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801017ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801017f4:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801017f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101804:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010180b:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101812:	e8 2f 34 00 00       	call   80104c46 <release>

  return ip;
80101817:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010181a:	c9                   	leave  
8010181b:	c3                   	ret    

8010181c <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010181c:	55                   	push   %ebp
8010181d:	89 e5                	mov    %esp,%ebp
8010181f:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101822:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101829:	e8 b6 33 00 00       	call   80104be4 <acquire>
  ip->ref++;
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	8b 40 08             	mov    0x8(%eax),%eax
80101834:	8d 50 01             	lea    0x1(%eax),%edx
80101837:	8b 45 08             	mov    0x8(%ebp),%eax
8010183a:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010183d:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101844:	e8 fd 33 00 00       	call   80104c46 <release>
  return ip;
80101849:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010184c:	c9                   	leave  
8010184d:	c3                   	ret    

8010184e <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010184e:	55                   	push   %ebp
8010184f:	89 e5                	mov    %esp,%ebp
80101851:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101854:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101858:	74 0a                	je     80101864 <ilock+0x16>
8010185a:	8b 45 08             	mov    0x8(%ebp),%eax
8010185d:	8b 40 08             	mov    0x8(%eax),%eax
80101860:	85 c0                	test   %eax,%eax
80101862:	7f 0c                	jg     80101870 <ilock+0x22>
    panic("ilock");
80101864:	c7 04 24 db 82 10 80 	movl   $0x801082db,(%esp)
8010186b:	e8 ca ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101870:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101877:	e8 68 33 00 00       	call   80104be4 <acquire>
  while(ip->flags & I_BUSY)
8010187c:	eb 13                	jmp    80101891 <ilock+0x43>
    sleep(ip, &icache.lock);
8010187e:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
80101885:	80 
80101886:	8b 45 08             	mov    0x8(%ebp),%eax
80101889:	89 04 24             	mov    %eax,(%esp)
8010188c:	e8 80 30 00 00       	call   80104911 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101891:	8b 45 08             	mov    0x8(%ebp),%eax
80101894:	8b 40 0c             	mov    0xc(%eax),%eax
80101897:	83 e0 01             	and    $0x1,%eax
8010189a:	85 c0                	test   %eax,%eax
8010189c:	75 e0                	jne    8010187e <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010189e:	8b 45 08             	mov    0x8(%ebp),%eax
801018a1:	8b 40 0c             	mov    0xc(%eax),%eax
801018a4:	83 c8 01             	or     $0x1,%eax
801018a7:	89 c2                	mov    %eax,%edx
801018a9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ac:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018af:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018b6:	e8 8b 33 00 00       	call   80104c46 <release>

  if(!(ip->flags & I_VALID)){
801018bb:	8b 45 08             	mov    0x8(%ebp),%eax
801018be:	8b 40 0c             	mov    0xc(%eax),%eax
801018c1:	83 e0 02             	and    $0x2,%eax
801018c4:	85 c0                	test   %eax,%eax
801018c6:	0f 85 ce 00 00 00    	jne    8010199a <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018cc:	8b 45 08             	mov    0x8(%ebp),%eax
801018cf:	8b 40 04             	mov    0x4(%eax),%eax
801018d2:	c1 e8 03             	shr    $0x3,%eax
801018d5:	8d 50 02             	lea    0x2(%eax),%edx
801018d8:	8b 45 08             	mov    0x8(%ebp),%eax
801018db:	8b 00                	mov    (%eax),%eax
801018dd:	89 54 24 04          	mov    %edx,0x4(%esp)
801018e1:	89 04 24             	mov    %eax,(%esp)
801018e4:	e8 bd e8 ff ff       	call   801001a6 <bread>
801018e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ef:	8d 50 18             	lea    0x18(%eax),%edx
801018f2:	8b 45 08             	mov    0x8(%ebp),%eax
801018f5:	8b 40 04             	mov    0x4(%eax),%eax
801018f8:	83 e0 07             	and    $0x7,%eax
801018fb:	c1 e0 06             	shl    $0x6,%eax
801018fe:	01 d0                	add    %edx,%eax
80101900:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101903:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101906:	0f b7 10             	movzwl (%eax),%edx
80101909:	8b 45 08             	mov    0x8(%ebp),%eax
8010190c:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101910:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101913:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101917:	8b 45 08             	mov    0x8(%ebp),%eax
8010191a:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010191e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101921:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101925:	8b 45 08             	mov    0x8(%ebp),%eax
80101928:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101933:	8b 45 08             	mov    0x8(%ebp),%eax
80101936:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
8010193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193d:	8b 50 08             	mov    0x8(%eax),%edx
80101940:	8b 45 08             	mov    0x8(%ebp),%eax
80101943:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101946:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101949:	8d 50 0c             	lea    0xc(%eax),%edx
8010194c:	8b 45 08             	mov    0x8(%ebp),%eax
8010194f:	83 c0 1c             	add    $0x1c,%eax
80101952:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101959:	00 
8010195a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010195e:	89 04 24             	mov    %eax,(%esp)
80101961:	e8 a1 35 00 00       	call   80104f07 <memmove>
    brelse(bp);
80101966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101969:	89 04 24             	mov    %eax,(%esp)
8010196c:	e8 a6 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
80101971:	8b 45 08             	mov    0x8(%ebp),%eax
80101974:	8b 40 0c             	mov    0xc(%eax),%eax
80101977:	83 c8 02             	or     $0x2,%eax
8010197a:	89 c2                	mov    %eax,%edx
8010197c:	8b 45 08             	mov    0x8(%ebp),%eax
8010197f:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101982:	8b 45 08             	mov    0x8(%ebp),%eax
80101985:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101989:	66 85 c0             	test   %ax,%ax
8010198c:	75 0c                	jne    8010199a <ilock+0x14c>
      panic("ilock: no type");
8010198e:	c7 04 24 e1 82 10 80 	movl   $0x801082e1,(%esp)
80101995:	e8 a0 eb ff ff       	call   8010053a <panic>
  }
}
8010199a:	c9                   	leave  
8010199b:	c3                   	ret    

8010199c <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
8010199c:	55                   	push   %ebp
8010199d:	89 e5                	mov    %esp,%ebp
8010199f:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019a6:	74 17                	je     801019bf <iunlock+0x23>
801019a8:	8b 45 08             	mov    0x8(%ebp),%eax
801019ab:	8b 40 0c             	mov    0xc(%eax),%eax
801019ae:	83 e0 01             	and    $0x1,%eax
801019b1:	85 c0                	test   %eax,%eax
801019b3:	74 0a                	je     801019bf <iunlock+0x23>
801019b5:	8b 45 08             	mov    0x8(%ebp),%eax
801019b8:	8b 40 08             	mov    0x8(%eax),%eax
801019bb:	85 c0                	test   %eax,%eax
801019bd:	7f 0c                	jg     801019cb <iunlock+0x2f>
    panic("iunlock");
801019bf:	c7 04 24 f0 82 10 80 	movl   $0x801082f0,(%esp)
801019c6:	e8 6f eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019cb:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019d2:	e8 0d 32 00 00       	call   80104be4 <acquire>
  ip->flags &= ~I_BUSY;
801019d7:	8b 45 08             	mov    0x8(%ebp),%eax
801019da:	8b 40 0c             	mov    0xc(%eax),%eax
801019dd:	83 e0 fe             	and    $0xfffffffe,%eax
801019e0:	89 c2                	mov    %eax,%edx
801019e2:	8b 45 08             	mov    0x8(%ebp),%eax
801019e5:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
801019e8:	8b 45 08             	mov    0x8(%ebp),%eax
801019eb:	89 04 24             	mov    %eax,(%esp)
801019ee:	e8 fa 2f 00 00       	call   801049ed <wakeup>
  release(&icache.lock);
801019f3:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019fa:	e8 47 32 00 00       	call   80104c46 <release>
}
801019ff:	c9                   	leave  
80101a00:	c3                   	ret    

80101a01 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a01:	55                   	push   %ebp
80101a02:	89 e5                	mov    %esp,%ebp
80101a04:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a07:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a0e:	e8 d1 31 00 00       	call   80104be4 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a13:	8b 45 08             	mov    0x8(%ebp),%eax
80101a16:	8b 40 08             	mov    0x8(%eax),%eax
80101a19:	83 f8 01             	cmp    $0x1,%eax
80101a1c:	0f 85 93 00 00 00    	jne    80101ab5 <iput+0xb4>
80101a22:	8b 45 08             	mov    0x8(%ebp),%eax
80101a25:	8b 40 0c             	mov    0xc(%eax),%eax
80101a28:	83 e0 02             	and    $0x2,%eax
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	0f 84 82 00 00 00    	je     80101ab5 <iput+0xb4>
80101a33:	8b 45 08             	mov    0x8(%ebp),%eax
80101a36:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a3a:	66 85 c0             	test   %ax,%ax
80101a3d:	75 76                	jne    80101ab5 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a42:	8b 40 0c             	mov    0xc(%eax),%eax
80101a45:	83 e0 01             	and    $0x1,%eax
80101a48:	85 c0                	test   %eax,%eax
80101a4a:	74 0c                	je     80101a58 <iput+0x57>
      panic("iput busy");
80101a4c:	c7 04 24 f8 82 10 80 	movl   $0x801082f8,(%esp)
80101a53:	e8 e2 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5e:	83 c8 01             	or     $0x1,%eax
80101a61:	89 c2                	mov    %eax,%edx
80101a63:	8b 45 08             	mov    0x8(%ebp),%eax
80101a66:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a69:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a70:	e8 d1 31 00 00       	call   80104c46 <release>
    itrunc(ip);
80101a75:	8b 45 08             	mov    0x8(%ebp),%eax
80101a78:	89 04 24             	mov    %eax,(%esp)
80101a7b:	e8 7d 01 00 00       	call   80101bfd <itrunc>
    ip->type = 0;
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	89 04 24             	mov    %eax,(%esp)
80101a8f:	e8 fe fb ff ff       	call   80101692 <iupdate>
    acquire(&icache.lock);
80101a94:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a9b:	e8 44 31 00 00       	call   80104be4 <acquire>
    ip->flags = 0;
80101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80101aad:	89 04 24             	mov    %eax,(%esp)
80101ab0:	e8 38 2f 00 00       	call   801049ed <wakeup>
  }
  ip->ref--;
80101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab8:	8b 40 08             	mov    0x8(%eax),%eax
80101abb:	8d 50 ff             	lea    -0x1(%eax),%edx
80101abe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac1:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ac4:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101acb:	e8 76 31 00 00       	call   80104c46 <release>
}
80101ad0:	c9                   	leave  
80101ad1:	c3                   	ret    

80101ad2 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101ad2:	55                   	push   %ebp
80101ad3:	89 e5                	mov    %esp,%ebp
80101ad5:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80101adb:	89 04 24             	mov    %eax,(%esp)
80101ade:	e8 b9 fe ff ff       	call   8010199c <iunlock>
  iput(ip);
80101ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae6:	89 04 24             	mov    %eax,(%esp)
80101ae9:	e8 13 ff ff ff       	call   80101a01 <iput>
}
80101aee:	c9                   	leave  
80101aef:	c3                   	ret    

80101af0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	53                   	push   %ebx
80101af4:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101af7:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101afb:	77 3e                	ja     80101b3b <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b03:	83 c2 04             	add    $0x4,%edx
80101b06:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b11:	75 20                	jne    80101b33 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	8b 00                	mov    (%eax),%eax
80101b18:	89 04 24             	mov    %eax,(%esp)
80101b1b:	e8 5b f8 ff ff       	call   8010137b <balloc>
80101b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b23:	8b 45 08             	mov    0x8(%ebp),%eax
80101b26:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b29:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b2f:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b36:	e9 bc 00 00 00       	jmp    80101bf7 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b3b:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b3f:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b43:	0f 87 a2 00 00 00    	ja     80101beb <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b49:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b56:	75 19                	jne    80101b71 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b58:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5b:	8b 00                	mov    (%eax),%eax
80101b5d:	89 04 24             	mov    %eax,(%esp)
80101b60:	e8 16 f8 ff ff       	call   8010137b <balloc>
80101b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b6e:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b71:	8b 45 08             	mov    0x8(%ebp),%eax
80101b74:	8b 00                	mov    (%eax),%eax
80101b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b79:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b7d:	89 04 24             	mov    %eax,(%esp)
80101b80:	e8 21 e6 ff ff       	call   801001a6 <bread>
80101b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b8b:	83 c0 18             	add    $0x18,%eax
80101b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101b91:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b9e:	01 d0                	add    %edx,%eax
80101ba0:	8b 00                	mov    (%eax),%eax
80101ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ba5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ba9:	75 30                	jne    80101bdb <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bab:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bb8:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbe:	8b 00                	mov    (%eax),%eax
80101bc0:	89 04 24             	mov    %eax,(%esp)
80101bc3:	e8 b3 f7 ff ff       	call   8010137b <balloc>
80101bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bce:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd3:	89 04 24             	mov    %eax,(%esp)
80101bd6:	e8 9e 16 00 00       	call   80103279 <log_write>
    }
    brelse(bp);
80101bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bde:	89 04 24             	mov    %eax,(%esp)
80101be1:	e8 31 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be9:	eb 0c                	jmp    80101bf7 <bmap+0x107>
  }

  panic("bmap: out of range");
80101beb:	c7 04 24 02 83 10 80 	movl   $0x80108302,(%esp)
80101bf2:	e8 43 e9 ff ff       	call   8010053a <panic>
}
80101bf7:	83 c4 24             	add    $0x24,%esp
80101bfa:	5b                   	pop    %ebx
80101bfb:	5d                   	pop    %ebp
80101bfc:	c3                   	ret    

80101bfd <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101bfd:	55                   	push   %ebp
80101bfe:	89 e5                	mov    %esp,%ebp
80101c00:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c0a:	eb 44                	jmp    80101c50 <itrunc+0x53>
    if(ip->addrs[i]){
80101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c12:	83 c2 04             	add    $0x4,%edx
80101c15:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c19:	85 c0                	test   %eax,%eax
80101c1b:	74 2f                	je     80101c4c <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c23:	83 c2 04             	add    $0x4,%edx
80101c26:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2d:	8b 00                	mov    (%eax),%eax
80101c2f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c33:	89 04 24             	mov    %eax,(%esp)
80101c36:	e8 8e f8 ff ff       	call   801014c9 <bfree>
      ip->addrs[i] = 0;
80101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c41:	83 c2 04             	add    $0x4,%edx
80101c44:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c4b:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c50:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c54:	7e b6                	jle    80101c0c <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c56:	8b 45 08             	mov    0x8(%ebp),%eax
80101c59:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c5c:	85 c0                	test   %eax,%eax
80101c5e:	0f 84 9b 00 00 00    	je     80101cff <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c64:	8b 45 08             	mov    0x8(%ebp),%eax
80101c67:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	8b 00                	mov    (%eax),%eax
80101c6f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c73:	89 04 24             	mov    %eax,(%esp)
80101c76:	e8 2b e5 ff ff       	call   801001a6 <bread>
80101c7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c81:	83 c0 18             	add    $0x18,%eax
80101c84:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c87:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c8e:	eb 3b                	jmp    80101ccb <itrunc+0xce>
      if(a[j])
80101c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c93:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101c9d:	01 d0                	add    %edx,%eax
80101c9f:	8b 00                	mov    (%eax),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 22                	je     80101cc7 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101caf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cb2:	01 d0                	add    %edx,%eax
80101cb4:	8b 10                	mov    (%eax),%edx
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	8b 00                	mov    (%eax),%eax
80101cbb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cbf:	89 04 24             	mov    %eax,(%esp)
80101cc2:	e8 02 f8 ff ff       	call   801014c9 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cc7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cce:	83 f8 7f             	cmp    $0x7f,%eax
80101cd1:	76 bd                	jbe    80101c90 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cd6:	89 04 24             	mov    %eax,(%esp)
80101cd9:	e8 39 e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cde:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce1:	8b 50 4c             	mov    0x4c(%eax),%edx
80101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce7:	8b 00                	mov    (%eax),%eax
80101ce9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ced:	89 04 24             	mov    %eax,(%esp)
80101cf0:	e8 d4 f7 ff ff       	call   801014c9 <bfree>
    ip->addrs[NDIRECT] = 0;
80101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf8:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101cff:	8b 45 08             	mov    0x8(%ebp),%eax
80101d02:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d09:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0c:	89 04 24             	mov    %eax,(%esp)
80101d0f:	e8 7e f9 ff ff       	call   80101692 <iupdate>
}
80101d14:	c9                   	leave  
80101d15:	c3                   	ret    

80101d16 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d16:	55                   	push   %ebp
80101d17:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d19:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1c:	8b 00                	mov    (%eax),%eax
80101d1e:	89 c2                	mov    %eax,%edx
80101d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d23:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d26:	8b 45 08             	mov    0x8(%ebp),%eax
80101d29:	8b 50 04             	mov    0x4(%eax),%edx
80101d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d2f:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d32:	8b 45 08             	mov    0x8(%ebp),%eax
80101d35:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3c:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d42:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d49:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d50:	8b 50 18             	mov    0x18(%eax),%edx
80101d53:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d56:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret    

80101d5b <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d5b:	55                   	push   %ebp
80101d5c:	89 e5                	mov    %esp,%ebp
80101d5e:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d61:	8b 45 08             	mov    0x8(%ebp),%eax
80101d64:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d68:	66 83 f8 03          	cmp    $0x3,%ax
80101d6c:	75 60                	jne    80101dce <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d71:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d75:	66 85 c0             	test   %ax,%ax
80101d78:	78 20                	js     80101d9a <readi+0x3f>
80101d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d81:	66 83 f8 09          	cmp    $0x9,%ax
80101d85:	7f 13                	jg     80101d9a <readi+0x3f>
80101d87:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d8e:	98                   	cwtl   
80101d8f:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101d96:	85 c0                	test   %eax,%eax
80101d98:	75 0a                	jne    80101da4 <readi+0x49>
      return -1;
80101d9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d9f:	e9 19 01 00 00       	jmp    80101ebd <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dab:	98                   	cwtl   
80101dac:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101db3:	8b 55 14             	mov    0x14(%ebp),%edx
80101db6:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dba:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dbd:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dc1:	8b 55 08             	mov    0x8(%ebp),%edx
80101dc4:	89 14 24             	mov    %edx,(%esp)
80101dc7:	ff d0                	call   *%eax
80101dc9:	e9 ef 00 00 00       	jmp    80101ebd <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101dce:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd1:	8b 40 18             	mov    0x18(%eax),%eax
80101dd4:	3b 45 10             	cmp    0x10(%ebp),%eax
80101dd7:	72 0d                	jb     80101de6 <readi+0x8b>
80101dd9:	8b 45 14             	mov    0x14(%ebp),%eax
80101ddc:	8b 55 10             	mov    0x10(%ebp),%edx
80101ddf:	01 d0                	add    %edx,%eax
80101de1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101de4:	73 0a                	jae    80101df0 <readi+0x95>
    return -1;
80101de6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101deb:	e9 cd 00 00 00       	jmp    80101ebd <readi+0x162>
  if(off + n > ip->size)
80101df0:	8b 45 14             	mov    0x14(%ebp),%eax
80101df3:	8b 55 10             	mov    0x10(%ebp),%edx
80101df6:	01 c2                	add    %eax,%edx
80101df8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfb:	8b 40 18             	mov    0x18(%eax),%eax
80101dfe:	39 c2                	cmp    %eax,%edx
80101e00:	76 0c                	jbe    80101e0e <readi+0xb3>
    n = ip->size - off;
80101e02:	8b 45 08             	mov    0x8(%ebp),%eax
80101e05:	8b 40 18             	mov    0x18(%eax),%eax
80101e08:	2b 45 10             	sub    0x10(%ebp),%eax
80101e0b:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e15:	e9 94 00 00 00       	jmp    80101eae <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e1a:	8b 45 10             	mov    0x10(%ebp),%eax
80101e1d:	c1 e8 09             	shr    $0x9,%eax
80101e20:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e24:	8b 45 08             	mov    0x8(%ebp),%eax
80101e27:	89 04 24             	mov    %eax,(%esp)
80101e2a:	e8 c1 fc ff ff       	call   80101af0 <bmap>
80101e2f:	8b 55 08             	mov    0x8(%ebp),%edx
80101e32:	8b 12                	mov    (%edx),%edx
80101e34:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e38:	89 14 24             	mov    %edx,(%esp)
80101e3b:	e8 66 e3 ff ff       	call   801001a6 <bread>
80101e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e43:	8b 45 10             	mov    0x10(%ebp),%eax
80101e46:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e4b:	89 c2                	mov    %eax,%edx
80101e4d:	b8 00 02 00 00       	mov    $0x200,%eax
80101e52:	29 d0                	sub    %edx,%eax
80101e54:	89 c2                	mov    %eax,%edx
80101e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e59:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e5c:	29 c1                	sub    %eax,%ecx
80101e5e:	89 c8                	mov    %ecx,%eax
80101e60:	39 c2                	cmp    %eax,%edx
80101e62:	0f 46 c2             	cmovbe %edx,%eax
80101e65:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e68:	8b 45 10             	mov    0x10(%ebp),%eax
80101e6b:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e70:	8d 50 10             	lea    0x10(%eax),%edx
80101e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e76:	01 d0                	add    %edx,%eax
80101e78:	8d 50 08             	lea    0x8(%eax),%edx
80101e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e82:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e86:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e89:	89 04 24             	mov    %eax,(%esp)
80101e8c:	e8 76 30 00 00       	call   80104f07 <memmove>
    brelse(bp);
80101e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e94:	89 04 24             	mov    %eax,(%esp)
80101e97:	e8 7b e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9f:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ea5:	01 45 10             	add    %eax,0x10(%ebp)
80101ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eab:	01 45 0c             	add    %eax,0xc(%ebp)
80101eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb1:	3b 45 14             	cmp    0x14(%ebp),%eax
80101eb4:	0f 82 60 ff ff ff    	jb     80101e1a <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101eba:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101ebd:	c9                   	leave  
80101ebe:	c3                   	ret    

80101ebf <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ebf:	55                   	push   %ebp
80101ec0:	89 e5                	mov    %esp,%ebp
80101ec2:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ecc:	66 83 f8 03          	cmp    $0x3,%ax
80101ed0:	75 60                	jne    80101f32 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ed9:	66 85 c0             	test   %ax,%ax
80101edc:	78 20                	js     80101efe <writei+0x3f>
80101ede:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ee5:	66 83 f8 09          	cmp    $0x9,%ax
80101ee9:	7f 13                	jg     80101efe <writei+0x3f>
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101eee:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef2:	98                   	cwtl   
80101ef3:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101efa:	85 c0                	test   %eax,%eax
80101efc:	75 0a                	jne    80101f08 <writei+0x49>
      return -1;
80101efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f03:	e9 44 01 00 00       	jmp    8010204c <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f0f:	98                   	cwtl   
80101f10:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f17:	8b 55 14             	mov    0x14(%ebp),%edx
80101f1a:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f21:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f25:	8b 55 08             	mov    0x8(%ebp),%edx
80101f28:	89 14 24             	mov    %edx,(%esp)
80101f2b:	ff d0                	call   *%eax
80101f2d:	e9 1a 01 00 00       	jmp    8010204c <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f32:	8b 45 08             	mov    0x8(%ebp),%eax
80101f35:	8b 40 18             	mov    0x18(%eax),%eax
80101f38:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f3b:	72 0d                	jb     80101f4a <writei+0x8b>
80101f3d:	8b 45 14             	mov    0x14(%ebp),%eax
80101f40:	8b 55 10             	mov    0x10(%ebp),%edx
80101f43:	01 d0                	add    %edx,%eax
80101f45:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f48:	73 0a                	jae    80101f54 <writei+0x95>
    return -1;
80101f4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f4f:	e9 f8 00 00 00       	jmp    8010204c <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f54:	8b 45 14             	mov    0x14(%ebp),%eax
80101f57:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5a:	01 d0                	add    %edx,%eax
80101f5c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f61:	76 0a                	jbe    80101f6d <writei+0xae>
    return -1;
80101f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f68:	e9 df 00 00 00       	jmp    8010204c <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f74:	e9 9f 00 00 00       	jmp    80102018 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f79:	8b 45 10             	mov    0x10(%ebp),%eax
80101f7c:	c1 e8 09             	shr    $0x9,%eax
80101f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f83:	8b 45 08             	mov    0x8(%ebp),%eax
80101f86:	89 04 24             	mov    %eax,(%esp)
80101f89:	e8 62 fb ff ff       	call   80101af0 <bmap>
80101f8e:	8b 55 08             	mov    0x8(%ebp),%edx
80101f91:	8b 12                	mov    (%edx),%edx
80101f93:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f97:	89 14 24             	mov    %edx,(%esp)
80101f9a:	e8 07 e2 ff ff       	call   801001a6 <bread>
80101f9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fa2:	8b 45 10             	mov    0x10(%ebp),%eax
80101fa5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101faa:	89 c2                	mov    %eax,%edx
80101fac:	b8 00 02 00 00       	mov    $0x200,%eax
80101fb1:	29 d0                	sub    %edx,%eax
80101fb3:	89 c2                	mov    %eax,%edx
80101fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fb8:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fbb:	29 c1                	sub    %eax,%ecx
80101fbd:	89 c8                	mov    %ecx,%eax
80101fbf:	39 c2                	cmp    %eax,%edx
80101fc1:	0f 46 c2             	cmovbe %edx,%eax
80101fc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101fca:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fcf:	8d 50 10             	lea    0x10(%eax),%edx
80101fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fd5:	01 d0                	add    %edx,%eax
80101fd7:	8d 50 08             	lea    0x8(%eax),%edx
80101fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fdd:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fe8:	89 14 24             	mov    %edx,(%esp)
80101feb:	e8 17 2f 00 00       	call   80104f07 <memmove>
    log_write(bp);
80101ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff3:	89 04 24             	mov    %eax,(%esp)
80101ff6:	e8 7e 12 00 00       	call   80103279 <log_write>
    brelse(bp);
80101ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ffe:	89 04 24             	mov    %eax,(%esp)
80102001:	e8 11 e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102006:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102009:	01 45 f4             	add    %eax,-0xc(%ebp)
8010200c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200f:	01 45 10             	add    %eax,0x10(%ebp)
80102012:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102015:	01 45 0c             	add    %eax,0xc(%ebp)
80102018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010201b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010201e:	0f 82 55 ff ff ff    	jb     80101f79 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102024:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102028:	74 1f                	je     80102049 <writei+0x18a>
8010202a:	8b 45 08             	mov    0x8(%ebp),%eax
8010202d:	8b 40 18             	mov    0x18(%eax),%eax
80102030:	3b 45 10             	cmp    0x10(%ebp),%eax
80102033:	73 14                	jae    80102049 <writei+0x18a>
    ip->size = off;
80102035:	8b 45 08             	mov    0x8(%ebp),%eax
80102038:	8b 55 10             	mov    0x10(%ebp),%edx
8010203b:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010203e:	8b 45 08             	mov    0x8(%ebp),%eax
80102041:	89 04 24             	mov    %eax,(%esp)
80102044:	e8 49 f6 ff ff       	call   80101692 <iupdate>
  }
  return n;
80102049:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010204c:	c9                   	leave  
8010204d:	c3                   	ret    

8010204e <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010204e:	55                   	push   %ebp
8010204f:	89 e5                	mov    %esp,%ebp
80102051:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102054:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010205b:	00 
8010205c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010205f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102063:	8b 45 08             	mov    0x8(%ebp),%eax
80102066:	89 04 24             	mov    %eax,(%esp)
80102069:	e8 3c 2f 00 00       	call   80104faa <strncmp>
}
8010206e:	c9                   	leave  
8010206f:	c3                   	ret    

80102070 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102076:	8b 45 08             	mov    0x8(%ebp),%eax
80102079:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010207d:	66 83 f8 01          	cmp    $0x1,%ax
80102081:	74 0c                	je     8010208f <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102083:	c7 04 24 15 83 10 80 	movl   $0x80108315,(%esp)
8010208a:	e8 ab e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010208f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102096:	e9 88 00 00 00       	jmp    80102123 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010209b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020a2:	00 
801020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801020aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801020b1:	8b 45 08             	mov    0x8(%ebp),%eax
801020b4:	89 04 24             	mov    %eax,(%esp)
801020b7:	e8 9f fc ff ff       	call   80101d5b <readi>
801020bc:	83 f8 10             	cmp    $0x10,%eax
801020bf:	74 0c                	je     801020cd <dirlookup+0x5d>
      panic("dirlink read");
801020c1:	c7 04 24 27 83 10 80 	movl   $0x80108327,(%esp)
801020c8:	e8 6d e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020cd:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020d1:	66 85 c0             	test   %ax,%ax
801020d4:	75 02                	jne    801020d8 <dirlookup+0x68>
      continue;
801020d6:	eb 47                	jmp    8010211f <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020db:	83 c0 02             	add    $0x2,%eax
801020de:	89 44 24 04          	mov    %eax,0x4(%esp)
801020e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020e5:	89 04 24             	mov    %eax,(%esp)
801020e8:	e8 61 ff ff ff       	call   8010204e <namecmp>
801020ed:	85 c0                	test   %eax,%eax
801020ef:	75 2e                	jne    8010211f <dirlookup+0xaf>
      // entry matches path element
      if(poff)
801020f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801020f5:	74 08                	je     801020ff <dirlookup+0x8f>
        *poff = off;
801020f7:	8b 45 10             	mov    0x10(%ebp),%eax
801020fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801020fd:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801020ff:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102103:	0f b7 c0             	movzwl %ax,%eax
80102106:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102109:	8b 45 08             	mov    0x8(%ebp),%eax
8010210c:	8b 00                	mov    (%eax),%eax
8010210e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102111:	89 54 24 04          	mov    %edx,0x4(%esp)
80102115:	89 04 24             	mov    %eax,(%esp)
80102118:	e8 2d f6 ff ff       	call   8010174a <iget>
8010211d:	eb 18                	jmp    80102137 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010211f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102123:	8b 45 08             	mov    0x8(%ebp),%eax
80102126:	8b 40 18             	mov    0x18(%eax),%eax
80102129:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010212c:	0f 87 69 ff ff ff    	ja     8010209b <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102132:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102137:	c9                   	leave  
80102138:	c3                   	ret    

80102139 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102139:	55                   	push   %ebp
8010213a:	89 e5                	mov    %esp,%ebp
8010213c:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010213f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102146:	00 
80102147:	8b 45 0c             	mov    0xc(%ebp),%eax
8010214a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010214e:	8b 45 08             	mov    0x8(%ebp),%eax
80102151:	89 04 24             	mov    %eax,(%esp)
80102154:	e8 17 ff ff ff       	call   80102070 <dirlookup>
80102159:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010215c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102160:	74 15                	je     80102177 <dirlink+0x3e>
    iput(ip);
80102162:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102165:	89 04 24             	mov    %eax,(%esp)
80102168:	e8 94 f8 ff ff       	call   80101a01 <iput>
    return -1;
8010216d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102172:	e9 b7 00 00 00       	jmp    8010222e <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010217e:	eb 46                	jmp    801021c6 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102183:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010218a:	00 
8010218b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010218f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102192:	89 44 24 04          	mov    %eax,0x4(%esp)
80102196:	8b 45 08             	mov    0x8(%ebp),%eax
80102199:	89 04 24             	mov    %eax,(%esp)
8010219c:	e8 ba fb ff ff       	call   80101d5b <readi>
801021a1:	83 f8 10             	cmp    $0x10,%eax
801021a4:	74 0c                	je     801021b2 <dirlink+0x79>
      panic("dirlink read");
801021a6:	c7 04 24 27 83 10 80 	movl   $0x80108327,(%esp)
801021ad:	e8 88 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021b2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021b6:	66 85 c0             	test   %ax,%ax
801021b9:	75 02                	jne    801021bd <dirlink+0x84>
      break;
801021bb:	eb 16                	jmp    801021d3 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021c0:	83 c0 10             	add    $0x10,%eax
801021c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021c9:	8b 45 08             	mov    0x8(%ebp),%eax
801021cc:	8b 40 18             	mov    0x18(%eax),%eax
801021cf:	39 c2                	cmp    %eax,%edx
801021d1:	72 ad                	jb     80102180 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021d3:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021da:	00 
801021db:	8b 45 0c             	mov    0xc(%ebp),%eax
801021de:	89 44 24 04          	mov    %eax,0x4(%esp)
801021e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021e5:	83 c0 02             	add    $0x2,%eax
801021e8:	89 04 24             	mov    %eax,(%esp)
801021eb:	e8 10 2e 00 00       	call   80105000 <strncpy>
  de.inum = inum;
801021f0:	8b 45 10             	mov    0x10(%ebp),%eax
801021f3:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021fa:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102201:	00 
80102202:	89 44 24 08          	mov    %eax,0x8(%esp)
80102206:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102209:	89 44 24 04          	mov    %eax,0x4(%esp)
8010220d:	8b 45 08             	mov    0x8(%ebp),%eax
80102210:	89 04 24             	mov    %eax,(%esp)
80102213:	e8 a7 fc ff ff       	call   80101ebf <writei>
80102218:	83 f8 10             	cmp    $0x10,%eax
8010221b:	74 0c                	je     80102229 <dirlink+0xf0>
    panic("dirlink");
8010221d:	c7 04 24 34 83 10 80 	movl   $0x80108334,(%esp)
80102224:	e8 11 e3 ff ff       	call   8010053a <panic>
  
  return 0;
80102229:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010222e:	c9                   	leave  
8010222f:	c3                   	ret    

80102230 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102236:	eb 04                	jmp    8010223c <skipelem+0xc>
    path++;
80102238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010223c:	8b 45 08             	mov    0x8(%ebp),%eax
8010223f:	0f b6 00             	movzbl (%eax),%eax
80102242:	3c 2f                	cmp    $0x2f,%al
80102244:	74 f2                	je     80102238 <skipelem+0x8>
    path++;
  if(*path == 0)
80102246:	8b 45 08             	mov    0x8(%ebp),%eax
80102249:	0f b6 00             	movzbl (%eax),%eax
8010224c:	84 c0                	test   %al,%al
8010224e:	75 0a                	jne    8010225a <skipelem+0x2a>
    return 0;
80102250:	b8 00 00 00 00       	mov    $0x0,%eax
80102255:	e9 86 00 00 00       	jmp    801022e0 <skipelem+0xb0>
  s = path;
8010225a:	8b 45 08             	mov    0x8(%ebp),%eax
8010225d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102260:	eb 04                	jmp    80102266 <skipelem+0x36>
    path++;
80102262:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102266:	8b 45 08             	mov    0x8(%ebp),%eax
80102269:	0f b6 00             	movzbl (%eax),%eax
8010226c:	3c 2f                	cmp    $0x2f,%al
8010226e:	74 0a                	je     8010227a <skipelem+0x4a>
80102270:	8b 45 08             	mov    0x8(%ebp),%eax
80102273:	0f b6 00             	movzbl (%eax),%eax
80102276:	84 c0                	test   %al,%al
80102278:	75 e8                	jne    80102262 <skipelem+0x32>
    path++;
  len = path - s;
8010227a:	8b 55 08             	mov    0x8(%ebp),%edx
8010227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102280:	29 c2                	sub    %eax,%edx
80102282:	89 d0                	mov    %edx,%eax
80102284:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102287:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010228b:	7e 1c                	jle    801022a9 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
8010228d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102294:	00 
80102295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102298:	89 44 24 04          	mov    %eax,0x4(%esp)
8010229c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010229f:	89 04 24             	mov    %eax,(%esp)
801022a2:	e8 60 2c 00 00       	call   80104f07 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022a7:	eb 2a                	jmp    801022d3 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022ac:	89 44 24 08          	mov    %eax,0x8(%esp)
801022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ba:	89 04 24             	mov    %eax,(%esp)
801022bd:	e8 45 2c 00 00       	call   80104f07 <memmove>
    name[len] = 0;
801022c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801022c8:	01 d0                	add    %edx,%eax
801022ca:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022cd:	eb 04                	jmp    801022d3 <skipelem+0xa3>
    path++;
801022cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022d3:	8b 45 08             	mov    0x8(%ebp),%eax
801022d6:	0f b6 00             	movzbl (%eax),%eax
801022d9:	3c 2f                	cmp    $0x2f,%al
801022db:	74 f2                	je     801022cf <skipelem+0x9f>
    path++;
  return path;
801022dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022e0:	c9                   	leave  
801022e1:	c3                   	ret    

801022e2 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022e2:	55                   	push   %ebp
801022e3:	89 e5                	mov    %esp,%ebp
801022e5:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022e8:	8b 45 08             	mov    0x8(%ebp),%eax
801022eb:	0f b6 00             	movzbl (%eax),%eax
801022ee:	3c 2f                	cmp    $0x2f,%al
801022f0:	75 1c                	jne    8010230e <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
801022f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801022f9:	00 
801022fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102301:	e8 44 f4 ff ff       	call   8010174a <iget>
80102306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102309:	e9 af 00 00 00       	jmp    801023bd <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010230e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102314:	8b 40 68             	mov    0x68(%eax),%eax
80102317:	89 04 24             	mov    %eax,(%esp)
8010231a:	e8 fd f4 ff ff       	call   8010181c <idup>
8010231f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102322:	e9 96 00 00 00       	jmp    801023bd <namex+0xdb>
    ilock(ip);
80102327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232a:	89 04 24             	mov    %eax,(%esp)
8010232d:	e8 1c f5 ff ff       	call   8010184e <ilock>
    if(ip->type != T_DIR){
80102332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102335:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102339:	66 83 f8 01          	cmp    $0x1,%ax
8010233d:	74 15                	je     80102354 <namex+0x72>
      iunlockput(ip);
8010233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102342:	89 04 24             	mov    %eax,(%esp)
80102345:	e8 88 f7 ff ff       	call   80101ad2 <iunlockput>
      return 0;
8010234a:	b8 00 00 00 00       	mov    $0x0,%eax
8010234f:	e9 a3 00 00 00       	jmp    801023f7 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102354:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102358:	74 1d                	je     80102377 <namex+0x95>
8010235a:	8b 45 08             	mov    0x8(%ebp),%eax
8010235d:	0f b6 00             	movzbl (%eax),%eax
80102360:	84 c0                	test   %al,%al
80102362:	75 13                	jne    80102377 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102367:	89 04 24             	mov    %eax,(%esp)
8010236a:	e8 2d f6 ff ff       	call   8010199c <iunlock>
      return ip;
8010236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102372:	e9 80 00 00 00       	jmp    801023f7 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102377:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010237e:	00 
8010237f:	8b 45 10             	mov    0x10(%ebp),%eax
80102382:	89 44 24 04          	mov    %eax,0x4(%esp)
80102386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102389:	89 04 24             	mov    %eax,(%esp)
8010238c:	e8 df fc ff ff       	call   80102070 <dirlookup>
80102391:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102394:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102398:	75 12                	jne    801023ac <namex+0xca>
      iunlockput(ip);
8010239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239d:	89 04 24             	mov    %eax,(%esp)
801023a0:	e8 2d f7 ff ff       	call   80101ad2 <iunlockput>
      return 0;
801023a5:	b8 00 00 00 00       	mov    $0x0,%eax
801023aa:	eb 4b                	jmp    801023f7 <namex+0x115>
    }
    iunlockput(ip);
801023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023af:	89 04 24             	mov    %eax,(%esp)
801023b2:	e8 1b f7 ff ff       	call   80101ad2 <iunlockput>
    ip = next;
801023b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023bd:	8b 45 10             	mov    0x10(%ebp),%eax
801023c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801023c4:	8b 45 08             	mov    0x8(%ebp),%eax
801023c7:	89 04 24             	mov    %eax,(%esp)
801023ca:	e8 61 fe ff ff       	call   80102230 <skipelem>
801023cf:	89 45 08             	mov    %eax,0x8(%ebp)
801023d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023d6:	0f 85 4b ff ff ff    	jne    80102327 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023e0:	74 12                	je     801023f4 <namex+0x112>
    iput(ip);
801023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e5:	89 04 24             	mov    %eax,(%esp)
801023e8:	e8 14 f6 ff ff       	call   80101a01 <iput>
    return 0;
801023ed:	b8 00 00 00 00       	mov    $0x0,%eax
801023f2:	eb 03                	jmp    801023f7 <namex+0x115>
  }
  return ip;
801023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801023f7:	c9                   	leave  
801023f8:	c3                   	ret    

801023f9 <namei>:

struct inode*
namei(char *path)
{
801023f9:	55                   	push   %ebp
801023fa:	89 e5                	mov    %esp,%ebp
801023fc:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023ff:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102402:	89 44 24 08          	mov    %eax,0x8(%esp)
80102406:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010240d:	00 
8010240e:	8b 45 08             	mov    0x8(%ebp),%eax
80102411:	89 04 24             	mov    %eax,(%esp)
80102414:	e8 c9 fe ff ff       	call   801022e2 <namex>
}
80102419:	c9                   	leave  
8010241a:	c3                   	ret    

8010241b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010241b:	55                   	push   %ebp
8010241c:	89 e5                	mov    %esp,%ebp
8010241e:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102421:	8b 45 0c             	mov    0xc(%ebp),%eax
80102424:	89 44 24 08          	mov    %eax,0x8(%esp)
80102428:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010242f:	00 
80102430:	8b 45 08             	mov    0x8(%ebp),%eax
80102433:	89 04 24             	mov    %eax,(%esp)
80102436:	e8 a7 fe ff ff       	call   801022e2 <namex>
}
8010243b:	c9                   	leave  
8010243c:	c3                   	ret    

8010243d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010243d:	55                   	push   %ebp
8010243e:	89 e5                	mov    %esp,%ebp
80102440:	83 ec 14             	sub    $0x14,%esp
80102443:	8b 45 08             	mov    0x8(%ebp),%eax
80102446:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010244a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010244e:	89 c2                	mov    %eax,%edx
80102450:	ec                   	in     (%dx),%al
80102451:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102454:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102458:	c9                   	leave  
80102459:	c3                   	ret    

8010245a <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010245a:	55                   	push   %ebp
8010245b:	89 e5                	mov    %esp,%ebp
8010245d:	57                   	push   %edi
8010245e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010245f:	8b 55 08             	mov    0x8(%ebp),%edx
80102462:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102465:	8b 45 10             	mov    0x10(%ebp),%eax
80102468:	89 cb                	mov    %ecx,%ebx
8010246a:	89 df                	mov    %ebx,%edi
8010246c:	89 c1                	mov    %eax,%ecx
8010246e:	fc                   	cld    
8010246f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102471:	89 c8                	mov    %ecx,%eax
80102473:	89 fb                	mov    %edi,%ebx
80102475:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102478:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010247b:	5b                   	pop    %ebx
8010247c:	5f                   	pop    %edi
8010247d:	5d                   	pop    %ebp
8010247e:	c3                   	ret    

8010247f <outb>:

static inline void
outb(ushort port, uchar data)
{
8010247f:	55                   	push   %ebp
80102480:	89 e5                	mov    %esp,%ebp
80102482:	83 ec 08             	sub    $0x8,%esp
80102485:	8b 55 08             	mov    0x8(%ebp),%edx
80102488:	8b 45 0c             	mov    0xc(%ebp),%eax
8010248b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010248f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102492:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102496:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010249a:	ee                   	out    %al,(%dx)
}
8010249b:	c9                   	leave  
8010249c:	c3                   	ret    

8010249d <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010249d:	55                   	push   %ebp
8010249e:	89 e5                	mov    %esp,%ebp
801024a0:	56                   	push   %esi
801024a1:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024a2:	8b 55 08             	mov    0x8(%ebp),%edx
801024a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024a8:	8b 45 10             	mov    0x10(%ebp),%eax
801024ab:	89 cb                	mov    %ecx,%ebx
801024ad:	89 de                	mov    %ebx,%esi
801024af:	89 c1                	mov    %eax,%ecx
801024b1:	fc                   	cld    
801024b2:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024b4:	89 c8                	mov    %ecx,%eax
801024b6:	89 f3                	mov    %esi,%ebx
801024b8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024bb:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024be:	5b                   	pop    %ebx
801024bf:	5e                   	pop    %esi
801024c0:	5d                   	pop    %ebp
801024c1:	c3                   	ret    

801024c2 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024c2:	55                   	push   %ebp
801024c3:	89 e5                	mov    %esp,%ebp
801024c5:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024c8:	90                   	nop
801024c9:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024d0:	e8 68 ff ff ff       	call   8010243d <inb>
801024d5:	0f b6 c0             	movzbl %al,%eax
801024d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024db:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024de:	25 c0 00 00 00       	and    $0xc0,%eax
801024e3:	83 f8 40             	cmp    $0x40,%eax
801024e6:	75 e1                	jne    801024c9 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024ec:	74 11                	je     801024ff <idewait+0x3d>
801024ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024f1:	83 e0 21             	and    $0x21,%eax
801024f4:	85 c0                	test   %eax,%eax
801024f6:	74 07                	je     801024ff <idewait+0x3d>
    return -1;
801024f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024fd:	eb 05                	jmp    80102504 <idewait+0x42>
  return 0;
801024ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102504:	c9                   	leave  
80102505:	c3                   	ret    

80102506 <ideinit>:

void
ideinit(void)
{
80102506:	55                   	push   %ebp
80102507:	89 e5                	mov    %esp,%ebp
80102509:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010250c:	c7 44 24 04 3c 83 10 	movl   $0x8010833c,0x4(%esp)
80102513:	80 
80102514:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010251b:	e8 a3 26 00 00       	call   80104bc3 <initlock>
  picenable(IRQ_IDE);
80102520:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102527:	e8 39 15 00 00       	call   80103a65 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010252c:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80102531:	83 e8 01             	sub    $0x1,%eax
80102534:	89 44 24 04          	mov    %eax,0x4(%esp)
80102538:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010253f:	e8 0c 04 00 00       	call   80102950 <ioapicenable>
  idewait(0);
80102544:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010254b:	e8 72 ff ff ff       	call   801024c2 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102550:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102557:	00 
80102558:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010255f:	e8 1b ff ff ff       	call   8010247f <outb>
  for(i=0; i<1000; i++){
80102564:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010256b:	eb 20                	jmp    8010258d <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010256d:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102574:	e8 c4 fe ff ff       	call   8010243d <inb>
80102579:	84 c0                	test   %al,%al
8010257b:	74 0c                	je     80102589 <ideinit+0x83>
      havedisk1 = 1;
8010257d:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102584:	00 00 00 
      break;
80102587:	eb 0d                	jmp    80102596 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102589:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010258d:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102594:	7e d7                	jle    8010256d <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102596:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
8010259d:	00 
8010259e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025a5:	e8 d5 fe ff ff       	call   8010247f <outb>
}
801025aa:	c9                   	leave  
801025ab:	c3                   	ret    

801025ac <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025ac:	55                   	push   %ebp
801025ad:	89 e5                	mov    %esp,%ebp
801025af:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025b6:	75 0c                	jne    801025c4 <idestart+0x18>
    panic("idestart");
801025b8:	c7 04 24 40 83 10 80 	movl   $0x80108340,(%esp)
801025bf:	e8 76 df ff ff       	call   8010053a <panic>

  idewait(0);
801025c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025cb:	e8 f2 fe ff ff       	call   801024c2 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025d7:	00 
801025d8:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025df:	e8 9b fe ff ff       	call   8010247f <outb>
  outb(0x1f2, 1);  // number of sectors
801025e4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801025eb:	00 
801025ec:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801025f3:	e8 87 fe ff ff       	call   8010247f <outb>
  outb(0x1f3, b->sector & 0xff);
801025f8:	8b 45 08             	mov    0x8(%ebp),%eax
801025fb:	8b 40 08             	mov    0x8(%eax),%eax
801025fe:	0f b6 c0             	movzbl %al,%eax
80102601:	89 44 24 04          	mov    %eax,0x4(%esp)
80102605:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010260c:	e8 6e fe ff ff       	call   8010247f <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102611:	8b 45 08             	mov    0x8(%ebp),%eax
80102614:	8b 40 08             	mov    0x8(%eax),%eax
80102617:	c1 e8 08             	shr    $0x8,%eax
8010261a:	0f b6 c0             	movzbl %al,%eax
8010261d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102621:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102628:	e8 52 fe ff ff       	call   8010247f <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010262d:	8b 45 08             	mov    0x8(%ebp),%eax
80102630:	8b 40 08             	mov    0x8(%eax),%eax
80102633:	c1 e8 10             	shr    $0x10,%eax
80102636:	0f b6 c0             	movzbl %al,%eax
80102639:	89 44 24 04          	mov    %eax,0x4(%esp)
8010263d:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102644:	e8 36 fe ff ff       	call   8010247f <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102649:	8b 45 08             	mov    0x8(%ebp),%eax
8010264c:	8b 40 04             	mov    0x4(%eax),%eax
8010264f:	83 e0 01             	and    $0x1,%eax
80102652:	c1 e0 04             	shl    $0x4,%eax
80102655:	89 c2                	mov    %eax,%edx
80102657:	8b 45 08             	mov    0x8(%ebp),%eax
8010265a:	8b 40 08             	mov    0x8(%eax),%eax
8010265d:	c1 e8 18             	shr    $0x18,%eax
80102660:	83 e0 0f             	and    $0xf,%eax
80102663:	09 d0                	or     %edx,%eax
80102665:	83 c8 e0             	or     $0xffffffe0,%eax
80102668:	0f b6 c0             	movzbl %al,%eax
8010266b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010266f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102676:	e8 04 fe ff ff       	call   8010247f <outb>
  if(b->flags & B_DIRTY){
8010267b:	8b 45 08             	mov    0x8(%ebp),%eax
8010267e:	8b 00                	mov    (%eax),%eax
80102680:	83 e0 04             	and    $0x4,%eax
80102683:	85 c0                	test   %eax,%eax
80102685:	74 34                	je     801026bb <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102687:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010268e:	00 
8010268f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102696:	e8 e4 fd ff ff       	call   8010247f <outb>
    outsl(0x1f0, b->data, 512/4);
8010269b:	8b 45 08             	mov    0x8(%ebp),%eax
8010269e:	83 c0 18             	add    $0x18,%eax
801026a1:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026a8:	00 
801026a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801026ad:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026b4:	e8 e4 fd ff ff       	call   8010249d <outsl>
801026b9:	eb 14                	jmp    801026cf <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026bb:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026c2:	00 
801026c3:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026ca:	e8 b0 fd ff ff       	call   8010247f <outb>
  }
}
801026cf:	c9                   	leave  
801026d0:	c3                   	ret    

801026d1 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026d1:	55                   	push   %ebp
801026d2:	89 e5                	mov    %esp,%ebp
801026d4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026d7:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026de:	e8 01 25 00 00       	call   80104be4 <acquire>
  if((b = idequeue) == 0){
801026e3:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801026e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026ef:	75 11                	jne    80102702 <ideintr+0x31>
    release(&idelock);
801026f1:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026f8:	e8 49 25 00 00       	call   80104c46 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801026fd:	e9 90 00 00 00       	jmp    80102792 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102705:	8b 40 14             	mov    0x14(%eax),%eax
80102708:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102710:	8b 00                	mov    (%eax),%eax
80102712:	83 e0 04             	and    $0x4,%eax
80102715:	85 c0                	test   %eax,%eax
80102717:	75 2e                	jne    80102747 <ideintr+0x76>
80102719:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102720:	e8 9d fd ff ff       	call   801024c2 <idewait>
80102725:	85 c0                	test   %eax,%eax
80102727:	78 1e                	js     80102747 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272c:	83 c0 18             	add    $0x18,%eax
8010272f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102736:	00 
80102737:	89 44 24 04          	mov    %eax,0x4(%esp)
8010273b:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102742:	e8 13 fd ff ff       	call   8010245a <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274a:	8b 00                	mov    (%eax),%eax
8010274c:	83 c8 02             	or     $0x2,%eax
8010274f:	89 c2                	mov    %eax,%edx
80102751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102754:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102759:	8b 00                	mov    (%eax),%eax
8010275b:	83 e0 fb             	and    $0xfffffffb,%eax
8010275e:	89 c2                	mov    %eax,%edx
80102760:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102763:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102768:	89 04 24             	mov    %eax,(%esp)
8010276b:	e8 7d 22 00 00       	call   801049ed <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102770:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102775:	85 c0                	test   %eax,%eax
80102777:	74 0d                	je     80102786 <ideintr+0xb5>
    idestart(idequeue);
80102779:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010277e:	89 04 24             	mov    %eax,(%esp)
80102781:	e8 26 fe ff ff       	call   801025ac <idestart>

  release(&idelock);
80102786:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010278d:	e8 b4 24 00 00       	call   80104c46 <release>
}
80102792:	c9                   	leave  
80102793:	c3                   	ret    

80102794 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010279a:	8b 45 08             	mov    0x8(%ebp),%eax
8010279d:	8b 00                	mov    (%eax),%eax
8010279f:	83 e0 01             	and    $0x1,%eax
801027a2:	85 c0                	test   %eax,%eax
801027a4:	75 0c                	jne    801027b2 <iderw+0x1e>
    panic("iderw: buf not busy");
801027a6:	c7 04 24 49 83 10 80 	movl   $0x80108349,(%esp)
801027ad:	e8 88 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027b2:	8b 45 08             	mov    0x8(%ebp),%eax
801027b5:	8b 00                	mov    (%eax),%eax
801027b7:	83 e0 06             	and    $0x6,%eax
801027ba:	83 f8 02             	cmp    $0x2,%eax
801027bd:	75 0c                	jne    801027cb <iderw+0x37>
    panic("iderw: nothing to do");
801027bf:	c7 04 24 5d 83 10 80 	movl   $0x8010835d,(%esp)
801027c6:	e8 6f dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027cb:	8b 45 08             	mov    0x8(%ebp),%eax
801027ce:	8b 40 04             	mov    0x4(%eax),%eax
801027d1:	85 c0                	test   %eax,%eax
801027d3:	74 15                	je     801027ea <iderw+0x56>
801027d5:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801027da:	85 c0                	test   %eax,%eax
801027dc:	75 0c                	jne    801027ea <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027de:	c7 04 24 72 83 10 80 	movl   $0x80108372,(%esp)
801027e5:	e8 50 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC: acquire-lock
801027ea:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027f1:	e8 ee 23 00 00       	call   80104be4 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027f6:	8b 45 08             	mov    0x8(%ebp),%eax
801027f9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
80102800:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102807:	eb 0b                	jmp    80102814 <iderw+0x80>
80102809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010280c:	8b 00                	mov    (%eax),%eax
8010280e:	83 c0 14             	add    $0x14,%eax
80102811:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102817:	8b 00                	mov    (%eax),%eax
80102819:	85 c0                	test   %eax,%eax
8010281b:	75 ec                	jne    80102809 <iderw+0x75>
    ;
  *pp = b;
8010281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102820:	8b 55 08             	mov    0x8(%ebp),%edx
80102823:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102825:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010282a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010282d:	75 0d                	jne    8010283c <iderw+0xa8>
    idestart(b);
8010282f:	8b 45 08             	mov    0x8(%ebp),%eax
80102832:	89 04 24             	mov    %eax,(%esp)
80102835:	e8 72 fd ff ff       	call   801025ac <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010283a:	eb 15                	jmp    80102851 <iderw+0xbd>
8010283c:	eb 13                	jmp    80102851 <iderw+0xbd>
    sleep(b, &idelock);
8010283e:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102845:	80 
80102846:	8b 45 08             	mov    0x8(%ebp),%eax
80102849:	89 04 24             	mov    %eax,(%esp)
8010284c:	e8 c0 20 00 00       	call   80104911 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102851:	8b 45 08             	mov    0x8(%ebp),%eax
80102854:	8b 00                	mov    (%eax),%eax
80102856:	83 e0 06             	and    $0x6,%eax
80102859:	83 f8 02             	cmp    $0x2,%eax
8010285c:	75 e0                	jne    8010283e <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
8010285e:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102865:	e8 dc 23 00 00       	call   80104c46 <release>
}
8010286a:	c9                   	leave  
8010286b:	c3                   	ret    

8010286c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010286c:	55                   	push   %ebp
8010286d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010286f:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102874:	8b 55 08             	mov    0x8(%ebp),%edx
80102877:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102879:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010287e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102881:	5d                   	pop    %ebp
80102882:	c3                   	ret    

80102883 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102883:	55                   	push   %ebp
80102884:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102886:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010288b:	8b 55 08             	mov    0x8(%ebp),%edx
8010288e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102890:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102895:	8b 55 0c             	mov    0xc(%ebp),%edx
80102898:	89 50 10             	mov    %edx,0x10(%eax)
}
8010289b:	5d                   	pop    %ebp
8010289c:	c3                   	ret    

8010289d <ioapicinit>:

void
ioapicinit(void)
{
8010289d:	55                   	push   %ebp
8010289e:	89 e5                	mov    %esp,%ebp
801028a0:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028a3:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801028a8:	85 c0                	test   %eax,%eax
801028aa:	75 05                	jne    801028b1 <ioapicinit+0x14>
    return;
801028ac:	e9 9d 00 00 00       	jmp    8010294e <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028b1:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
801028b8:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028c2:	e8 a5 ff ff ff       	call   8010286c <ioapicread>
801028c7:	c1 e8 10             	shr    $0x10,%eax
801028ca:	25 ff 00 00 00       	and    $0xff,%eax
801028cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028d9:	e8 8e ff ff ff       	call   8010286c <ioapicread>
801028de:	c1 e8 18             	shr    $0x18,%eax
801028e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801028e4:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
801028eb:	0f b6 c0             	movzbl %al,%eax
801028ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028f1:	74 0c                	je     801028ff <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028f3:	c7 04 24 90 83 10 80 	movl   $0x80108390,(%esp)
801028fa:	e8 a1 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801028ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102906:	eb 3e                	jmp    80102946 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010290b:	83 c0 20             	add    $0x20,%eax
8010290e:	0d 00 00 01 00       	or     $0x10000,%eax
80102913:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102916:	83 c2 08             	add    $0x8,%edx
80102919:	01 d2                	add    %edx,%edx
8010291b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010291f:	89 14 24             	mov    %edx,(%esp)
80102922:	e8 5c ff ff ff       	call   80102883 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292a:	83 c0 08             	add    $0x8,%eax
8010292d:	01 c0                	add    %eax,%eax
8010292f:	83 c0 01             	add    $0x1,%eax
80102932:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102939:	00 
8010293a:	89 04 24             	mov    %eax,(%esp)
8010293d:	e8 41 ff ff ff       	call   80102883 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102942:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102949:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010294c:	7e ba                	jle    80102908 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010294e:	c9                   	leave  
8010294f:	c3                   	ret    

80102950 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102956:	a1 04 f9 10 80       	mov    0x8010f904,%eax
8010295b:	85 c0                	test   %eax,%eax
8010295d:	75 02                	jne    80102961 <ioapicenable+0x11>
    return;
8010295f:	eb 37                	jmp    80102998 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102961:	8b 45 08             	mov    0x8(%ebp),%eax
80102964:	83 c0 20             	add    $0x20,%eax
80102967:	8b 55 08             	mov    0x8(%ebp),%edx
8010296a:	83 c2 08             	add    $0x8,%edx
8010296d:	01 d2                	add    %edx,%edx
8010296f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102973:	89 14 24             	mov    %edx,(%esp)
80102976:	e8 08 ff ff ff       	call   80102883 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010297b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010297e:	c1 e0 18             	shl    $0x18,%eax
80102981:	8b 55 08             	mov    0x8(%ebp),%edx
80102984:	83 c2 08             	add    $0x8,%edx
80102987:	01 d2                	add    %edx,%edx
80102989:	83 c2 01             	add    $0x1,%edx
8010298c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102990:	89 14 24             	mov    %edx,(%esp)
80102993:	e8 eb fe ff ff       	call   80102883 <ioapicwrite>
}
80102998:	c9                   	leave  
80102999:	c3                   	ret    

8010299a <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010299a:	55                   	push   %ebp
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	8b 45 08             	mov    0x8(%ebp),%eax
801029a0:	05 00 00 00 80       	add    $0x80000000,%eax
801029a5:	5d                   	pop    %ebp
801029a6:	c3                   	ret    

801029a7 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029a7:	55                   	push   %ebp
801029a8:	89 e5                	mov    %esp,%ebp
801029aa:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029ad:	c7 44 24 04 c2 83 10 	movl   $0x801083c2,0x4(%esp)
801029b4:	80 
801029b5:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
801029bc:	e8 02 22 00 00       	call   80104bc3 <initlock>
  kmem.use_lock = 0;
801029c1:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
801029c8:	00 00 00 
  freerange(vstart, vend);
801029cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801029ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d2:	8b 45 08             	mov    0x8(%ebp),%eax
801029d5:	89 04 24             	mov    %eax,(%esp)
801029d8:	e8 26 00 00 00       	call   80102a03 <freerange>
}
801029dd:	c9                   	leave  
801029de:	c3                   	ret    

801029df <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029df:	55                   	push   %ebp
801029e0:	89 e5                	mov    %esp,%ebp
801029e2:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801029e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801029e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ec:	8b 45 08             	mov    0x8(%ebp),%eax
801029ef:	89 04 24             	mov    %eax,(%esp)
801029f2:	e8 0c 00 00 00       	call   80102a03 <freerange>
  kmem.use_lock = 1;
801029f7:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
801029fe:	00 00 00 
}
80102a01:	c9                   	leave  
80102a02:	c3                   	ret    

80102a03 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a03:	55                   	push   %ebp
80102a04:	89 e5                	mov    %esp,%ebp
80102a06:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a09:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0c:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a19:	eb 12                	jmp    80102a2d <freerange+0x2a>
    kfree(p);
80102a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a1e:	89 04 24             	mov    %eax,(%esp)
80102a21:	e8 16 00 00 00       	call   80102a3c <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a26:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a30:	05 00 10 00 00       	add    $0x1000,%eax
80102a35:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a38:	76 e1                	jbe    80102a1b <freerange+0x18>
    kfree(p);
}
80102a3a:	c9                   	leave  
80102a3b:	c3                   	ret    

80102a3c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a3c:	55                   	push   %ebp
80102a3d:	89 e5                	mov    %esp,%ebp
80102a3f:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a42:	8b 45 08             	mov    0x8(%ebp),%eax
80102a45:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a4a:	85 c0                	test   %eax,%eax
80102a4c:	75 1b                	jne    80102a69 <kfree+0x2d>
80102a4e:	81 7d 08 fc 29 11 80 	cmpl   $0x801129fc,0x8(%ebp)
80102a55:	72 12                	jb     80102a69 <kfree+0x2d>
80102a57:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5a:	89 04 24             	mov    %eax,(%esp)
80102a5d:	e8 38 ff ff ff       	call   8010299a <v2p>
80102a62:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a67:	76 0c                	jbe    80102a75 <kfree+0x39>
    panic("kfree");
80102a69:	c7 04 24 c7 83 10 80 	movl   $0x801083c7,(%esp)
80102a70:	e8 c5 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a75:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a7c:	00 
80102a7d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a84:	00 
80102a85:	8b 45 08             	mov    0x8(%ebp),%eax
80102a88:	89 04 24             	mov    %eax,(%esp)
80102a8b:	e8 a8 23 00 00       	call   80104e38 <memset>

  if(kmem.use_lock)
80102a90:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102a95:	85 c0                	test   %eax,%eax
80102a97:	74 0c                	je     80102aa5 <kfree+0x69>
    acquire(&kmem.lock);
80102a99:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102aa0:	e8 3f 21 00 00       	call   80104be4 <acquire>
  r = (struct run*)v;
80102aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102aab:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab4:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab9:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102abe:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102ac3:	85 c0                	test   %eax,%eax
80102ac5:	74 0c                	je     80102ad3 <kfree+0x97>
    release(&kmem.lock);
80102ac7:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102ace:	e8 73 21 00 00       	call   80104c46 <release>
}
80102ad3:	c9                   	leave  
80102ad4:	c3                   	ret    

80102ad5 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ad5:	55                   	push   %ebp
80102ad6:	89 e5                	mov    %esp,%ebp
80102ad8:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102adb:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102ae0:	85 c0                	test   %eax,%eax
80102ae2:	74 0c                	je     80102af0 <kalloc+0x1b>
    acquire(&kmem.lock);
80102ae4:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102aeb:	e8 f4 20 00 00       	call   80104be4 <acquire>
  r = kmem.freelist;
80102af0:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102af8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102afc:	74 0a                	je     80102b08 <kalloc+0x33>
    kmem.freelist = r->next;
80102afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b01:	8b 00                	mov    (%eax),%eax
80102b03:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b08:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b0d:	85 c0                	test   %eax,%eax
80102b0f:	74 0c                	je     80102b1d <kalloc+0x48>
    release(&kmem.lock);
80102b11:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b18:	e8 29 21 00 00       	call   80104c46 <release>
  return (char*)r;
80102b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b20:	c9                   	leave  
80102b21:	c3                   	ret    

80102b22 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b22:	55                   	push   %ebp
80102b23:	89 e5                	mov    %esp,%ebp
80102b25:	83 ec 14             	sub    $0x14,%esp
80102b28:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b33:	89 c2                	mov    %eax,%edx
80102b35:	ec                   	in     (%dx),%al
80102b36:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b39:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b3d:	c9                   	leave  
80102b3e:	c3                   	ret    

80102b3f <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b3f:	55                   	push   %ebp
80102b40:	89 e5                	mov    %esp,%ebp
80102b42:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b45:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b4c:	e8 d1 ff ff ff       	call   80102b22 <inb>
80102b51:	0f b6 c0             	movzbl %al,%eax
80102b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5a:	83 e0 01             	and    $0x1,%eax
80102b5d:	85 c0                	test   %eax,%eax
80102b5f:	75 0a                	jne    80102b6b <kbdgetc+0x2c>
    return -1;
80102b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b66:	e9 25 01 00 00       	jmp    80102c90 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b6b:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b72:	e8 ab ff ff ff       	call   80102b22 <inb>
80102b77:	0f b6 c0             	movzbl %al,%eax
80102b7a:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b7d:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102b84:	75 17                	jne    80102b9d <kbdgetc+0x5e>
    shift |= E0ESC;
80102b86:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102b8b:	83 c8 40             	or     $0x40,%eax
80102b8e:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102b93:	b8 00 00 00 00       	mov    $0x0,%eax
80102b98:	e9 f3 00 00 00       	jmp    80102c90 <kbdgetc+0x151>
  } else if(data & 0x80){
80102b9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ba0:	25 80 00 00 00       	and    $0x80,%eax
80102ba5:	85 c0                	test   %eax,%eax
80102ba7:	74 45                	je     80102bee <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ba9:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bae:	83 e0 40             	and    $0x40,%eax
80102bb1:	85 c0                	test   %eax,%eax
80102bb3:	75 08                	jne    80102bbd <kbdgetc+0x7e>
80102bb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bb8:	83 e0 7f             	and    $0x7f,%eax
80102bbb:	eb 03                	jmp    80102bc0 <kbdgetc+0x81>
80102bbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bc6:	05 20 90 10 80       	add    $0x80109020,%eax
80102bcb:	0f b6 00             	movzbl (%eax),%eax
80102bce:	83 c8 40             	or     $0x40,%eax
80102bd1:	0f b6 c0             	movzbl %al,%eax
80102bd4:	f7 d0                	not    %eax
80102bd6:	89 c2                	mov    %eax,%edx
80102bd8:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bdd:	21 d0                	and    %edx,%eax
80102bdf:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102be4:	b8 00 00 00 00       	mov    $0x0,%eax
80102be9:	e9 a2 00 00 00       	jmp    80102c90 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102bee:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bf3:	83 e0 40             	and    $0x40,%eax
80102bf6:	85 c0                	test   %eax,%eax
80102bf8:	74 14                	je     80102c0e <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bfa:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c01:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c06:	83 e0 bf             	and    $0xffffffbf,%eax
80102c09:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c11:	05 20 90 10 80       	add    $0x80109020,%eax
80102c16:	0f b6 00             	movzbl (%eax),%eax
80102c19:	0f b6 d0             	movzbl %al,%edx
80102c1c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c21:	09 d0                	or     %edx,%eax
80102c23:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c28:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c2b:	05 20 91 10 80       	add    $0x80109120,%eax
80102c30:	0f b6 00             	movzbl (%eax),%eax
80102c33:	0f b6 d0             	movzbl %al,%edx
80102c36:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c3b:	31 d0                	xor    %edx,%eax
80102c3d:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c42:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c47:	83 e0 03             	and    $0x3,%eax
80102c4a:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c54:	01 d0                	add    %edx,%eax
80102c56:	0f b6 00             	movzbl (%eax),%eax
80102c59:	0f b6 c0             	movzbl %al,%eax
80102c5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c5f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c64:	83 e0 08             	and    $0x8,%eax
80102c67:	85 c0                	test   %eax,%eax
80102c69:	74 22                	je     80102c8d <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c6b:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c6f:	76 0c                	jbe    80102c7d <kbdgetc+0x13e>
80102c71:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c75:	77 06                	ja     80102c7d <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c77:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c7b:	eb 10                	jmp    80102c8d <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c7d:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102c81:	76 0a                	jbe    80102c8d <kbdgetc+0x14e>
80102c83:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102c87:	77 04                	ja     80102c8d <kbdgetc+0x14e>
      c += 'a' - 'A';
80102c89:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102c8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102c90:	c9                   	leave  
80102c91:	c3                   	ret    

80102c92 <kbdintr>:

void
kbdintr(void)
{
80102c92:	55                   	push   %ebp
80102c93:	89 e5                	mov    %esp,%ebp
80102c95:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102c98:	c7 04 24 3f 2b 10 80 	movl   $0x80102b3f,(%esp)
80102c9f:	e8 09 db ff ff       	call   801007ad <consoleintr>
}
80102ca4:	c9                   	leave  
80102ca5:	c3                   	ret    

80102ca6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ca6:	55                   	push   %ebp
80102ca7:	89 e5                	mov    %esp,%ebp
80102ca9:	83 ec 08             	sub    $0x8,%esp
80102cac:	8b 55 08             	mov    0x8(%ebp),%edx
80102caf:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cb2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cb6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cbd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cc1:	ee                   	out    %al,(%dx)
}
80102cc2:	c9                   	leave  
80102cc3:	c3                   	ret    

80102cc4 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cc4:	55                   	push   %ebp
80102cc5:	89 e5                	mov    %esp,%ebp
80102cc7:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102cca:	9c                   	pushf  
80102ccb:	58                   	pop    %eax
80102ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102cd2:	c9                   	leave  
80102cd3:	c3                   	ret    

80102cd4 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102cd4:	55                   	push   %ebp
80102cd5:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102cd7:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102cdc:	8b 55 08             	mov    0x8(%ebp),%edx
80102cdf:	c1 e2 02             	shl    $0x2,%edx
80102ce2:	01 c2                	add    %eax,%edx
80102ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ce7:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ce9:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102cee:	83 c0 20             	add    $0x20,%eax
80102cf1:	8b 00                	mov    (%eax),%eax
}
80102cf3:	5d                   	pop    %ebp
80102cf4:	c3                   	ret    

80102cf5 <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80102cf5:	55                   	push   %ebp
80102cf6:	89 e5                	mov    %esp,%ebp
80102cf8:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102cfb:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d00:	85 c0                	test   %eax,%eax
80102d02:	75 05                	jne    80102d09 <lapicinit+0x14>
    return;
80102d04:	e9 43 01 00 00       	jmp    80102e4c <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d09:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d10:	00 
80102d11:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d18:	e8 b7 ff ff ff       	call   80102cd4 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d1d:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d24:	00 
80102d25:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d2c:	e8 a3 ff ff ff       	call   80102cd4 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d31:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d38:	00 
80102d39:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d40:	e8 8f ff ff ff       	call   80102cd4 <lapicw>
  lapicw(TICR, 10000000); 
80102d45:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d4c:	00 
80102d4d:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d54:	e8 7b ff ff ff       	call   80102cd4 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d59:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d60:	00 
80102d61:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d68:	e8 67 ff ff ff       	call   80102cd4 <lapicw>
  lapicw(LINT1, MASKED);
80102d6d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d74:	00 
80102d75:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102d7c:	e8 53 ff ff ff       	call   80102cd4 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d81:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d86:	83 c0 30             	add    $0x30,%eax
80102d89:	8b 00                	mov    (%eax),%eax
80102d8b:	c1 e8 10             	shr    $0x10,%eax
80102d8e:	0f b6 c0             	movzbl %al,%eax
80102d91:	83 f8 03             	cmp    $0x3,%eax
80102d94:	76 14                	jbe    80102daa <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102d96:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d9d:	00 
80102d9e:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102da5:	e8 2a ff ff ff       	call   80102cd4 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102daa:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102db1:	00 
80102db2:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102db9:	e8 16 ff ff ff       	call   80102cd4 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dbe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dc5:	00 
80102dc6:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dcd:	e8 02 ff ff ff       	call   80102cd4 <lapicw>
  lapicw(ESR, 0);
80102dd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dd9:	00 
80102dda:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102de1:	e8 ee fe ff ff       	call   80102cd4 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102de6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ded:	00 
80102dee:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102df5:	e8 da fe ff ff       	call   80102cd4 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e01:	00 
80102e02:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e09:	e8 c6 fe ff ff       	call   80102cd4 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e0e:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e15:	00 
80102e16:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e1d:	e8 b2 fe ff ff       	call   80102cd4 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e22:	90                   	nop
80102e23:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e28:	05 00 03 00 00       	add    $0x300,%eax
80102e2d:	8b 00                	mov    (%eax),%eax
80102e2f:	25 00 10 00 00       	and    $0x1000,%eax
80102e34:	85 c0                	test   %eax,%eax
80102e36:	75 eb                	jne    80102e23 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3f:	00 
80102e40:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e47:	e8 88 fe ff ff       	call   80102cd4 <lapicw>
}
80102e4c:	c9                   	leave  
80102e4d:	c3                   	ret    

80102e4e <cpunum>:

int
cpunum(void)
{
80102e4e:	55                   	push   %ebp
80102e4f:	89 e5                	mov    %esp,%ebp
80102e51:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e54:	e8 6b fe ff ff       	call   80102cc4 <readeflags>
80102e59:	25 00 02 00 00       	and    $0x200,%eax
80102e5e:	85 c0                	test   %eax,%eax
80102e60:	74 25                	je     80102e87 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e62:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102e67:	8d 50 01             	lea    0x1(%eax),%edx
80102e6a:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102e70:	85 c0                	test   %eax,%eax
80102e72:	75 13                	jne    80102e87 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e74:	8b 45 04             	mov    0x4(%ebp),%eax
80102e77:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e7b:	c7 04 24 d0 83 10 80 	movl   $0x801083d0,(%esp)
80102e82:	e8 19 d5 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e87:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e8c:	85 c0                	test   %eax,%eax
80102e8e:	74 0f                	je     80102e9f <cpunum+0x51>
    return lapic[ID]>>24;
80102e90:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e95:	83 c0 20             	add    $0x20,%eax
80102e98:	8b 00                	mov    (%eax),%eax
80102e9a:	c1 e8 18             	shr    $0x18,%eax
80102e9d:	eb 05                	jmp    80102ea4 <cpunum+0x56>
  return 0;
80102e9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ea4:	c9                   	leave  
80102ea5:	c3                   	ret    

80102ea6 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ea6:	55                   	push   %ebp
80102ea7:	89 e5                	mov    %esp,%ebp
80102ea9:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102eac:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102eb1:	85 c0                	test   %eax,%eax
80102eb3:	74 14                	je     80102ec9 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102eb5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ebc:	00 
80102ebd:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ec4:	e8 0b fe ff ff       	call   80102cd4 <lapicw>
}
80102ec9:	c9                   	leave  
80102eca:	c3                   	ret    

80102ecb <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ecb:	55                   	push   %ebp
80102ecc:	89 e5                	mov    %esp,%ebp
}
80102ece:	5d                   	pop    %ebp
80102ecf:	c3                   	ret    

80102ed0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	83 ec 1c             	sub    $0x1c,%esp
80102ed6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ed9:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102edc:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102ee3:	00 
80102ee4:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102eeb:	e8 b6 fd ff ff       	call   80102ca6 <outb>
  outb(IO_RTC+1, 0x0A);
80102ef0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102ef7:	00 
80102ef8:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102eff:	e8 a2 fd ff ff       	call   80102ca6 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f04:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f0e:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f13:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f16:	8d 50 02             	lea    0x2(%eax),%edx
80102f19:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f1c:	c1 e8 04             	shr    $0x4,%eax
80102f1f:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f22:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f26:	c1 e0 18             	shl    $0x18,%eax
80102f29:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f2d:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f34:	e8 9b fd ff ff       	call   80102cd4 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f39:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f40:	00 
80102f41:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f48:	e8 87 fd ff ff       	call   80102cd4 <lapicw>
  microdelay(200);
80102f4d:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f54:	e8 72 ff ff ff       	call   80102ecb <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f59:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f60:	00 
80102f61:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f68:	e8 67 fd ff ff       	call   80102cd4 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f6d:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102f74:	e8 52 ff ff ff       	call   80102ecb <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102f79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102f80:	eb 40                	jmp    80102fc2 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102f82:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f86:	c1 e0 18             	shl    $0x18,%eax
80102f89:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f8d:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f94:	e8 3b fd ff ff       	call   80102cd4 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f99:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f9c:	c1 e8 0c             	shr    $0xc,%eax
80102f9f:	80 cc 06             	or     $0x6,%ah
80102fa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fa6:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fad:	e8 22 fd ff ff       	call   80102cd4 <lapicw>
    microdelay(200);
80102fb2:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fb9:	e8 0d ff ff ff       	call   80102ecb <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fbe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102fc2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102fc6:	7e ba                	jle    80102f82 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102fc8:	c9                   	leave  
80102fc9:	c3                   	ret    

80102fca <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102fca:	55                   	push   %ebp
80102fcb:	89 e5                	mov    %esp,%ebp
80102fcd:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102fd0:	c7 44 24 04 fc 83 10 	movl   $0x801083fc,0x4(%esp)
80102fd7:	80 
80102fd8:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80102fdf:	e8 df 1b 00 00       	call   80104bc3 <initlock>
  readsb(ROOTDEV, &sb);
80102fe4:	8d 45 e8             	lea    -0x18(%ebp),%eax
80102fe7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102feb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102ff2:	e8 ed e2 ff ff       	call   801012e4 <readsb>
  log.start = sb.size - sb.nlog;
80102ff7:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ffd:	29 c2                	sub    %eax,%edx
80102fff:	89 d0                	mov    %edx,%eax
80103001:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
80103006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103009:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
8010300e:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
80103015:	00 00 00 
  recover_from_log();
80103018:	e8 9a 01 00 00       	call   801031b7 <recover_from_log>
}
8010301d:	c9                   	leave  
8010301e:	c3                   	ret    

8010301f <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010301f:	55                   	push   %ebp
80103020:	89 e5                	mov    %esp,%ebp
80103022:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103025:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010302c:	e9 8c 00 00 00       	jmp    801030bd <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103031:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
80103037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010303a:	01 d0                	add    %edx,%eax
8010303c:	83 c0 01             	add    $0x1,%eax
8010303f:	89 c2                	mov    %eax,%edx
80103041:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103046:	89 54 24 04          	mov    %edx,0x4(%esp)
8010304a:	89 04 24             	mov    %eax,(%esp)
8010304d:	e8 54 d1 ff ff       	call   801001a6 <bread>
80103052:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103058:	83 c0 10             	add    $0x10,%eax
8010305b:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
80103062:	89 c2                	mov    %eax,%edx
80103064:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103069:	89 54 24 04          	mov    %edx,0x4(%esp)
8010306d:	89 04 24             	mov    %eax,(%esp)
80103070:	e8 31 d1 ff ff       	call   801001a6 <bread>
80103075:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010307b:	8d 50 18             	lea    0x18(%eax),%edx
8010307e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103081:	83 c0 18             	add    $0x18,%eax
80103084:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010308b:	00 
8010308c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103090:	89 04 24             	mov    %eax,(%esp)
80103093:	e8 6f 1e 00 00       	call   80104f07 <memmove>
    bwrite(dbuf);  // write dst to disk
80103098:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010309b:	89 04 24             	mov    %eax,(%esp)
8010309e:	e8 3a d1 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030a6:	89 04 24             	mov    %eax,(%esp)
801030a9:	e8 69 d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030b1:	89 04 24             	mov    %eax,(%esp)
801030b4:	e8 5e d1 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801030bd:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801030c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030c5:	0f 8f 66 ff ff ff    	jg     80103031 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801030cb:	c9                   	leave  
801030cc:	c3                   	ret    

801030cd <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030cd:	55                   	push   %ebp
801030ce:	89 e5                	mov    %esp,%ebp
801030d0:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801030d3:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801030d8:	89 c2                	mov    %eax,%edx
801030da:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030df:	89 54 24 04          	mov    %edx,0x4(%esp)
801030e3:	89 04 24             	mov    %eax,(%esp)
801030e6:	e8 bb d0 ff ff       	call   801001a6 <bread>
801030eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030f1:	83 c0 18             	add    $0x18,%eax
801030f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801030f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030fa:	8b 00                	mov    (%eax),%eax
801030fc:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
80103101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103108:	eb 1b                	jmp    80103125 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010310a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010310d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103110:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103114:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103117:	83 c2 10             	add    $0x10,%edx
8010311a:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103121:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103125:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010312a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010312d:	7f db                	jg     8010310a <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
8010312f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103132:	89 04 24             	mov    %eax,(%esp)
80103135:	e8 dd d0 ff ff       	call   80100217 <brelse>
}
8010313a:	c9                   	leave  
8010313b:	c3                   	ret    

8010313c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010313c:	55                   	push   %ebp
8010313d:	89 e5                	mov    %esp,%ebp
8010313f:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103142:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103147:	89 c2                	mov    %eax,%edx
80103149:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
8010314e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103152:	89 04 24             	mov    %eax,(%esp)
80103155:	e8 4c d0 ff ff       	call   801001a6 <bread>
8010315a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103160:	83 c0 18             	add    $0x18,%eax
80103163:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103166:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
8010316c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010316f:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103171:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103178:	eb 1b                	jmp    80103195 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
8010317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010317d:	83 c0 10             	add    $0x10,%eax
80103180:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
80103187:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010318a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010318d:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103191:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103195:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010319a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010319d:	7f db                	jg     8010317a <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
8010319f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a2:	89 04 24             	mov    %eax,(%esp)
801031a5:	e8 33 d0 ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031ad:	89 04 24             	mov    %eax,(%esp)
801031b0:	e8 62 d0 ff ff       	call   80100217 <brelse>
}
801031b5:	c9                   	leave  
801031b6:	c3                   	ret    

801031b7 <recover_from_log>:

static void
recover_from_log(void)
{
801031b7:	55                   	push   %ebp
801031b8:	89 e5                	mov    %esp,%ebp
801031ba:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031bd:	e8 0b ff ff ff       	call   801030cd <read_head>
  install_trans(); // if committed, copy from log to disk
801031c2:	e8 58 fe ff ff       	call   8010301f <install_trans>
  log.lh.n = 0;
801031c7:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
801031ce:	00 00 00 
  write_head(); // clear the log
801031d1:	e8 66 ff ff ff       	call   8010313c <write_head>
}
801031d6:	c9                   	leave  
801031d7:	c3                   	ret    

801031d8 <begin_trans>:

void
begin_trans(void)
{
801031d8:	55                   	push   %ebp
801031d9:	89 e5                	mov    %esp,%ebp
801031db:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801031de:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801031e5:	e8 fa 19 00 00       	call   80104be4 <acquire>
  while (log.busy) {
801031ea:	eb 14                	jmp    80103200 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031ec:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
801031f3:	80 
801031f4:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801031fb:	e8 11 17 00 00       	call   80104911 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103200:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103205:	85 c0                	test   %eax,%eax
80103207:	75 e3                	jne    801031ec <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103209:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
80103210:	00 00 00 
  release(&log.lock);
80103213:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010321a:	e8 27 1a 00 00       	call   80104c46 <release>
}
8010321f:	c9                   	leave  
80103220:	c3                   	ret    

80103221 <commit_trans>:

void
commit_trans(void)
{
80103221:	55                   	push   %ebp
80103222:	89 e5                	mov    %esp,%ebp
80103224:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103227:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010322c:	85 c0                	test   %eax,%eax
8010322e:	7e 19                	jle    80103249 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103230:	e8 07 ff ff ff       	call   8010313c <write_head>
    install_trans(); // Now install writes to home locations
80103235:	e8 e5 fd ff ff       	call   8010301f <install_trans>
    log.lh.n = 0; 
8010323a:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103241:	00 00 00 
    write_head();    // Erase the transaction from the log
80103244:	e8 f3 fe ff ff       	call   8010313c <write_head>
  }
  
  acquire(&log.lock);
80103249:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103250:	e8 8f 19 00 00       	call   80104be4 <acquire>
  log.busy = 0;
80103255:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
8010325c:	00 00 00 
  wakeup(&log);
8010325f:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103266:	e8 82 17 00 00       	call   801049ed <wakeup>
  release(&log.lock);
8010326b:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103272:	e8 cf 19 00 00       	call   80104c46 <release>
}
80103277:	c9                   	leave  
80103278:	c3                   	ret    

80103279 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103279:	55                   	push   %ebp
8010327a:	89 e5                	mov    %esp,%ebp
8010327c:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010327f:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103284:	83 f8 09             	cmp    $0x9,%eax
80103287:	7f 12                	jg     8010329b <log_write+0x22>
80103289:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010328e:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
80103294:	83 ea 01             	sub    $0x1,%edx
80103297:	39 d0                	cmp    %edx,%eax
80103299:	7c 0c                	jl     801032a7 <log_write+0x2e>
    panic("too big a transaction");
8010329b:	c7 04 24 00 84 10 80 	movl   $0x80108400,(%esp)
801032a2:	e8 93 d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032a7:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032ac:	85 c0                	test   %eax,%eax
801032ae:	75 0c                	jne    801032bc <log_write+0x43>
    panic("write outside of trans");
801032b0:	c7 04 24 16 84 10 80 	movl   $0x80108416,(%esp)
801032b7:	e8 7e d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801032bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032c3:	eb 1f                	jmp    801032e4 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c8:	83 c0 10             	add    $0x10,%eax
801032cb:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801032d2:	89 c2                	mov    %eax,%edx
801032d4:	8b 45 08             	mov    0x8(%ebp),%eax
801032d7:	8b 40 08             	mov    0x8(%eax),%eax
801032da:	39 c2                	cmp    %eax,%edx
801032dc:	75 02                	jne    801032e0 <log_write+0x67>
      break;
801032de:	eb 0e                	jmp    801032ee <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801032e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032e4:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801032ec:	7f d7                	jg     801032c5 <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
801032ee:	8b 45 08             	mov    0x8(%ebp),%eax
801032f1:	8b 40 08             	mov    0x8(%eax),%eax
801032f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032f7:	83 c2 10             	add    $0x10,%edx
801032fa:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103301:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
80103307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010330a:	01 d0                	add    %edx,%eax
8010330c:	83 c0 01             	add    $0x1,%eax
8010330f:	89 c2                	mov    %eax,%edx
80103311:	8b 45 08             	mov    0x8(%ebp),%eax
80103314:	8b 40 04             	mov    0x4(%eax),%eax
80103317:	89 54 24 04          	mov    %edx,0x4(%esp)
8010331b:	89 04 24             	mov    %eax,(%esp)
8010331e:	e8 83 ce ff ff       	call   801001a6 <bread>
80103323:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103326:	8b 45 08             	mov    0x8(%ebp),%eax
80103329:	8d 50 18             	lea    0x18(%eax),%edx
8010332c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010332f:	83 c0 18             	add    $0x18,%eax
80103332:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103339:	00 
8010333a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010333e:	89 04 24             	mov    %eax,(%esp)
80103341:	e8 c1 1b 00 00       	call   80104f07 <memmove>
  bwrite(lbuf);
80103346:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103349:	89 04 24             	mov    %eax,(%esp)
8010334c:	e8 8c ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103354:	89 04 24             	mov    %eax,(%esp)
80103357:	e8 bb ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
8010335c:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103361:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103364:	75 0d                	jne    80103373 <log_write+0xfa>
    log.lh.n++;
80103366:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010336b:	83 c0 01             	add    $0x1,%eax
8010336e:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
80103373:	8b 45 08             	mov    0x8(%ebp),%eax
80103376:	8b 00                	mov    (%eax),%eax
80103378:	83 c8 04             	or     $0x4,%eax
8010337b:	89 c2                	mov    %eax,%edx
8010337d:	8b 45 08             	mov    0x8(%ebp),%eax
80103380:	89 10                	mov    %edx,(%eax)
}
80103382:	c9                   	leave  
80103383:	c3                   	ret    

80103384 <v2p>:
80103384:	55                   	push   %ebp
80103385:	89 e5                	mov    %esp,%ebp
80103387:	8b 45 08             	mov    0x8(%ebp),%eax
8010338a:	05 00 00 00 80       	add    $0x80000000,%eax
8010338f:	5d                   	pop    %ebp
80103390:	c3                   	ret    

80103391 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103391:	55                   	push   %ebp
80103392:	89 e5                	mov    %esp,%ebp
80103394:	8b 45 08             	mov    0x8(%ebp),%eax
80103397:	05 00 00 00 80       	add    $0x80000000,%eax
8010339c:	5d                   	pop    %ebp
8010339d:	c3                   	ret    

8010339e <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010339e:	55                   	push   %ebp
8010339f:	89 e5                	mov    %esp,%ebp
801033a1:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033a4:	8b 55 08             	mov    0x8(%ebp),%edx
801033a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801033aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033ad:	f0 87 02             	lock xchg %eax,(%edx)
801033b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801033b6:	c9                   	leave  
801033b7:	c3                   	ret    

801033b8 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801033b8:	55                   	push   %ebp
801033b9:	89 e5                	mov    %esp,%ebp
801033bb:	83 e4 f0             	and    $0xfffffff0,%esp
801033be:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033c1:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801033c8:	80 
801033c9:	c7 04 24 fc 29 11 80 	movl   $0x801129fc,(%esp)
801033d0:	e8 d2 f5 ff ff       	call   801029a7 <kinit1>
  kvmalloc();      // kernel page table
801033d5:	e8 7a 46 00 00       	call   80107a54 <kvmalloc>
  mpinit();        // collect info about this machine
801033da:	e8 56 04 00 00       	call   80103835 <mpinit>
  lapicinit(mpbcpu());
801033df:	e8 1f 02 00 00       	call   80103603 <mpbcpu>
801033e4:	89 04 24             	mov    %eax,(%esp)
801033e7:	e8 09 f9 ff ff       	call   80102cf5 <lapicinit>
  seginit();       // set up segments
801033ec:	e8 f6 3f 00 00       	call   801073e7 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033f7:	0f b6 00             	movzbl (%eax),%eax
801033fa:	0f b6 c0             	movzbl %al,%eax
801033fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103401:	c7 04 24 2d 84 10 80 	movl   $0x8010842d,(%esp)
80103408:	e8 93 cf ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
8010340d:	e8 81 06 00 00       	call   80103a93 <picinit>
  ioapicinit();    // another interrupt controller
80103412:	e8 86 f4 ff ff       	call   8010289d <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103417:	e8 65 d6 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
8010341c:	e8 15 33 00 00       	call   80106736 <uartinit>
  pinit();         // process table
80103421:	e8 77 0b 00 00       	call   80103f9d <pinit>
  tvinit();        // trap vectors
80103426:	e8 88 2e 00 00       	call   801062b3 <tvinit>
  binit();         // buffer cache
8010342b:	e8 04 cc ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103430:	e8 c8 da ff ff       	call   80100efd <fileinit>
  iinit();         // inode cache
80103435:	e8 5d e1 ff ff       	call   80101597 <iinit>
  ideinit();       // disk
8010343a:	e8 c7 f0 ff ff       	call   80102506 <ideinit>
  if(!ismp)
8010343f:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103444:	85 c0                	test   %eax,%eax
80103446:	75 05                	jne    8010344d <main+0x95>
    timerinit();   // uniprocessor timer
80103448:	e8 b1 2d 00 00       	call   801061fe <timerinit>
  startothers();   // start other processors
8010344d:	e8 87 00 00 00       	call   801034d9 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103452:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103459:	8e 
8010345a:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103461:	e8 79 f5 ff ff       	call   801029df <kinit2>
  userinit();      // first user process
80103466:	e8 67 0c 00 00       	call   801040d2 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010346b:	e8 22 00 00 00       	call   80103492 <mpmain>

80103470 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	83 ec 18             	sub    $0x18,%esp
  switchkvm(); 
80103476:	e8 f0 45 00 00       	call   80107a6b <switchkvm>
  seginit();
8010347b:	e8 67 3f 00 00       	call   801073e7 <seginit>
  lapicinit(cpunum());
80103480:	e8 c9 f9 ff ff       	call   80102e4e <cpunum>
80103485:	89 04 24             	mov    %eax,(%esp)
80103488:	e8 68 f8 ff ff       	call   80102cf5 <lapicinit>
  mpmain();
8010348d:	e8 00 00 00 00       	call   80103492 <mpmain>

80103492 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103492:	55                   	push   %ebp
80103493:	89 e5                	mov    %esp,%ebp
80103495:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103498:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010349e:	0f b6 00             	movzbl (%eax),%eax
801034a1:	0f b6 c0             	movzbl %al,%eax
801034a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801034a8:	c7 04 24 44 84 10 80 	movl   $0x80108444,(%esp)
801034af:	e8 ec ce ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801034b4:	e8 6e 2f 00 00       	call   80106427 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034b9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034bf:	05 a8 00 00 00       	add    $0xa8,%eax
801034c4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034cb:	00 
801034cc:	89 04 24             	mov    %eax,(%esp)
801034cf:	e8 ca fe ff ff       	call   8010339e <xchg>
  scheduler();     // start running processes
801034d4:	e8 f8 11 00 00       	call   801046d1 <scheduler>

801034d9 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034d9:	55                   	push   %ebp
801034da:	89 e5                	mov    %esp,%ebp
801034dc:	53                   	push   %ebx
801034dd:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801034e0:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801034e7:	e8 a5 fe ff ff       	call   80103391 <p2v>
801034ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801034ef:	b8 8a 00 00 00       	mov    $0x8a,%eax
801034f4:	89 44 24 08          	mov    %eax,0x8(%esp)
801034f8:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
801034ff:	80 
80103500:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103503:	89 04 24             	mov    %eax,(%esp)
80103506:	e8 fc 19 00 00       	call   80104f07 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010350b:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
80103512:	e9 85 00 00 00       	jmp    8010359c <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103517:	e8 32 f9 ff ff       	call   80102e4e <cpunum>
8010351c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103522:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103527:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010352a:	75 02                	jne    8010352e <startothers+0x55>
      continue;
8010352c:	eb 67                	jmp    80103595 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010352e:	e8 a2 f5 ff ff       	call   80102ad5 <kalloc>
80103533:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103536:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103539:	83 e8 04             	sub    $0x4,%eax
8010353c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010353f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103545:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103547:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010354a:	83 e8 08             	sub    $0x8,%eax
8010354d:	c7 00 70 34 10 80    	movl   $0x80103470,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103553:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103556:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103559:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
80103560:	e8 1f fe ff ff       	call   80103384 <v2p>
80103565:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103567:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010356a:	89 04 24             	mov    %eax,(%esp)
8010356d:	e8 12 fe ff ff       	call   80103384 <v2p>
80103572:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103575:	0f b6 12             	movzbl (%edx),%edx
80103578:	0f b6 d2             	movzbl %dl,%edx
8010357b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010357f:	89 14 24             	mov    %edx,(%esp)
80103582:	e8 49 f9 ff ff       	call   80102ed0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103587:	90                   	nop
80103588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010358b:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103591:	85 c0                	test   %eax,%eax
80103593:	74 f3                	je     80103588 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103595:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
8010359c:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801035a1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035a7:	05 20 f9 10 80       	add    $0x8010f920,%eax
801035ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035af:	0f 87 62 ff ff ff    	ja     80103517 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035b5:	83 c4 24             	add    $0x24,%esp
801035b8:	5b                   	pop    %ebx
801035b9:	5d                   	pop    %ebp
801035ba:	c3                   	ret    

801035bb <p2v>:
801035bb:	55                   	push   %ebp
801035bc:	89 e5                	mov    %esp,%ebp
801035be:	8b 45 08             	mov    0x8(%ebp),%eax
801035c1:	05 00 00 00 80       	add    $0x80000000,%eax
801035c6:	5d                   	pop    %ebp
801035c7:	c3                   	ret    

801035c8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035c8:	55                   	push   %ebp
801035c9:	89 e5                	mov    %esp,%ebp
801035cb:	83 ec 14             	sub    $0x14,%esp
801035ce:	8b 45 08             	mov    0x8(%ebp),%eax
801035d1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801035d9:	89 c2                	mov    %eax,%edx
801035db:	ec                   	in     (%dx),%al
801035dc:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801035df:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801035e3:	c9                   	leave  
801035e4:	c3                   	ret    

801035e5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801035e5:	55                   	push   %ebp
801035e6:	89 e5                	mov    %esp,%ebp
801035e8:	83 ec 08             	sub    $0x8,%esp
801035eb:	8b 55 08             	mov    0x8(%ebp),%edx
801035ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801035f1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801035f5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035f8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801035fc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103600:	ee                   	out    %al,(%dx)
}
80103601:	c9                   	leave  
80103602:	c3                   	ret    

80103603 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103603:	55                   	push   %ebp
80103604:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103606:	a1 44 b6 10 80       	mov    0x8010b644,%eax
8010360b:	89 c2                	mov    %eax,%edx
8010360d:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
80103612:	29 c2                	sub    %eax,%edx
80103614:	89 d0                	mov    %edx,%eax
80103616:	c1 f8 02             	sar    $0x2,%eax
80103619:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010361f:	5d                   	pop    %ebp
80103620:	c3                   	ret    

80103621 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103621:	55                   	push   %ebp
80103622:	89 e5                	mov    %esp,%ebp
80103624:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103627:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010362e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103635:	eb 15                	jmp    8010364c <sum+0x2b>
    sum += addr[i];
80103637:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010363a:	8b 45 08             	mov    0x8(%ebp),%eax
8010363d:	01 d0                	add    %edx,%eax
8010363f:	0f b6 00             	movzbl (%eax),%eax
80103642:	0f b6 c0             	movzbl %al,%eax
80103645:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103648:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010364c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010364f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103652:	7c e3                	jl     80103637 <sum+0x16>
    sum += addr[i];
  return sum;
80103654:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103657:	c9                   	leave  
80103658:	c3                   	ret    

80103659 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103659:	55                   	push   %ebp
8010365a:	89 e5                	mov    %esp,%ebp
8010365c:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010365f:	8b 45 08             	mov    0x8(%ebp),%eax
80103662:	89 04 24             	mov    %eax,(%esp)
80103665:	e8 51 ff ff ff       	call   801035bb <p2v>
8010366a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
8010366d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103670:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103673:	01 d0                	add    %edx,%eax
80103675:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103678:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010367b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010367e:	eb 3f                	jmp    801036bf <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103680:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103687:	00 
80103688:	c7 44 24 04 58 84 10 	movl   $0x80108458,0x4(%esp)
8010368f:	80 
80103690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103693:	89 04 24             	mov    %eax,(%esp)
80103696:	e8 14 18 00 00       	call   80104eaf <memcmp>
8010369b:	85 c0                	test   %eax,%eax
8010369d:	75 1c                	jne    801036bb <mpsearch1+0x62>
8010369f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036a6:	00 
801036a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036aa:	89 04 24             	mov    %eax,(%esp)
801036ad:	e8 6f ff ff ff       	call   80103621 <sum>
801036b2:	84 c0                	test   %al,%al
801036b4:	75 05                	jne    801036bb <mpsearch1+0x62>
      return (struct mp*)p;
801036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036b9:	eb 11                	jmp    801036cc <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801036bb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036c5:	72 b9                	jb     80103680 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801036c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801036cc:	c9                   	leave  
801036cd:	c3                   	ret    

801036ce <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801036ce:	55                   	push   %ebp
801036cf:	89 e5                	mov    %esp,%ebp
801036d1:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036d4:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036de:	83 c0 0f             	add    $0xf,%eax
801036e1:	0f b6 00             	movzbl (%eax),%eax
801036e4:	0f b6 c0             	movzbl %al,%eax
801036e7:	c1 e0 08             	shl    $0x8,%eax
801036ea:	89 c2                	mov    %eax,%edx
801036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ef:	83 c0 0e             	add    $0xe,%eax
801036f2:	0f b6 00             	movzbl (%eax),%eax
801036f5:	0f b6 c0             	movzbl %al,%eax
801036f8:	09 d0                	or     %edx,%eax
801036fa:	c1 e0 04             	shl    $0x4,%eax
801036fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103700:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103704:	74 21                	je     80103727 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103706:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010370d:	00 
8010370e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103711:	89 04 24             	mov    %eax,(%esp)
80103714:	e8 40 ff ff ff       	call   80103659 <mpsearch1>
80103719:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010371c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103720:	74 50                	je     80103772 <mpsearch+0xa4>
      return mp;
80103722:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103725:	eb 5f                	jmp    80103786 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010372a:	83 c0 14             	add    $0x14,%eax
8010372d:	0f b6 00             	movzbl (%eax),%eax
80103730:	0f b6 c0             	movzbl %al,%eax
80103733:	c1 e0 08             	shl    $0x8,%eax
80103736:	89 c2                	mov    %eax,%edx
80103738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373b:	83 c0 13             	add    $0x13,%eax
8010373e:	0f b6 00             	movzbl (%eax),%eax
80103741:	0f b6 c0             	movzbl %al,%eax
80103744:	09 d0                	or     %edx,%eax
80103746:	c1 e0 0a             	shl    $0xa,%eax
80103749:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
8010374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010374f:	2d 00 04 00 00       	sub    $0x400,%eax
80103754:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010375b:	00 
8010375c:	89 04 24             	mov    %eax,(%esp)
8010375f:	e8 f5 fe ff ff       	call   80103659 <mpsearch1>
80103764:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103767:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010376b:	74 05                	je     80103772 <mpsearch+0xa4>
      return mp;
8010376d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103770:	eb 14                	jmp    80103786 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103772:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103779:	00 
8010377a:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103781:	e8 d3 fe ff ff       	call   80103659 <mpsearch1>
}
80103786:	c9                   	leave  
80103787:	c3                   	ret    

80103788 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103788:	55                   	push   %ebp
80103789:	89 e5                	mov    %esp,%ebp
8010378b:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010378e:	e8 3b ff ff ff       	call   801036ce <mpsearch>
80103793:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010379a:	74 0a                	je     801037a6 <mpconfig+0x1e>
8010379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010379f:	8b 40 04             	mov    0x4(%eax),%eax
801037a2:	85 c0                	test   %eax,%eax
801037a4:	75 0a                	jne    801037b0 <mpconfig+0x28>
    return 0;
801037a6:	b8 00 00 00 00       	mov    $0x0,%eax
801037ab:	e9 83 00 00 00       	jmp    80103833 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037b3:	8b 40 04             	mov    0x4(%eax),%eax
801037b6:	89 04 24             	mov    %eax,(%esp)
801037b9:	e8 fd fd ff ff       	call   801035bb <p2v>
801037be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037c1:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801037c8:	00 
801037c9:	c7 44 24 04 5d 84 10 	movl   $0x8010845d,0x4(%esp)
801037d0:	80 
801037d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037d4:	89 04 24             	mov    %eax,(%esp)
801037d7:	e8 d3 16 00 00       	call   80104eaf <memcmp>
801037dc:	85 c0                	test   %eax,%eax
801037de:	74 07                	je     801037e7 <mpconfig+0x5f>
    return 0;
801037e0:	b8 00 00 00 00       	mov    $0x0,%eax
801037e5:	eb 4c                	jmp    80103833 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
801037e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ea:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801037ee:	3c 01                	cmp    $0x1,%al
801037f0:	74 12                	je     80103804 <mpconfig+0x7c>
801037f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037f5:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801037f9:	3c 04                	cmp    $0x4,%al
801037fb:	74 07                	je     80103804 <mpconfig+0x7c>
    return 0;
801037fd:	b8 00 00 00 00       	mov    $0x0,%eax
80103802:	eb 2f                	jmp    80103833 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103807:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010380b:	0f b7 c0             	movzwl %ax,%eax
8010380e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103812:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103815:	89 04 24             	mov    %eax,(%esp)
80103818:	e8 04 fe ff ff       	call   80103621 <sum>
8010381d:	84 c0                	test   %al,%al
8010381f:	74 07                	je     80103828 <mpconfig+0xa0>
    return 0;
80103821:	b8 00 00 00 00       	mov    $0x0,%eax
80103826:	eb 0b                	jmp    80103833 <mpconfig+0xab>
  *pmp = mp;
80103828:	8b 45 08             	mov    0x8(%ebp),%eax
8010382b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010382e:	89 10                	mov    %edx,(%eax)
  return conf;
80103830:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103833:	c9                   	leave  
80103834:	c3                   	ret    

80103835 <mpinit>:

void
mpinit(void)
{
80103835:	55                   	push   %ebp
80103836:	89 e5                	mov    %esp,%ebp
80103838:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
8010383b:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
80103842:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
80103845:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103848:	89 04 24             	mov    %eax,(%esp)
8010384b:	e8 38 ff ff ff       	call   80103788 <mpconfig>
80103850:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103853:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103857:	75 05                	jne    8010385e <mpinit+0x29>
    return;
80103859:	e9 9c 01 00 00       	jmp    801039fa <mpinit+0x1c5>
  ismp = 1;
8010385e:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
80103865:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103868:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010386b:	8b 40 24             	mov    0x24(%eax),%eax
8010386e:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103873:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103876:	83 c0 2c             	add    $0x2c,%eax
80103879:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010387c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387f:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103883:	0f b7 d0             	movzwl %ax,%edx
80103886:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103889:	01 d0                	add    %edx,%eax
8010388b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010388e:	e9 f4 00 00 00       	jmp    80103987 <mpinit+0x152>
    switch(*p){
80103893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103896:	0f b6 00             	movzbl (%eax),%eax
80103899:	0f b6 c0             	movzbl %al,%eax
8010389c:	83 f8 04             	cmp    $0x4,%eax
8010389f:	0f 87 bf 00 00 00    	ja     80103964 <mpinit+0x12f>
801038a5:	8b 04 85 a0 84 10 80 	mov    -0x7fef7b60(,%eax,4),%eax
801038ac:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038b7:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038bb:	0f b6 d0             	movzbl %al,%edx
801038be:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038c3:	39 c2                	cmp    %eax,%edx
801038c5:	74 2d                	je     801038f4 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038ca:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038ce:	0f b6 d0             	movzbl %al,%edx
801038d1:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038d6:	89 54 24 08          	mov    %edx,0x8(%esp)
801038da:	89 44 24 04          	mov    %eax,0x4(%esp)
801038de:	c7 04 24 62 84 10 80 	movl   $0x80108462,(%esp)
801038e5:	e8 b6 ca ff ff       	call   801003a0 <cprintf>
        ismp = 0;
801038ea:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
801038f1:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801038f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038f7:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801038fb:	0f b6 c0             	movzbl %al,%eax
801038fe:	83 e0 02             	and    $0x2,%eax
80103901:	85 c0                	test   %eax,%eax
80103903:	74 15                	je     8010391a <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103905:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010390a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103910:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103915:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
8010391a:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
80103920:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103925:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
8010392b:	81 c2 20 f9 10 80    	add    $0x8010f920,%edx
80103931:	88 02                	mov    %al,(%edx)
      ncpu++;
80103933:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103938:	83 c0 01             	add    $0x1,%eax
8010393b:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
80103940:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103944:	eb 41                	jmp    80103987 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103949:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
8010394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010394f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103953:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
80103958:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010395c:	eb 29                	jmp    80103987 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010395e:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103962:	eb 23                	jmp    80103987 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103967:	0f b6 00             	movzbl (%eax),%eax
8010396a:	0f b6 c0             	movzbl %al,%eax
8010396d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103971:	c7 04 24 80 84 10 80 	movl   $0x80108480,(%esp)
80103978:	e8 23 ca ff ff       	call   801003a0 <cprintf>
      ismp = 0;
8010397d:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103984:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010398a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010398d:	0f 82 00 ff ff ff    	jb     80103893 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103993:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103998:	85 c0                	test   %eax,%eax
8010399a:	75 1d                	jne    801039b9 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
8010399c:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
801039a3:	00 00 00 
    lapic = 0;
801039a6:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
801039ad:	00 00 00 
    ioapicid = 0;
801039b0:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
    return;
801039b7:	eb 41                	jmp    801039fa <mpinit+0x1c5>
  }

  if(mp->imcrp){
801039b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039bc:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801039c0:	84 c0                	test   %al,%al
801039c2:	74 36                	je     801039fa <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801039c4:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
801039cb:	00 
801039cc:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801039d3:	e8 0d fc ff ff       	call   801035e5 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039d8:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039df:	e8 e4 fb ff ff       	call   801035c8 <inb>
801039e4:	83 c8 01             	or     $0x1,%eax
801039e7:	0f b6 c0             	movzbl %al,%eax
801039ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801039ee:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039f5:	e8 eb fb ff ff       	call   801035e5 <outb>
  }
}
801039fa:	c9                   	leave  
801039fb:	c3                   	ret    

801039fc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039fc:	55                   	push   %ebp
801039fd:	89 e5                	mov    %esp,%ebp
801039ff:	83 ec 08             	sub    $0x8,%esp
80103a02:	8b 55 08             	mov    0x8(%ebp),%edx
80103a05:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a08:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a0c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a0f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a13:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a17:	ee                   	out    %al,(%dx)
}
80103a18:	c9                   	leave  
80103a19:	c3                   	ret    

80103a1a <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a1a:	55                   	push   %ebp
80103a1b:	89 e5                	mov    %esp,%ebp
80103a1d:	83 ec 0c             	sub    $0xc,%esp
80103a20:	8b 45 08             	mov    0x8(%ebp),%eax
80103a23:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a27:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a2b:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a31:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a35:	0f b6 c0             	movzbl %al,%eax
80103a38:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a3c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a43:	e8 b4 ff ff ff       	call   801039fc <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a48:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a4c:	66 c1 e8 08          	shr    $0x8,%ax
80103a50:	0f b6 c0             	movzbl %al,%eax
80103a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a57:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a5e:	e8 99 ff ff ff       	call   801039fc <outb>
}
80103a63:	c9                   	leave  
80103a64:	c3                   	ret    

80103a65 <picenable>:

void
picenable(int irq)
{
80103a65:	55                   	push   %ebp
80103a66:	89 e5                	mov    %esp,%ebp
80103a68:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103a6e:	ba 01 00 00 00       	mov    $0x1,%edx
80103a73:	89 c1                	mov    %eax,%ecx
80103a75:	d3 e2                	shl    %cl,%edx
80103a77:	89 d0                	mov    %edx,%eax
80103a79:	f7 d0                	not    %eax
80103a7b:	89 c2                	mov    %eax,%edx
80103a7d:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103a84:	21 d0                	and    %edx,%eax
80103a86:	0f b7 c0             	movzwl %ax,%eax
80103a89:	89 04 24             	mov    %eax,(%esp)
80103a8c:	e8 89 ff ff ff       	call   80103a1a <picsetmask>
}
80103a91:	c9                   	leave  
80103a92:	c3                   	ret    

80103a93 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103a93:	55                   	push   %ebp
80103a94:	89 e5                	mov    %esp,%ebp
80103a96:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103a99:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103aa0:	00 
80103aa1:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103aa8:	e8 4f ff ff ff       	call   801039fc <outb>
  outb(IO_PIC2+1, 0xFF);
80103aad:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ab4:	00 
80103ab5:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103abc:	e8 3b ff ff ff       	call   801039fc <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ac1:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ac8:	00 
80103ac9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ad0:	e8 27 ff ff ff       	call   801039fc <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ad5:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103adc:	00 
80103add:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ae4:	e8 13 ff ff ff       	call   801039fc <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ae9:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103af0:	00 
80103af1:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103af8:	e8 ff fe ff ff       	call   801039fc <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103afd:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b04:	00 
80103b05:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b0c:	e8 eb fe ff ff       	call   801039fc <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b11:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b18:	00 
80103b19:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b20:	e8 d7 fe ff ff       	call   801039fc <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b25:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b2c:	00 
80103b2d:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b34:	e8 c3 fe ff ff       	call   801039fc <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b39:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b40:	00 
80103b41:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b48:	e8 af fe ff ff       	call   801039fc <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b4d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b54:	00 
80103b55:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b5c:	e8 9b fe ff ff       	call   801039fc <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b61:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b68:	00 
80103b69:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b70:	e8 87 fe ff ff       	call   801039fc <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103b75:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103b7c:	00 
80103b7d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b84:	e8 73 fe ff ff       	call   801039fc <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103b89:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b90:	00 
80103b91:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b98:	e8 5f fe ff ff       	call   801039fc <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103b9d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103ba4:	00 
80103ba5:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bac:	e8 4b fe ff ff       	call   801039fc <outb>

  if(irqmask != 0xFFFF)
80103bb1:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103bb8:	66 83 f8 ff          	cmp    $0xffff,%ax
80103bbc:	74 12                	je     80103bd0 <picinit+0x13d>
    picsetmask(irqmask);
80103bbe:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103bc5:	0f b7 c0             	movzwl %ax,%eax
80103bc8:	89 04 24             	mov    %eax,(%esp)
80103bcb:	e8 4a fe ff ff       	call   80103a1a <picsetmask>
}
80103bd0:	c9                   	leave  
80103bd1:	c3                   	ret    

80103bd2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103bd2:	55                   	push   %ebp
80103bd3:	89 e5                	mov    %esp,%ebp
80103bd5:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103bd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103be2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103be8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103beb:	8b 10                	mov    (%eax),%edx
80103bed:	8b 45 08             	mov    0x8(%ebp),%eax
80103bf0:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103bf2:	e8 22 d3 ff ff       	call   80100f19 <filealloc>
80103bf7:	8b 55 08             	mov    0x8(%ebp),%edx
80103bfa:	89 02                	mov    %eax,(%edx)
80103bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103bff:	8b 00                	mov    (%eax),%eax
80103c01:	85 c0                	test   %eax,%eax
80103c03:	0f 84 c8 00 00 00    	je     80103cd1 <pipealloc+0xff>
80103c09:	e8 0b d3 ff ff       	call   80100f19 <filealloc>
80103c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c11:	89 02                	mov    %eax,(%edx)
80103c13:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c16:	8b 00                	mov    (%eax),%eax
80103c18:	85 c0                	test   %eax,%eax
80103c1a:	0f 84 b1 00 00 00    	je     80103cd1 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c20:	e8 b0 ee ff ff       	call   80102ad5 <kalloc>
80103c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c2c:	75 05                	jne    80103c33 <pipealloc+0x61>
    goto bad;
80103c2e:	e9 9e 00 00 00       	jmp    80103cd1 <pipealloc+0xff>
  p->readopen = 1;
80103c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c36:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c3d:	00 00 00 
  p->writeopen = 1;
80103c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c43:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c4a:	00 00 00 
  p->nwrite = 0;
80103c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c50:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c57:	00 00 00 
  p->nread = 0;
80103c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c64:	00 00 00 
  initlock(&p->lock, "pipe");
80103c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6a:	c7 44 24 04 b4 84 10 	movl   $0x801084b4,0x4(%esp)
80103c71:	80 
80103c72:	89 04 24             	mov    %eax,(%esp)
80103c75:	e8 49 0f 00 00       	call   80104bc3 <initlock>
  (*f0)->type = FD_PIPE;
80103c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c7d:	8b 00                	mov    (%eax),%eax
80103c7f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c85:	8b 45 08             	mov    0x8(%ebp),%eax
80103c88:	8b 00                	mov    (%eax),%eax
80103c8a:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103c91:	8b 00                	mov    (%eax),%eax
80103c93:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103c97:	8b 45 08             	mov    0x8(%ebp),%eax
80103c9a:	8b 00                	mov    (%eax),%eax
80103c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c9f:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ca5:	8b 00                	mov    (%eax),%eax
80103ca7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cad:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cb0:	8b 00                	mov    (%eax),%eax
80103cb2:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cb9:	8b 00                	mov    (%eax),%eax
80103cbb:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cc2:	8b 00                	mov    (%eax),%eax
80103cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cc7:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103cca:	b8 00 00 00 00       	mov    $0x0,%eax
80103ccf:	eb 42                	jmp    80103d13 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cd5:	74 0b                	je     80103ce2 <pipealloc+0x110>
    kfree((char*)p);
80103cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cda:	89 04 24             	mov    %eax,(%esp)
80103cdd:	e8 5a ed ff ff       	call   80102a3c <kfree>
  if(*f0)
80103ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ce5:	8b 00                	mov    (%eax),%eax
80103ce7:	85 c0                	test   %eax,%eax
80103ce9:	74 0d                	je     80103cf8 <pipealloc+0x126>
    fileclose(*f0);
80103ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80103cee:	8b 00                	mov    (%eax),%eax
80103cf0:	89 04 24             	mov    %eax,(%esp)
80103cf3:	e8 c9 d2 ff ff       	call   80100fc1 <fileclose>
  if(*f1)
80103cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cfb:	8b 00                	mov    (%eax),%eax
80103cfd:	85 c0                	test   %eax,%eax
80103cff:	74 0d                	je     80103d0e <pipealloc+0x13c>
    fileclose(*f1);
80103d01:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d04:	8b 00                	mov    (%eax),%eax
80103d06:	89 04 24             	mov    %eax,(%esp)
80103d09:	e8 b3 d2 ff ff       	call   80100fc1 <fileclose>
  return -1;
80103d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d13:	c9                   	leave  
80103d14:	c3                   	ret    

80103d15 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d15:	55                   	push   %ebp
80103d16:	89 e5                	mov    %esp,%ebp
80103d18:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d1b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d1e:	89 04 24             	mov    %eax,(%esp)
80103d21:	e8 be 0e 00 00       	call   80104be4 <acquire>
  if(writable){
80103d26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d2a:	74 1f                	je     80103d4b <pipeclose+0x36>
    p->writeopen = 0;
80103d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2f:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d36:	00 00 00 
    wakeup(&p->nread);
80103d39:	8b 45 08             	mov    0x8(%ebp),%eax
80103d3c:	05 34 02 00 00       	add    $0x234,%eax
80103d41:	89 04 24             	mov    %eax,(%esp)
80103d44:	e8 a4 0c 00 00       	call   801049ed <wakeup>
80103d49:	eb 1d                	jmp    80103d68 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d4e:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d55:	00 00 00 
    wakeup(&p->nwrite);
80103d58:	8b 45 08             	mov    0x8(%ebp),%eax
80103d5b:	05 38 02 00 00       	add    $0x238,%eax
80103d60:	89 04 24             	mov    %eax,(%esp)
80103d63:	e8 85 0c 00 00       	call   801049ed <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d68:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d71:	85 c0                	test   %eax,%eax
80103d73:	75 25                	jne    80103d9a <pipeclose+0x85>
80103d75:	8b 45 08             	mov    0x8(%ebp),%eax
80103d78:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103d7e:	85 c0                	test   %eax,%eax
80103d80:	75 18                	jne    80103d9a <pipeclose+0x85>
    release(&p->lock);
80103d82:	8b 45 08             	mov    0x8(%ebp),%eax
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 b9 0e 00 00       	call   80104c46 <release>
    kfree((char*)p);
80103d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d90:	89 04 24             	mov    %eax,(%esp)
80103d93:	e8 a4 ec ff ff       	call   80102a3c <kfree>
80103d98:	eb 0b                	jmp    80103da5 <pipeclose+0x90>
  } else
    release(&p->lock);
80103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9d:	89 04 24             	mov    %eax,(%esp)
80103da0:	e8 a1 0e 00 00       	call   80104c46 <release>
}
80103da5:	c9                   	leave  
80103da6:	c3                   	ret    

80103da7 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103da7:	55                   	push   %ebp
80103da8:	89 e5                	mov    %esp,%ebp
80103daa:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103dad:	8b 45 08             	mov    0x8(%ebp),%eax
80103db0:	89 04 24             	mov    %eax,(%esp)
80103db3:	e8 2c 0e 00 00       	call   80104be4 <acquire>
  for(i = 0; i < n; i++){
80103db8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103dbf:	e9 a6 00 00 00       	jmp    80103e6a <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dc4:	eb 57                	jmp    80103e1d <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc9:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dcf:	85 c0                	test   %eax,%eax
80103dd1:	74 0d                	je     80103de0 <pipewrite+0x39>
80103dd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dd9:	8b 40 24             	mov    0x24(%eax),%eax
80103ddc:	85 c0                	test   %eax,%eax
80103dde:	74 15                	je     80103df5 <pipewrite+0x4e>
        release(&p->lock);
80103de0:	8b 45 08             	mov    0x8(%ebp),%eax
80103de3:	89 04 24             	mov    %eax,(%esp)
80103de6:	e8 5b 0e 00 00       	call   80104c46 <release>
        return -1;
80103deb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103df0:	e9 9f 00 00 00       	jmp    80103e94 <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103df5:	8b 45 08             	mov    0x8(%ebp),%eax
80103df8:	05 34 02 00 00       	add    $0x234,%eax
80103dfd:	89 04 24             	mov    %eax,(%esp)
80103e00:	e8 e8 0b 00 00       	call   801049ed <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e05:	8b 45 08             	mov    0x8(%ebp),%eax
80103e08:	8b 55 08             	mov    0x8(%ebp),%edx
80103e0b:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e11:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e15:	89 14 24             	mov    %edx,(%esp)
80103e18:	e8 f4 0a 00 00       	call   80104911 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e20:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e26:	8b 45 08             	mov    0x8(%ebp),%eax
80103e29:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e2f:	05 00 02 00 00       	add    $0x200,%eax
80103e34:	39 c2                	cmp    %eax,%edx
80103e36:	74 8e                	je     80103dc6 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e38:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e41:	8d 48 01             	lea    0x1(%eax),%ecx
80103e44:	8b 55 08             	mov    0x8(%ebp),%edx
80103e47:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103e4d:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e52:	89 c1                	mov    %eax,%ecx
80103e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e57:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e5a:	01 d0                	add    %edx,%eax
80103e5c:	0f b6 10             	movzbl (%eax),%edx
80103e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e62:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e6d:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e70:	0f 8c 4e ff ff ff    	jl     80103dc4 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e76:	8b 45 08             	mov    0x8(%ebp),%eax
80103e79:	05 34 02 00 00       	add    $0x234,%eax
80103e7e:	89 04 24             	mov    %eax,(%esp)
80103e81:	e8 67 0b 00 00       	call   801049ed <wakeup>
  release(&p->lock);
80103e86:	8b 45 08             	mov    0x8(%ebp),%eax
80103e89:	89 04 24             	mov    %eax,(%esp)
80103e8c:	e8 b5 0d 00 00       	call   80104c46 <release>
  return n;
80103e91:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103e94:	c9                   	leave  
80103e95:	c3                   	ret    

80103e96 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103e96:	55                   	push   %ebp
80103e97:	89 e5                	mov    %esp,%ebp
80103e99:	53                   	push   %ebx
80103e9a:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea0:	89 04 24             	mov    %eax,(%esp)
80103ea3:	e8 3c 0d 00 00       	call   80104be4 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ea8:	eb 3a                	jmp    80103ee4 <piperead+0x4e>
    if(proc->killed){
80103eaa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103eb0:	8b 40 24             	mov    0x24(%eax),%eax
80103eb3:	85 c0                	test   %eax,%eax
80103eb5:	74 15                	je     80103ecc <piperead+0x36>
      release(&p->lock);
80103eb7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eba:	89 04 24             	mov    %eax,(%esp)
80103ebd:	e8 84 0d 00 00       	call   80104c46 <release>
      return -1;
80103ec2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ec7:	e9 b5 00 00 00       	jmp    80103f81 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ecc:	8b 45 08             	mov    0x8(%ebp),%eax
80103ecf:	8b 55 08             	mov    0x8(%ebp),%edx
80103ed2:	81 c2 34 02 00 00    	add    $0x234,%edx
80103ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
80103edc:	89 14 24             	mov    %edx,(%esp)
80103edf:	e8 2d 0a 00 00       	call   80104911 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee7:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103eed:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef0:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ef6:	39 c2                	cmp    %eax,%edx
80103ef8:	75 0d                	jne    80103f07 <piperead+0x71>
80103efa:	8b 45 08             	mov    0x8(%ebp),%eax
80103efd:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f03:	85 c0                	test   %eax,%eax
80103f05:	75 a3                	jne    80103eaa <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f0e:	eb 4b                	jmp    80103f5b <piperead+0xc5>
    if(p->nread == p->nwrite)
80103f10:	8b 45 08             	mov    0x8(%ebp),%eax
80103f13:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f19:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f22:	39 c2                	cmp    %eax,%edx
80103f24:	75 02                	jne    80103f28 <piperead+0x92>
      break;
80103f26:	eb 3b                	jmp    80103f63 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f2e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103f31:	8b 45 08             	mov    0x8(%ebp),%eax
80103f34:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f3a:	8d 48 01             	lea    0x1(%eax),%ecx
80103f3d:	8b 55 08             	mov    0x8(%ebp),%edx
80103f40:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103f46:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f4b:	89 c2                	mov    %eax,%edx
80103f4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f50:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80103f55:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f5e:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f61:	7c ad                	jl     80103f10 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f63:	8b 45 08             	mov    0x8(%ebp),%eax
80103f66:	05 38 02 00 00       	add    $0x238,%eax
80103f6b:	89 04 24             	mov    %eax,(%esp)
80103f6e:	e8 7a 0a 00 00       	call   801049ed <wakeup>
  release(&p->lock);
80103f73:	8b 45 08             	mov    0x8(%ebp),%eax
80103f76:	89 04 24             	mov    %eax,(%esp)
80103f79:	e8 c8 0c 00 00       	call   80104c46 <release>
  return i;
80103f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103f81:	83 c4 24             	add    $0x24,%esp
80103f84:	5b                   	pop    %ebx
80103f85:	5d                   	pop    %ebp
80103f86:	c3                   	ret    

80103f87 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103f87:	55                   	push   %ebp
80103f88:	89 e5                	mov    %esp,%ebp
80103f8a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f8d:	9c                   	pushf  
80103f8e:	58                   	pop    %eax
80103f8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103f95:	c9                   	leave  
80103f96:	c3                   	ret    

80103f97 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103f97:	55                   	push   %ebp
80103f98:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103f9a:	fb                   	sti    
}
80103f9b:	5d                   	pop    %ebp
80103f9c:	c3                   	ret    

80103f9d <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103f9d:	55                   	push   %ebp
80103f9e:	89 e5                	mov    %esp,%ebp
80103fa0:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103fa3:	c7 44 24 04 b9 84 10 	movl   $0x801084b9,0x4(%esp)
80103faa:	80 
80103fab:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103fb2:	e8 0c 0c 00 00       	call   80104bc3 <initlock>
}
80103fb7:	c9                   	leave  
80103fb8:	c3                   	ret    

80103fb9 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103fb9:	55                   	push   %ebp
80103fba:	89 e5                	mov    %esp,%ebp
80103fbc:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103fbf:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103fc6:	e8 19 0c 00 00       	call   80104be4 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fcb:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80103fd2:	eb 6a                	jmp    8010403e <allocproc+0x85>
    if(p->state == UNUSED)
80103fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd7:	8b 40 0c             	mov    0xc(%eax),%eax
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	75 59                	jne    80104037 <allocproc+0x7e>
      goto found;
80103fde:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe2:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103fe9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103fee:	8d 50 01             	lea    0x1(%eax),%edx
80103ff1:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ffa:	89 42 10             	mov    %eax,0x10(%edx)

  p->placeInQ = lastInQ++;
80103ffd:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80104002:	8d 50 01             	lea    0x1(%eax),%edx
80104005:	89 15 4c b6 10 80    	mov    %edx,0x8010b64c
8010400b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010400e:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  release(&ptable.lock);
80104014:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010401b:	e8 26 0c 00 00       	call   80104c46 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104020:	e8 b0 ea ff ff       	call   80102ad5 <kalloc>
80104025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104028:	89 42 08             	mov    %eax,0x8(%edx)
8010402b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402e:	8b 40 08             	mov    0x8(%eax),%eax
80104031:	85 c0                	test   %eax,%eax
80104033:	75 36                	jne    8010406b <allocproc+0xb2>
80104035:	eb 23                	jmp    8010405a <allocproc+0xa1>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104037:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
8010403e:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
80104045:	72 8d                	jb     80103fd4 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104047:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010404e:	e8 f3 0b 00 00       	call   80104c46 <release>
  return 0;
80104053:	b8 00 00 00 00       	mov    $0x0,%eax
80104058:	eb 76                	jmp    801040d0 <allocproc+0x117>
  p->placeInQ = lastInQ++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010405a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104064:	b8 00 00 00 00       	mov    $0x0,%eax
80104069:	eb 65                	jmp    801040d0 <allocproc+0x117>
  }
  sp = p->kstack + KSTACKSIZE;
8010406b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406e:	8b 40 08             	mov    0x8(%eax),%eax
80104071:	05 00 10 00 00       	add    $0x1000,%eax
80104076:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104079:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010407d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104080:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104083:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104086:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010408a:	ba 6e 62 10 80       	mov    $0x8010626e,%edx
8010408f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104092:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104094:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010409e:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801040a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a4:	8b 40 1c             	mov    0x1c(%eax),%eax
801040a7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801040ae:	00 
801040af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801040b6:	00 
801040b7:	89 04 24             	mov    %eax,(%esp)
801040ba:	e8 79 0d 00 00       	call   80104e38 <memset>
  p->context->eip = (uint)forkret;
801040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c2:	8b 40 1c             	mov    0x1c(%eax),%eax
801040c5:	ba e5 48 10 80       	mov    $0x801048e5,%edx
801040ca:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801040cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801040d0:	c9                   	leave  
801040d1:	c3                   	ret    

801040d2 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801040d2:	55                   	push   %ebp
801040d3:	89 e5                	mov    %esp,%ebp
801040d5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801040d8:	e8 dc fe ff ff       	call   80103fb9 <allocproc>
801040dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801040e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e3:	a3 50 b6 10 80       	mov    %eax,0x8010b650
  if((p->pgdir = setupkvm(kalloc)) == 0)
801040e8:	c7 04 24 d5 2a 10 80 	movl   $0x80102ad5,(%esp)
801040ef:	e8 a3 38 00 00       	call   80107997 <setupkvm>
801040f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040f7:	89 42 04             	mov    %eax,0x4(%edx)
801040fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fd:	8b 40 04             	mov    0x4(%eax),%eax
80104100:	85 c0                	test   %eax,%eax
80104102:	75 0c                	jne    80104110 <userinit+0x3e>
    panic("userinit: out of memory?");
80104104:	c7 04 24 c0 84 10 80 	movl   $0x801084c0,(%esp)
8010410b:	e8 2a c4 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104110:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104118:	8b 40 04             	mov    0x4(%eax),%eax
8010411b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010411f:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
80104126:	80 
80104127:	89 04 24             	mov    %eax,(%esp)
8010412a:	e8 c0 3a 00 00       	call   80107bef <inituvm>
  p->sz = PGSIZE;
8010412f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104132:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413b:	8b 40 18             	mov    0x18(%eax),%eax
8010413e:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104145:	00 
80104146:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010414d:	00 
8010414e:	89 04 24             	mov    %eax,(%esp)
80104151:	e8 e2 0c 00 00       	call   80104e38 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104159:	8b 40 18             	mov    0x18(%eax),%eax
8010415c:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104165:	8b 40 18             	mov    0x18(%eax),%eax
80104168:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010416e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104171:	8b 40 18             	mov    0x18(%eax),%eax
80104174:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104177:	8b 52 18             	mov    0x18(%edx),%edx
8010417a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010417e:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104185:	8b 40 18             	mov    0x18(%eax),%eax
80104188:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010418b:	8b 52 18             	mov    0x18(%edx),%edx
8010418e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104192:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104199:	8b 40 18             	mov    0x18(%eax),%eax
8010419c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a6:	8b 40 18             	mov    0x18(%eax),%eax
801041a9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801041b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b3:	8b 40 18             	mov    0x18(%eax),%eax
801041b6:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801041bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c0:	83 c0 6c             	add    $0x6c,%eax
801041c3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801041ca:	00 
801041cb:	c7 44 24 04 d9 84 10 	movl   $0x801084d9,0x4(%esp)
801041d2:	80 
801041d3:	89 04 24             	mov    %eax,(%esp)
801041d6:	e8 7d 0e 00 00       	call   80105058 <safestrcpy>
  p->cwd = namei("/");
801041db:	c7 04 24 e2 84 10 80 	movl   $0x801084e2,(%esp)
801041e2:	e8 12 e2 ff ff       	call   801023f9 <namei>
801041e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ea:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801041ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801041f7:	c9                   	leave  
801041f8:	c3                   	ret    

801041f9 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801041f9:	55                   	push   %ebp
801041fa:	89 e5                	mov    %esp,%ebp
801041fc:	83 ec 28             	sub    $0x28,%esp
  uint sz;

  sz = proc->sz;
801041ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104205:	8b 00                	mov    (%eax),%eax
80104207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010420a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010420e:	7e 34                	jle    80104244 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104210:	8b 55 08             	mov    0x8(%ebp),%edx
80104213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104216:	01 c2                	add    %eax,%edx
80104218:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010421e:	8b 40 04             	mov    0x4(%eax),%eax
80104221:	89 54 24 08          	mov    %edx,0x8(%esp)
80104225:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104228:	89 54 24 04          	mov    %edx,0x4(%esp)
8010422c:	89 04 24             	mov    %eax,(%esp)
8010422f:	e8 31 3b 00 00       	call   80107d65 <allocuvm>
80104234:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010423b:	75 41                	jne    8010427e <growproc+0x85>
      return -1;
8010423d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104242:	eb 58                	jmp    8010429c <growproc+0xa3>
  } else if(n < 0){
80104244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104248:	79 34                	jns    8010427e <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010424a:	8b 55 08             	mov    0x8(%ebp),%edx
8010424d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104250:	01 c2                	add    %eax,%edx
80104252:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104258:	8b 40 04             	mov    0x4(%eax),%eax
8010425b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010425f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104262:	89 54 24 04          	mov    %edx,0x4(%esp)
80104266:	89 04 24             	mov    %eax,(%esp)
80104269:	e8 d1 3b 00 00       	call   80107e3f <deallocuvm>
8010426e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104275:	75 07                	jne    8010427e <growproc+0x85>
      return -1;
80104277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010427c:	eb 1e                	jmp    8010429c <growproc+0xa3>
  }
  proc->sz = sz;
8010427e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104284:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104287:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104289:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010428f:	89 04 24             	mov    %eax,(%esp)
80104292:	e8 f1 37 00 00       	call   80107a88 <switchuvm>
  return 0;
80104297:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010429c:	c9                   	leave  
8010429d:	c3                   	ret    

8010429e <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010429e:	55                   	push   %ebp
8010429f:	89 e5                	mov    %esp,%ebp
801042a1:	57                   	push   %edi
801042a2:	56                   	push   %esi
801042a3:	53                   	push   %ebx
801042a4:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801042a7:	e8 0d fd ff ff       	call   80103fb9 <allocproc>
801042ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
801042af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801042b3:	75 0a                	jne    801042bf <fork+0x21>
    return -1;
801042b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042ba:	e9 3a 01 00 00       	jmp    801043f9 <fork+0x15b>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801042bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042c5:	8b 10                	mov    (%eax),%edx
801042c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042cd:	8b 40 04             	mov    0x4(%eax),%eax
801042d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801042d4:	89 04 24             	mov    %eax,(%esp)
801042d7:	e8 ff 3c 00 00       	call   80107fdb <copyuvm>
801042dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801042df:	89 42 04             	mov    %eax,0x4(%edx)
801042e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042e5:	8b 40 04             	mov    0x4(%eax),%eax
801042e8:	85 c0                	test   %eax,%eax
801042ea:	75 2c                	jne    80104318 <fork+0x7a>
    kfree(np->kstack);
801042ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ef:	8b 40 08             	mov    0x8(%eax),%eax
801042f2:	89 04 24             	mov    %eax,(%esp)
801042f5:	e8 42 e7 ff ff       	call   80102a3c <kfree>
    np->kstack = 0;
801042fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104304:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104307:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010430e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104313:	e9 e1 00 00 00       	jmp    801043f9 <fork+0x15b>
  }
  np->sz = proc->sz;
80104318:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431e:	8b 10                	mov    (%eax),%edx
80104320:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104323:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104325:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010432c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010432f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104332:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104335:	8b 50 18             	mov    0x18(%eax),%edx
80104338:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010433e:	8b 40 18             	mov    0x18(%eax),%eax
80104341:	89 c3                	mov    %eax,%ebx
80104343:	b8 13 00 00 00       	mov    $0x13,%eax
80104348:	89 d7                	mov    %edx,%edi
8010434a:	89 de                	mov    %ebx,%esi
8010434c:	89 c1                	mov    %eax,%ecx
8010434e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104350:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104353:	8b 40 18             	mov    0x18(%eax),%eax
80104356:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010435d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104364:	eb 3d                	jmp    801043a3 <fork+0x105>
    if(proc->ofile[i])
80104366:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010436c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010436f:	83 c2 08             	add    $0x8,%edx
80104372:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104376:	85 c0                	test   %eax,%eax
80104378:	74 25                	je     8010439f <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
8010437a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104383:	83 c2 08             	add    $0x8,%edx
80104386:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010438a:	89 04 24             	mov    %eax,(%esp)
8010438d:	e8 e7 cb ff ff       	call   80100f79 <filedup>
80104392:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104395:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104398:	83 c1 08             	add    $0x8,%ecx
8010439b:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010439f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801043a3:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801043a7:	7e bd                	jle    80104366 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801043a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043af:	8b 40 68             	mov    0x68(%eax),%eax
801043b2:	89 04 24             	mov    %eax,(%esp)
801043b5:	e8 62 d4 ff ff       	call   8010181c <idup>
801043ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043bd:	89 42 68             	mov    %eax,0x68(%edx)

  pid = np->pid;
801043c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043c3:	8b 40 10             	mov    0x10(%eax),%eax
801043c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
801043c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
801043d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043d9:	8d 50 6c             	lea    0x6c(%eax),%edx
801043dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043df:	83 c0 6c             	add    $0x6c,%eax
801043e2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043e9:	00 
801043ea:	89 54 24 04          	mov    %edx,0x4(%esp)
801043ee:	89 04 24             	mov    %eax,(%esp)
801043f1:	e8 62 0c 00 00       	call   80105058 <safestrcpy>
  return pid;
801043f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801043f9:	83 c4 2c             	add    $0x2c,%esp
801043fc:	5b                   	pop    %ebx
801043fd:	5e                   	pop    %esi
801043fe:	5f                   	pop    %edi
801043ff:	5d                   	pop    %ebp
80104400:	c3                   	ret    

80104401 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104401:	55                   	push   %ebp
80104402:	89 e5                	mov    %esp,%ebp
80104404:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104407:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010440e:	a1 50 b6 10 80       	mov    0x8010b650,%eax
80104413:	39 c2                	cmp    %eax,%edx
80104415:	75 0c                	jne    80104423 <exit+0x22>
    panic("init exiting");
80104417:	c7 04 24 e4 84 10 80 	movl   $0x801084e4,(%esp)
8010441e:	e8 17 c1 ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104423:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010442a:	eb 44                	jmp    80104470 <exit+0x6f>
    if(proc->ofile[fd]){
8010442c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104432:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104435:	83 c2 08             	add    $0x8,%edx
80104438:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010443c:	85 c0                	test   %eax,%eax
8010443e:	74 2c                	je     8010446c <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104440:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104446:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104449:	83 c2 08             	add    $0x8,%edx
8010444c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104450:	89 04 24             	mov    %eax,(%esp)
80104453:	e8 69 cb ff ff       	call   80100fc1 <fileclose>
      proc->ofile[fd] = 0;
80104458:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010445e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104461:	83 c2 08             	add    $0x8,%edx
80104464:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010446b:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010446c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104470:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104474:	7e b6                	jle    8010442c <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104476:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010447c:	8b 40 68             	mov    0x68(%eax),%eax
8010447f:	89 04 24             	mov    %eax,(%esp)
80104482:	e8 7a d5 ff ff       	call   80101a01 <iput>
  proc->cwd = 0;
80104487:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010448d:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104494:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010449b:	e8 44 07 00 00       	call   80104be4 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801044a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044a6:	8b 40 14             	mov    0x14(%eax),%eax
801044a9:	89 04 24             	mov    %eax,(%esp)
801044ac:	e8 fb 04 00 00       	call   801049ac <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b1:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801044b8:	eb 3b                	jmp    801044f5 <exit+0xf4>
    if(p->parent == proc){
801044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bd:	8b 50 14             	mov    0x14(%eax),%edx
801044c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c6:	39 c2                	cmp    %eax,%edx
801044c8:	75 24                	jne    801044ee <exit+0xed>
      p->parent = initproc;
801044ca:	8b 15 50 b6 10 80    	mov    0x8010b650,%edx
801044d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d3:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801044d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d9:	8b 40 0c             	mov    0xc(%eax),%eax
801044dc:	83 f8 05             	cmp    $0x5,%eax
801044df:	75 0d                	jne    801044ee <exit+0xed>
        wakeup1(initproc);
801044e1:	a1 50 b6 10 80       	mov    0x8010b650,%eax
801044e6:	89 04 24             	mov    %eax,(%esp)
801044e9:	e8 be 04 00 00       	call   801049ac <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ee:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
801044f5:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
801044fc:	72 bc                	jb     801044ba <exit+0xb9>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801044fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104504:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010450b:	e8 d6 02 00 00       	call   801047e6 <sched>
  panic("zombie exit");
80104510:	c7 04 24 f1 84 10 80 	movl   $0x801084f1,(%esp)
80104517:	e8 1e c0 ff ff       	call   8010053a <panic>

8010451c <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010451c:	55                   	push   %ebp
8010451d:	89 e5                	mov    %esp,%ebp
8010451f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104522:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104529:	e8 b6 06 00 00       	call   80104be4 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
8010452e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104535:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010453c:	e9 9d 00 00 00       	jmp    801045de <wait+0xc2>
      if(p->parent != proc)
80104541:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104544:	8b 50 14             	mov    0x14(%eax),%edx
80104547:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010454d:	39 c2                	cmp    %eax,%edx
8010454f:	74 05                	je     80104556 <wait+0x3a>
        continue;
80104551:	e9 81 00 00 00       	jmp    801045d7 <wait+0xbb>
      havekids = 1;
80104556:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010455d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104560:	8b 40 0c             	mov    0xc(%eax),%eax
80104563:	83 f8 05             	cmp    $0x5,%eax
80104566:	75 6f                	jne    801045d7 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456b:	8b 40 10             	mov    0x10(%eax),%eax
8010456e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104574:	8b 40 08             	mov    0x8(%eax),%eax
80104577:	89 04 24             	mov    %eax,(%esp)
8010457a:	e8 bd e4 ff ff       	call   80102a3c <kfree>
        p->kstack = 0;
8010457f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458c:	8b 40 04             	mov    0x4(%eax),%eax
8010458f:	89 04 24             	mov    %eax,(%esp)
80104592:	e8 64 39 00 00       	call   80107efb <freevm>
        p->state = UNUSED;
80104597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801045a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a4:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801045ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ae:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801045b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b8:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801045bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bf:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
801045c6:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801045cd:	e8 74 06 00 00       	call   80104c46 <release>
        return pid;
801045d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045d5:	eb 55                	jmp    8010462c <wait+0x110>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d7:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
801045de:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
801045e5:	0f 82 56 ff ff ff    	jb     80104541 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801045eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801045ef:	74 0d                	je     801045fe <wait+0xe2>
801045f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045f7:	8b 40 24             	mov    0x24(%eax),%eax
801045fa:	85 c0                	test   %eax,%eax
801045fc:	74 13                	je     80104611 <wait+0xf5>
      release(&ptable.lock);
801045fe:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104605:	e8 3c 06 00 00       	call   80104c46 <release>
      return -1;
8010460a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010460f:	eb 1b                	jmp    8010462c <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104611:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104617:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
8010461e:	80 
8010461f:	89 04 24             	mov    %eax,(%esp)
80104622:	e8 ea 02 00 00       	call   80104911 <sleep>
  }
80104627:	e9 02 ff ff ff       	jmp    8010452e <wait+0x12>
}
8010462c:	c9                   	leave  
8010462d:	c3                   	ret    

8010462e <register_handler>:

void
register_handler(sighandler_t sighandler)
{
8010462e:	55                   	push   %ebp
8010462f:	89 e5                	mov    %esp,%ebp
80104631:	83 ec 28             	sub    $0x28,%esp
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
80104634:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010463a:	8b 40 18             	mov    0x18(%eax),%eax
8010463d:	8b 40 44             	mov    0x44(%eax),%eax
80104640:	89 c2                	mov    %eax,%edx
80104642:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104648:	8b 40 04             	mov    0x4(%eax),%eax
8010464b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010464f:	89 04 24             	mov    %eax,(%esp)
80104652:	e8 95 3a 00 00       	call   801080ec <uva2ka>
80104657:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((proc->tf->esp & 0xFFF) == 0)
8010465a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104660:	8b 40 18             	mov    0x18(%eax),%eax
80104663:	8b 40 44             	mov    0x44(%eax),%eax
80104666:	25 ff 0f 00 00       	and    $0xfff,%eax
8010466b:	85 c0                	test   %eax,%eax
8010466d:	75 0c                	jne    8010467b <register_handler+0x4d>
    panic("esp_offset == 0");
8010466f:	c7 04 24 fd 84 10 80 	movl   $0x801084fd,(%esp)
80104676:	e8 bf be ff ff       	call   8010053a <panic>

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
8010467b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104681:	8b 40 18             	mov    0x18(%eax),%eax
80104684:	8b 40 44             	mov    0x44(%eax),%eax
80104687:	83 e8 04             	sub    $0x4,%eax
8010468a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010468f:	89 c2                	mov    %eax,%edx
80104691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104694:	01 c2                	add    %eax,%edx
          = proc->tf->eip;
80104696:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469c:	8b 40 18             	mov    0x18(%eax),%eax
8010469f:	8b 40 38             	mov    0x38(%eax),%eax
801046a2:	89 02                	mov    %eax,(%edx)
  proc->tf->esp -= 4;
801046a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046aa:	8b 40 18             	mov    0x18(%eax),%eax
801046ad:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046b4:	8b 52 18             	mov    0x18(%edx),%edx
801046b7:	8b 52 44             	mov    0x44(%edx),%edx
801046ba:	83 ea 04             	sub    $0x4,%edx
801046bd:	89 50 44             	mov    %edx,0x44(%eax)

    /* update eip */
  proc->tf->eip = (uint)sighandler;
801046c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046c6:	8b 40 18             	mov    0x18(%eax),%eax
801046c9:	8b 55 08             	mov    0x8(%ebp),%edx
801046cc:	89 50 38             	mov    %edx,0x38(%eax)
}
801046cf:	c9                   	leave  
801046d0:	c3                   	ret    

801046d1 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801046d1:	55                   	push   %ebp
801046d2:	89 e5                	mov    %esp,%ebp
801046d4:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801046d7:	e8 bb f8 ff ff       	call   80103f97 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801046dc:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801046e3:	e8 fc 04 00 00       	call   80104be4 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e8:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801046ef:	e9 d4 00 00 00       	jmp    801047c8 <scheduler+0xf7>
      if(p->state != RUNNABLE)
801046f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f7:	8b 40 0c             	mov    0xc(%eax),%eax
801046fa:	83 f8 03             	cmp    $0x3,%eax
801046fd:	74 05                	je     80104704 <scheduler+0x33>
        continue;
801046ff:	e9 bd 00 00 00       	jmp    801047c1 <scheduler+0xf0>

#ifdef FRR
      if (p->placeInQ != firstInQ) {
80104704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104707:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010470d:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104712:	39 c2                	cmp    %eax,%edx
80104714:	74 05                	je     8010471b <scheduler+0x4a>
    	  continue;
80104716:	e9 a6 00 00 00       	jmp    801047c1 <scheduler+0xf0>
      } else {
    	  p->quanta = 1;
8010471b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471e:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
      cprintf("DEFAULT!");
#endif
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104728:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      cprintf("process pid is %d\n",proc->pid);
8010472e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104734:	8b 40 10             	mov    0x10(%eax),%eax
80104737:	89 44 24 04          	mov    %eax,0x4(%esp)
8010473b:	c7 04 24 0d 85 10 80 	movl   $0x8010850d,(%esp)
80104742:	e8 59 bc ff ff       	call   801003a0 <cprintf>
      switchuvm(p);
80104747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474a:	89 04 24             	mov    %eax,(%esp)
8010474d:	e8 36 33 00 00       	call   80107a88 <switchuvm>
      p->state = RUNNING;
80104752:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104755:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
8010475c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104762:	8b 40 1c             	mov    0x1c(%eax),%eax
80104765:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010476c:	83 c2 04             	add    $0x4,%edx
8010476f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104773:	89 14 24             	mov    %edx,(%esp)
80104776:	e8 4e 09 00 00       	call   801050c9 <swtch>
      switchkvm();
8010477b:	e8 eb 32 00 00       	call   80107a6b <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      if (proc->state == RUNNABLE) {
80104780:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104786:	8b 40 0c             	mov    0xc(%eax),%eax
80104789:	83 f8 03             	cmp    $0x3,%eax
8010478c:	75 28                	jne    801047b6 <scheduler+0xe5>
    	  firstInQ++;
8010478e:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104793:	83 c0 01             	add    $0x1,%eax
80104796:	a3 48 b6 10 80       	mov    %eax,0x8010b648
    	  proc->placeInQ = lastInQ++;
8010479b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047a2:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801047a7:	8d 48 01             	lea    0x1(%eax),%ecx
801047aa:	89 0d 4c b6 10 80    	mov    %ecx,0x8010b64c
801047b0:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
      }
      proc = 0;
801047b6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801047bd:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047c1:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
801047c8:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
801047cf:	0f 82 1f ff ff ff    	jb     801046f4 <scheduler+0x23>
    	  firstInQ++;
    	  proc->placeInQ = lastInQ++;
      }
      proc = 0;
    }
    release(&ptable.lock);
801047d5:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047dc:	e8 65 04 00 00       	call   80104c46 <release>

  }
801047e1:	e9 f1 fe ff ff       	jmp    801046d7 <scheduler+0x6>

801047e6 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801047e6:	55                   	push   %ebp
801047e7:	89 e5                	mov    %esp,%ebp
801047e9:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801047ec:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047f3:	e8 16 05 00 00       	call   80104d0e <holding>
801047f8:	85 c0                	test   %eax,%eax
801047fa:	75 0c                	jne    80104808 <sched+0x22>
    panic("sched ptable.lock");
801047fc:	c7 04 24 20 85 10 80 	movl   $0x80108520,(%esp)
80104803:	e8 32 bd ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104808:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010480e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104814:	83 f8 01             	cmp    $0x1,%eax
80104817:	74 0c                	je     80104825 <sched+0x3f>
    panic("sched locks");
80104819:	c7 04 24 32 85 10 80 	movl   $0x80108532,(%esp)
80104820:	e8 15 bd ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
80104825:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010482b:	8b 40 0c             	mov    0xc(%eax),%eax
8010482e:	83 f8 04             	cmp    $0x4,%eax
80104831:	75 0c                	jne    8010483f <sched+0x59>
    panic("sched running");
80104833:	c7 04 24 3e 85 10 80 	movl   $0x8010853e,(%esp)
8010483a:	e8 fb bc ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
8010483f:	e8 43 f7 ff ff       	call   80103f87 <readeflags>
80104844:	25 00 02 00 00       	and    $0x200,%eax
80104849:	85 c0                	test   %eax,%eax
8010484b:	74 0c                	je     80104859 <sched+0x73>
    panic("sched interruptible");
8010484d:	c7 04 24 4c 85 10 80 	movl   $0x8010854c,(%esp)
80104854:	e8 e1 bc ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104859:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010485f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104868:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010486e:	8b 40 04             	mov    0x4(%eax),%eax
80104871:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104878:	83 c2 1c             	add    $0x1c,%edx
8010487b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010487f:	89 14 24             	mov    %edx,(%esp)
80104882:	e8 42 08 00 00       	call   801050c9 <swtch>
  cpu->intena = intena;
80104887:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010488d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104890:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104896:	c9                   	leave  
80104897:	c3                   	ret    

80104898 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104898:	55                   	push   %ebp
80104899:	89 e5                	mov    %esp,%ebp
8010489b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010489e:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048a5:	e8 3a 03 00 00       	call   80104be4 <acquire>
  proc->state = RUNNABLE;
801048aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  proc->placeInQ = lastInQ++;
801048b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048be:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801048c3:	8d 48 01             	lea    0x1(%eax),%ecx
801048c6:	89 0d 4c b6 10 80    	mov    %ecx,0x8010b64c
801048cc:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  sched();
801048d2:	e8 0f ff ff ff       	call   801047e6 <sched>
  release(&ptable.lock);
801048d7:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048de:	e8 63 03 00 00       	call   80104c46 <release>
}
801048e3:	c9                   	leave  
801048e4:	c3                   	ret    

801048e5 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801048e5:	55                   	push   %ebp
801048e6:	89 e5                	mov    %esp,%ebp
801048e8:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801048eb:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048f2:	e8 4f 03 00 00       	call   80104c46 <release>

  if (first) {
801048f7:	a1 08 b0 10 80       	mov    0x8010b008,%eax
801048fc:	85 c0                	test   %eax,%eax
801048fe:	74 0f                	je     8010490f <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104900:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104907:	00 00 00 
    initlog();
8010490a:	e8 bb e6 ff ff       	call   80102fca <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010490f:	c9                   	leave  
80104910:	c3                   	ret    

80104911 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104911:	55                   	push   %ebp
80104912:	89 e5                	mov    %esp,%ebp
80104914:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104917:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491d:	85 c0                	test   %eax,%eax
8010491f:	75 0c                	jne    8010492d <sleep+0x1c>
    panic("sleep");
80104921:	c7 04 24 60 85 10 80 	movl   $0x80108560,(%esp)
80104928:	e8 0d bc ff ff       	call   8010053a <panic>

  if(lk == 0)
8010492d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104931:	75 0c                	jne    8010493f <sleep+0x2e>
    panic("sleep without lk");
80104933:	c7 04 24 66 85 10 80 	movl   $0x80108566,(%esp)
8010493a:	e8 fb bb ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010493f:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
80104946:	74 17                	je     8010495f <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104948:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010494f:	e8 90 02 00 00       	call   80104be4 <acquire>
    release(lk);
80104954:	8b 45 0c             	mov    0xc(%ebp),%eax
80104957:	89 04 24             	mov    %eax,(%esp)
8010495a:	e8 e7 02 00 00       	call   80104c46 <release>
  }

  // Go to sleep.
  proc->chan = chan;
8010495f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104965:	8b 55 08             	mov    0x8(%ebp),%edx
80104968:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
8010496b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104971:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104978:	e8 69 fe ff ff       	call   801047e6 <sched>

  // Tidy up.
  proc->chan = 0;
8010497d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104983:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010498a:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
80104991:	74 17                	je     801049aa <sleep+0x99>
    release(&ptable.lock);
80104993:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010499a:	e8 a7 02 00 00       	call   80104c46 <release>
    acquire(lk);
8010499f:	8b 45 0c             	mov    0xc(%ebp),%eax
801049a2:	89 04 24             	mov    %eax,(%esp)
801049a5:	e8 3a 02 00 00       	call   80104be4 <acquire>
  }
}
801049aa:	c9                   	leave  
801049ab:	c3                   	ret    

801049ac <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801049ac:	55                   	push   %ebp
801049ad:	89 e5                	mov    %esp,%ebp
801049af:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049b2:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
801049b9:	eb 27                	jmp    801049e2 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
801049bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049be:	8b 40 0c             	mov    0xc(%eax),%eax
801049c1:	83 f8 02             	cmp    $0x2,%eax
801049c4:	75 15                	jne    801049db <wakeup1+0x2f>
801049c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049c9:	8b 40 20             	mov    0x20(%eax),%eax
801049cc:	3b 45 08             	cmp    0x8(%ebp),%eax
801049cf:	75 0a                	jne    801049db <wakeup1+0x2f>
      p->state = RUNNABLE;
801049d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049d4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049db:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
801049e2:	81 7d fc 54 21 11 80 	cmpl   $0x80112154,-0x4(%ebp)
801049e9:	72 d0                	jb     801049bb <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
  	  //cprintf("wakeup1: proc %d became runnable\n",proc->pid);
}
801049eb:	c9                   	leave  
801049ec:	c3                   	ret    

801049ed <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049ed:	55                   	push   %ebp
801049ee:	89 e5                	mov    %esp,%ebp
801049f0:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801049f3:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801049fa:	e8 e5 01 00 00       	call   80104be4 <acquire>
  wakeup1(chan);
801049ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104a02:	89 04 24             	mov    %eax,(%esp)
80104a05:	e8 a2 ff ff ff       	call   801049ac <wakeup1>
  release(&ptable.lock);
80104a0a:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a11:	e8 30 02 00 00       	call   80104c46 <release>
}
80104a16:	c9                   	leave  
80104a17:	c3                   	ret    

80104a18 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a18:	55                   	push   %ebp
80104a19:	89 e5                	mov    %esp,%ebp
80104a1b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104a1e:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a25:	e8 ba 01 00 00       	call   80104be4 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a2a:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104a31:	eb 44                	jmp    80104a77 <kill+0x5f>
    if(p->pid == pid){
80104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a36:	8b 40 10             	mov    0x10(%eax),%eax
80104a39:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a3c:	75 32                	jne    80104a70 <kill+0x58>
      p->killed = 1;
80104a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a41:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4b:	8b 40 0c             	mov    0xc(%eax),%eax
80104a4e:	83 f8 02             	cmp    $0x2,%eax
80104a51:	75 0a                	jne    80104a5d <kill+0x45>
        p->state = RUNNABLE;
80104a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a56:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a5d:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a64:	e8 dd 01 00 00       	call   80104c46 <release>
      return 0;
80104a69:	b8 00 00 00 00       	mov    $0x0,%eax
80104a6e:	eb 21                	jmp    80104a91 <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a70:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104a77:	81 7d f4 54 21 11 80 	cmpl   $0x80112154,-0xc(%ebp)
80104a7e:	72 b3                	jb     80104a33 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104a80:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a87:	e8 ba 01 00 00       	call   80104c46 <release>
  return -1;
80104a8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a91:	c9                   	leave  
80104a92:	c3                   	ret    

80104a93 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a93:	55                   	push   %ebp
80104a94:	89 e5                	mov    %esp,%ebp
80104a96:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a99:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
80104aa0:	e9 d9 00 00 00       	jmp    80104b7e <procdump+0xeb>
    if(p->state == UNUSED)
80104aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aa8:	8b 40 0c             	mov    0xc(%eax),%eax
80104aab:	85 c0                	test   %eax,%eax
80104aad:	75 05                	jne    80104ab4 <procdump+0x21>
      continue;
80104aaf:	e9 c3 00 00 00       	jmp    80104b77 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ab7:	8b 40 0c             	mov    0xc(%eax),%eax
80104aba:	83 f8 05             	cmp    $0x5,%eax
80104abd:	77 23                	ja     80104ae2 <procdump+0x4f>
80104abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ac2:	8b 40 0c             	mov    0xc(%eax),%eax
80104ac5:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104acc:	85 c0                	test   %eax,%eax
80104ace:	74 12                	je     80104ae2 <procdump+0x4f>
      state = states[p->state];
80104ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ad3:	8b 40 0c             	mov    0xc(%eax),%eax
80104ad6:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104add:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ae0:	eb 07                	jmp    80104ae9 <procdump+0x56>
    else
      state = "???";
80104ae2:	c7 45 ec 77 85 10 80 	movl   $0x80108577,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aec:	8d 50 6c             	lea    0x6c(%eax),%edx
80104aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104af2:	8b 40 10             	mov    0x10(%eax),%eax
80104af5:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104af9:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104afc:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b00:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b04:	c7 04 24 7b 85 10 80 	movl   $0x8010857b,(%esp)
80104b0b:	e8 90 b8 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80104b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b13:	8b 40 0c             	mov    0xc(%eax),%eax
80104b16:	83 f8 02             	cmp    $0x2,%eax
80104b19:	75 50                	jne    80104b6b <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b1e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b21:	8b 40 0c             	mov    0xc(%eax),%eax
80104b24:	83 c0 08             	add    $0x8,%eax
80104b27:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104b2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b2e:	89 04 24             	mov    %eax,(%esp)
80104b31:	e8 5f 01 00 00       	call   80104c95 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b3d:	eb 1b                	jmp    80104b5a <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b42:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104b46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b4a:	c7 04 24 84 85 10 80 	movl   $0x80108584,(%esp)
80104b51:	e8 4a b8 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104b56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104b5a:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104b5e:	7f 0b                	jg     80104b6b <procdump+0xd8>
80104b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b63:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104b67:	85 c0                	test   %eax,%eax
80104b69:	75 d4                	jne    80104b3f <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104b6b:	c7 04 24 88 85 10 80 	movl   $0x80108588,(%esp)
80104b72:	e8 29 b8 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b77:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
80104b7e:	81 7d f0 54 21 11 80 	cmpl   $0x80112154,-0x10(%ebp)
80104b85:	0f 82 1a ff ff ff    	jb     80104aa5 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104b8b:	c9                   	leave  
80104b8c:	c3                   	ret    

80104b8d <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104b8d:	55                   	push   %ebp
80104b8e:	89 e5                	mov    %esp,%ebp
80104b90:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b93:	9c                   	pushf  
80104b94:	58                   	pop    %eax
80104b95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104b98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104b9b:	c9                   	leave  
80104b9c:	c3                   	ret    

80104b9d <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104b9d:	55                   	push   %ebp
80104b9e:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104ba0:	fa                   	cli    
}
80104ba1:	5d                   	pop    %ebp
80104ba2:	c3                   	ret    

80104ba3 <sti>:

static inline void
sti(void)
{
80104ba3:	55                   	push   %ebp
80104ba4:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104ba6:	fb                   	sti    
}
80104ba7:	5d                   	pop    %ebp
80104ba8:	c3                   	ret    

80104ba9 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104ba9:	55                   	push   %ebp
80104baa:	89 e5                	mov    %esp,%ebp
80104bac:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104baf:	8b 55 08             	mov    0x8(%ebp),%edx
80104bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bb8:	f0 87 02             	lock xchg %eax,(%edx)
80104bbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104bc1:	c9                   	leave  
80104bc2:	c3                   	ret    

80104bc3 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104bc3:	55                   	push   %ebp
80104bc4:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104bc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bcc:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80104bd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80104bdb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104be2:	5d                   	pop    %ebp
80104be3:	c3                   	ret    

80104be4 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104bea:	e8 49 01 00 00       	call   80104d38 <pushcli>
  if(holding(lk))
80104bef:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf2:	89 04 24             	mov    %eax,(%esp)
80104bf5:	e8 14 01 00 00       	call   80104d0e <holding>
80104bfa:	85 c0                	test   %eax,%eax
80104bfc:	74 0c                	je     80104c0a <acquire+0x26>
    panic("acquire");
80104bfe:	c7 04 24 b4 85 10 80 	movl   $0x801085b4,(%esp)
80104c05:	e8 30 b9 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104c0a:	90                   	nop
80104c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80104c0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104c15:	00 
80104c16:	89 04 24             	mov    %eax,(%esp)
80104c19:	e8 8b ff ff ff       	call   80104ba9 <xchg>
80104c1e:	85 c0                	test   %eax,%eax
80104c20:	75 e9                	jne    80104c0b <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104c22:	8b 45 08             	mov    0x8(%ebp),%eax
80104c25:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c2c:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80104c32:	83 c0 0c             	add    $0xc,%eax
80104c35:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c39:	8d 45 08             	lea    0x8(%ebp),%eax
80104c3c:	89 04 24             	mov    %eax,(%esp)
80104c3f:	e8 51 00 00 00       	call   80104c95 <getcallerpcs>
}
80104c44:	c9                   	leave  
80104c45:	c3                   	ret    

80104c46 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104c46:	55                   	push   %ebp
80104c47:	89 e5                	mov    %esp,%ebp
80104c49:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80104c4f:	89 04 24             	mov    %eax,(%esp)
80104c52:	e8 b7 00 00 00       	call   80104d0e <holding>
80104c57:	85 c0                	test   %eax,%eax
80104c59:	75 0c                	jne    80104c67 <release+0x21>
    panic("release");
80104c5b:	c7 04 24 bc 85 10 80 	movl   $0x801085bc,(%esp)
80104c62:	e8 d3 b8 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104c67:	8b 45 08             	mov    0x8(%ebp),%eax
80104c6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104c71:	8b 45 08             	mov    0x8(%ebp),%eax
80104c74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104c7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104c7e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c85:	00 
80104c86:	89 04 24             	mov    %eax,(%esp)
80104c89:	e8 1b ff ff ff       	call   80104ba9 <xchg>

  popcli();
80104c8e:	e8 e9 00 00 00       	call   80104d7c <popcli>
}
80104c93:	c9                   	leave  
80104c94:	c3                   	ret    

80104c95 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c95:	55                   	push   %ebp
80104c96:	89 e5                	mov    %esp,%ebp
80104c98:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9e:	83 e8 08             	sub    $0x8,%eax
80104ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104ca4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104cab:	eb 38                	jmp    80104ce5 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104cb1:	74 38                	je     80104ceb <getcallerpcs+0x56>
80104cb3:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104cba:	76 2f                	jbe    80104ceb <getcallerpcs+0x56>
80104cbc:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104cc0:	74 29                	je     80104ceb <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104cc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ccf:	01 c2                	add    %eax,%edx
80104cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cd4:	8b 40 04             	mov    0x4(%eax),%eax
80104cd7:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cdc:	8b 00                	mov    (%eax),%eax
80104cde:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ce1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104ce5:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ce9:	7e c2                	jle    80104cad <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ceb:	eb 19                	jmp    80104d06 <getcallerpcs+0x71>
    pcs[i] = 0;
80104ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104cf0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cfa:	01 d0                	add    %edx,%eax
80104cfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d02:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104d06:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104d0a:	7e e1                	jle    80104ced <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104d0c:	c9                   	leave  
80104d0d:	c3                   	ret    

80104d0e <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104d0e:	55                   	push   %ebp
80104d0f:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104d11:	8b 45 08             	mov    0x8(%ebp),%eax
80104d14:	8b 00                	mov    (%eax),%eax
80104d16:	85 c0                	test   %eax,%eax
80104d18:	74 17                	je     80104d31 <holding+0x23>
80104d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d1d:	8b 50 08             	mov    0x8(%eax),%edx
80104d20:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d26:	39 c2                	cmp    %eax,%edx
80104d28:	75 07                	jne    80104d31 <holding+0x23>
80104d2a:	b8 01 00 00 00       	mov    $0x1,%eax
80104d2f:	eb 05                	jmp    80104d36 <holding+0x28>
80104d31:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d36:	5d                   	pop    %ebp
80104d37:	c3                   	ret    

80104d38 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d38:	55                   	push   %ebp
80104d39:	89 e5                	mov    %esp,%ebp
80104d3b:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104d3e:	e8 4a fe ff ff       	call   80104b8d <readeflags>
80104d43:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104d46:	e8 52 fe ff ff       	call   80104b9d <cli>
  if(cpu->ncli++ == 0)
80104d4b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d52:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104d58:	8d 48 01             	lea    0x1(%eax),%ecx
80104d5b:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80104d61:	85 c0                	test   %eax,%eax
80104d63:	75 15                	jne    80104d7a <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80104d65:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d6e:	81 e2 00 02 00 00    	and    $0x200,%edx
80104d74:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d7a:	c9                   	leave  
80104d7b:	c3                   	ret    

80104d7c <popcli>:

void
popcli(void)
{
80104d7c:	55                   	push   %ebp
80104d7d:	89 e5                	mov    %esp,%ebp
80104d7f:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104d82:	e8 06 fe ff ff       	call   80104b8d <readeflags>
80104d87:	25 00 02 00 00       	and    $0x200,%eax
80104d8c:	85 c0                	test   %eax,%eax
80104d8e:	74 0c                	je     80104d9c <popcli+0x20>
    panic("popcli - interruptible");
80104d90:	c7 04 24 c4 85 10 80 	movl   $0x801085c4,(%esp)
80104d97:	e8 9e b7 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80104d9c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104da2:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104da8:	83 ea 01             	sub    $0x1,%edx
80104dab:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104db1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104db7:	85 c0                	test   %eax,%eax
80104db9:	79 0c                	jns    80104dc7 <popcli+0x4b>
    panic("popcli");
80104dbb:	c7 04 24 db 85 10 80 	movl   $0x801085db,(%esp)
80104dc2:	e8 73 b7 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104dc7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dcd:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104dd3:	85 c0                	test   %eax,%eax
80104dd5:	75 15                	jne    80104dec <popcli+0x70>
80104dd7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ddd:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104de3:	85 c0                	test   %eax,%eax
80104de5:	74 05                	je     80104dec <popcli+0x70>
    sti();
80104de7:	e8 b7 fd ff ff       	call   80104ba3 <sti>
}
80104dec:	c9                   	leave  
80104ded:	c3                   	ret    

80104dee <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104dee:	55                   	push   %ebp
80104def:	89 e5                	mov    %esp,%ebp
80104df1:	57                   	push   %edi
80104df2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104df3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104df6:	8b 55 10             	mov    0x10(%ebp),%edx
80104df9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dfc:	89 cb                	mov    %ecx,%ebx
80104dfe:	89 df                	mov    %ebx,%edi
80104e00:	89 d1                	mov    %edx,%ecx
80104e02:	fc                   	cld    
80104e03:	f3 aa                	rep stos %al,%es:(%edi)
80104e05:	89 ca                	mov    %ecx,%edx
80104e07:	89 fb                	mov    %edi,%ebx
80104e09:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e0c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e0f:	5b                   	pop    %ebx
80104e10:	5f                   	pop    %edi
80104e11:	5d                   	pop    %ebp
80104e12:	c3                   	ret    

80104e13 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104e13:	55                   	push   %ebp
80104e14:	89 e5                	mov    %esp,%ebp
80104e16:	57                   	push   %edi
80104e17:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104e18:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e1b:	8b 55 10             	mov    0x10(%ebp),%edx
80104e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e21:	89 cb                	mov    %ecx,%ebx
80104e23:	89 df                	mov    %ebx,%edi
80104e25:	89 d1                	mov    %edx,%ecx
80104e27:	fc                   	cld    
80104e28:	f3 ab                	rep stos %eax,%es:(%edi)
80104e2a:	89 ca                	mov    %ecx,%edx
80104e2c:	89 fb                	mov    %edi,%ebx
80104e2e:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e31:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e34:	5b                   	pop    %ebx
80104e35:	5f                   	pop    %edi
80104e36:	5d                   	pop    %ebp
80104e37:	c3                   	ret    

80104e38 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e38:	55                   	push   %ebp
80104e39:	89 e5                	mov    %esp,%ebp
80104e3b:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e41:	83 e0 03             	and    $0x3,%eax
80104e44:	85 c0                	test   %eax,%eax
80104e46:	75 49                	jne    80104e91 <memset+0x59>
80104e48:	8b 45 10             	mov    0x10(%ebp),%eax
80104e4b:	83 e0 03             	and    $0x3,%eax
80104e4e:	85 c0                	test   %eax,%eax
80104e50:	75 3f                	jne    80104e91 <memset+0x59>
    c &= 0xFF;
80104e52:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e59:	8b 45 10             	mov    0x10(%ebp),%eax
80104e5c:	c1 e8 02             	shr    $0x2,%eax
80104e5f:	89 c2                	mov    %eax,%edx
80104e61:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e64:	c1 e0 18             	shl    $0x18,%eax
80104e67:	89 c1                	mov    %eax,%ecx
80104e69:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6c:	c1 e0 10             	shl    $0x10,%eax
80104e6f:	09 c1                	or     %eax,%ecx
80104e71:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e74:	c1 e0 08             	shl    $0x8,%eax
80104e77:	09 c8                	or     %ecx,%eax
80104e79:	0b 45 0c             	or     0xc(%ebp),%eax
80104e7c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104e80:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e84:	8b 45 08             	mov    0x8(%ebp),%eax
80104e87:	89 04 24             	mov    %eax,(%esp)
80104e8a:	e8 84 ff ff ff       	call   80104e13 <stosl>
80104e8f:	eb 19                	jmp    80104eaa <memset+0x72>
  } else
    stosb(dst, c, n);
80104e91:	8b 45 10             	mov    0x10(%ebp),%eax
80104e94:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e98:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea2:	89 04 24             	mov    %eax,(%esp)
80104ea5:	e8 44 ff ff ff       	call   80104dee <stosb>
  return dst;
80104eaa:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104ead:	c9                   	leave  
80104eae:	c3                   	ret    

80104eaf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104eaf:	55                   	push   %ebp
80104eb0:	89 e5                	mov    %esp,%ebp
80104eb2:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80104eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ebe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104ec1:	eb 30                	jmp    80104ef3 <memcmp+0x44>
    if(*s1 != *s2)
80104ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ec6:	0f b6 10             	movzbl (%eax),%edx
80104ec9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ecc:	0f b6 00             	movzbl (%eax),%eax
80104ecf:	38 c2                	cmp    %al,%dl
80104ed1:	74 18                	je     80104eeb <memcmp+0x3c>
      return *s1 - *s2;
80104ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ed6:	0f b6 00             	movzbl (%eax),%eax
80104ed9:	0f b6 d0             	movzbl %al,%edx
80104edc:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104edf:	0f b6 00             	movzbl (%eax),%eax
80104ee2:	0f b6 c0             	movzbl %al,%eax
80104ee5:	29 c2                	sub    %eax,%edx
80104ee7:	89 d0                	mov    %edx,%eax
80104ee9:	eb 1a                	jmp    80104f05 <memcmp+0x56>
    s1++, s2++;
80104eeb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104eef:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104ef3:	8b 45 10             	mov    0x10(%ebp),%eax
80104ef6:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ef9:	89 55 10             	mov    %edx,0x10(%ebp)
80104efc:	85 c0                	test   %eax,%eax
80104efe:	75 c3                	jne    80104ec3 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104f00:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f05:	c9                   	leave  
80104f06:	c3                   	ret    

80104f07 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f07:	55                   	push   %ebp
80104f08:	89 e5                	mov    %esp,%ebp
80104f0a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104f13:	8b 45 08             	mov    0x8(%ebp),%eax
80104f16:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104f1f:	73 3d                	jae    80104f5e <memmove+0x57>
80104f21:	8b 45 10             	mov    0x10(%ebp),%eax
80104f24:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f27:	01 d0                	add    %edx,%eax
80104f29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104f2c:	76 30                	jbe    80104f5e <memmove+0x57>
    s += n;
80104f2e:	8b 45 10             	mov    0x10(%ebp),%eax
80104f31:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104f34:	8b 45 10             	mov    0x10(%ebp),%eax
80104f37:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104f3a:	eb 13                	jmp    80104f4f <memmove+0x48>
      *--d = *--s;
80104f3c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104f40:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f47:	0f b6 10             	movzbl (%eax),%edx
80104f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f4d:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104f4f:	8b 45 10             	mov    0x10(%ebp),%eax
80104f52:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f55:	89 55 10             	mov    %edx,0x10(%ebp)
80104f58:	85 c0                	test   %eax,%eax
80104f5a:	75 e0                	jne    80104f3c <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f5c:	eb 26                	jmp    80104f84 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104f5e:	eb 17                	jmp    80104f77 <memmove+0x70>
      *d++ = *s++;
80104f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f63:	8d 50 01             	lea    0x1(%eax),%edx
80104f66:	89 55 f8             	mov    %edx,-0x8(%ebp)
80104f69:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f6c:	8d 4a 01             	lea    0x1(%edx),%ecx
80104f6f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80104f72:	0f b6 12             	movzbl (%edx),%edx
80104f75:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104f77:	8b 45 10             	mov    0x10(%ebp),%eax
80104f7a:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f7d:	89 55 10             	mov    %edx,0x10(%ebp)
80104f80:	85 c0                	test   %eax,%eax
80104f82:	75 dc                	jne    80104f60 <memmove+0x59>
      *d++ = *s++;

  return dst;
80104f84:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104f87:	c9                   	leave  
80104f88:	c3                   	ret    

80104f89 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104f89:	55                   	push   %ebp
80104f8a:	89 e5                	mov    %esp,%ebp
80104f8c:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80104f8f:	8b 45 10             	mov    0x10(%ebp),%eax
80104f92:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f96:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa0:	89 04 24             	mov    %eax,(%esp)
80104fa3:	e8 5f ff ff ff       	call   80104f07 <memmove>
}
80104fa8:	c9                   	leave  
80104fa9:	c3                   	ret    

80104faa <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104faa:	55                   	push   %ebp
80104fab:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104fad:	eb 0c                	jmp    80104fbb <strncmp+0x11>
    n--, p++, q++;
80104faf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104fb3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104fb7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104fbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fbf:	74 1a                	je     80104fdb <strncmp+0x31>
80104fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc4:	0f b6 00             	movzbl (%eax),%eax
80104fc7:	84 c0                	test   %al,%al
80104fc9:	74 10                	je     80104fdb <strncmp+0x31>
80104fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fce:	0f b6 10             	movzbl (%eax),%edx
80104fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd4:	0f b6 00             	movzbl (%eax),%eax
80104fd7:	38 c2                	cmp    %al,%dl
80104fd9:	74 d4                	je     80104faf <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80104fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fdf:	75 07                	jne    80104fe8 <strncmp+0x3e>
    return 0;
80104fe1:	b8 00 00 00 00       	mov    $0x0,%eax
80104fe6:	eb 16                	jmp    80104ffe <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80104fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80104feb:	0f b6 00             	movzbl (%eax),%eax
80104fee:	0f b6 d0             	movzbl %al,%edx
80104ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff4:	0f b6 00             	movzbl (%eax),%eax
80104ff7:	0f b6 c0             	movzbl %al,%eax
80104ffa:	29 c2                	sub    %eax,%edx
80104ffc:	89 d0                	mov    %edx,%eax
}
80104ffe:	5d                   	pop    %ebp
80104fff:	c3                   	ret    

80105000 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105006:	8b 45 08             	mov    0x8(%ebp),%eax
80105009:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010500c:	90                   	nop
8010500d:	8b 45 10             	mov    0x10(%ebp),%eax
80105010:	8d 50 ff             	lea    -0x1(%eax),%edx
80105013:	89 55 10             	mov    %edx,0x10(%ebp)
80105016:	85 c0                	test   %eax,%eax
80105018:	7e 1e                	jle    80105038 <strncpy+0x38>
8010501a:	8b 45 08             	mov    0x8(%ebp),%eax
8010501d:	8d 50 01             	lea    0x1(%eax),%edx
80105020:	89 55 08             	mov    %edx,0x8(%ebp)
80105023:	8b 55 0c             	mov    0xc(%ebp),%edx
80105026:	8d 4a 01             	lea    0x1(%edx),%ecx
80105029:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010502c:	0f b6 12             	movzbl (%edx),%edx
8010502f:	88 10                	mov    %dl,(%eax)
80105031:	0f b6 00             	movzbl (%eax),%eax
80105034:	84 c0                	test   %al,%al
80105036:	75 d5                	jne    8010500d <strncpy+0xd>
    ;
  while(n-- > 0)
80105038:	eb 0c                	jmp    80105046 <strncpy+0x46>
    *s++ = 0;
8010503a:	8b 45 08             	mov    0x8(%ebp),%eax
8010503d:	8d 50 01             	lea    0x1(%eax),%edx
80105040:	89 55 08             	mov    %edx,0x8(%ebp)
80105043:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105046:	8b 45 10             	mov    0x10(%ebp),%eax
80105049:	8d 50 ff             	lea    -0x1(%eax),%edx
8010504c:	89 55 10             	mov    %edx,0x10(%ebp)
8010504f:	85 c0                	test   %eax,%eax
80105051:	7f e7                	jg     8010503a <strncpy+0x3a>
    *s++ = 0;
  return os;
80105053:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105056:	c9                   	leave  
80105057:	c3                   	ret    

80105058 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105058:	55                   	push   %ebp
80105059:	89 e5                	mov    %esp,%ebp
8010505b:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010505e:	8b 45 08             	mov    0x8(%ebp),%eax
80105061:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105064:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105068:	7f 05                	jg     8010506f <safestrcpy+0x17>
    return os;
8010506a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010506d:	eb 31                	jmp    801050a0 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010506f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105073:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105077:	7e 1e                	jle    80105097 <safestrcpy+0x3f>
80105079:	8b 45 08             	mov    0x8(%ebp),%eax
8010507c:	8d 50 01             	lea    0x1(%eax),%edx
8010507f:	89 55 08             	mov    %edx,0x8(%ebp)
80105082:	8b 55 0c             	mov    0xc(%ebp),%edx
80105085:	8d 4a 01             	lea    0x1(%edx),%ecx
80105088:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010508b:	0f b6 12             	movzbl (%edx),%edx
8010508e:	88 10                	mov    %dl,(%eax)
80105090:	0f b6 00             	movzbl (%eax),%eax
80105093:	84 c0                	test   %al,%al
80105095:	75 d8                	jne    8010506f <safestrcpy+0x17>
    ;
  *s = 0;
80105097:	8b 45 08             	mov    0x8(%ebp),%eax
8010509a:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010509d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050a0:	c9                   	leave  
801050a1:	c3                   	ret    

801050a2 <strlen>:

int
strlen(const char *s)
{
801050a2:	55                   	push   %ebp
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801050a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801050af:	eb 04                	jmp    801050b5 <strlen+0x13>
801050b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801050b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050b8:	8b 45 08             	mov    0x8(%ebp),%eax
801050bb:	01 d0                	add    %edx,%eax
801050bd:	0f b6 00             	movzbl (%eax),%eax
801050c0:	84 c0                	test   %al,%al
801050c2:	75 ed                	jne    801050b1 <strlen+0xf>
    ;
  return n;
801050c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050c7:	c9                   	leave  
801050c8:	c3                   	ret    

801050c9 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050c9:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050cd:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801050d1:	55                   	push   %ebp
  pushl %ebx
801050d2:	53                   	push   %ebx
  pushl %esi
801050d3:	56                   	push   %esi
  pushl %edi
801050d4:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050d5:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050d7:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801050d9:	5f                   	pop    %edi
  popl %esi
801050da:	5e                   	pop    %esi
  popl %ebx
801050db:	5b                   	pop    %ebx
  popl %ebp
801050dc:	5d                   	pop    %ebp
  ret
801050dd:	c3                   	ret    

801050de <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
801050de:	55                   	push   %ebp
801050df:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
801050e1:	8b 45 08             	mov    0x8(%ebp),%eax
801050e4:	8b 00                	mov    (%eax),%eax
801050e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801050e9:	76 0f                	jbe    801050fa <fetchint+0x1c>
801050eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ee:	8d 50 04             	lea    0x4(%eax),%edx
801050f1:	8b 45 08             	mov    0x8(%ebp),%eax
801050f4:	8b 00                	mov    (%eax),%eax
801050f6:	39 c2                	cmp    %eax,%edx
801050f8:	76 07                	jbe    80105101 <fetchint+0x23>
    return -1;
801050fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ff:	eb 0f                	jmp    80105110 <fetchint+0x32>
  *ip = *(int*)(addr);
80105101:	8b 45 0c             	mov    0xc(%ebp),%eax
80105104:	8b 10                	mov    (%eax),%edx
80105106:	8b 45 10             	mov    0x10(%ebp),%eax
80105109:	89 10                	mov    %edx,(%eax)
  return 0;
8010510b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105110:	5d                   	pop    %ebp
80105111:	c3                   	ret    

80105112 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
80105112:	55                   	push   %ebp
80105113:	89 e5                	mov    %esp,%ebp
80105115:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
80105118:	8b 45 08             	mov    0x8(%ebp),%eax
8010511b:	8b 00                	mov    (%eax),%eax
8010511d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105120:	77 07                	ja     80105129 <fetchstr+0x17>
    return -1;
80105122:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105127:	eb 43                	jmp    8010516c <fetchstr+0x5a>
  *pp = (char*)addr;
80105129:	8b 55 0c             	mov    0xc(%ebp),%edx
8010512c:	8b 45 10             	mov    0x10(%ebp),%eax
8010512f:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
80105131:	8b 45 08             	mov    0x8(%ebp),%eax
80105134:	8b 00                	mov    (%eax),%eax
80105136:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105139:	8b 45 10             	mov    0x10(%ebp),%eax
8010513c:	8b 00                	mov    (%eax),%eax
8010513e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105141:	eb 1c                	jmp    8010515f <fetchstr+0x4d>
    if(*s == 0)
80105143:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105146:	0f b6 00             	movzbl (%eax),%eax
80105149:	84 c0                	test   %al,%al
8010514b:	75 0e                	jne    8010515b <fetchstr+0x49>
      return s - *pp;
8010514d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105150:	8b 45 10             	mov    0x10(%ebp),%eax
80105153:	8b 00                	mov    (%eax),%eax
80105155:	29 c2                	sub    %eax,%edx
80105157:	89 d0                	mov    %edx,%eax
80105159:	eb 11                	jmp    8010516c <fetchstr+0x5a>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
8010515b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010515f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105162:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105165:	72 dc                	jb     80105143 <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
80105167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010516c:	c9                   	leave  
8010516d:	c3                   	ret    

8010516e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010516e:	55                   	push   %ebp
8010516f:	89 e5                	mov    %esp,%ebp
80105171:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
80105174:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010517a:	8b 40 18             	mov    0x18(%eax),%eax
8010517d:	8b 50 44             	mov    0x44(%eax),%edx
80105180:	8b 45 08             	mov    0x8(%ebp),%eax
80105183:	c1 e0 02             	shl    $0x2,%eax
80105186:	01 d0                	add    %edx,%eax
80105188:	8d 48 04             	lea    0x4(%eax),%ecx
8010518b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105191:	8b 55 0c             	mov    0xc(%ebp),%edx
80105194:	89 54 24 08          	mov    %edx,0x8(%esp)
80105198:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010519c:	89 04 24             	mov    %eax,(%esp)
8010519f:	e8 3a ff ff ff       	call   801050de <fetchint>
}
801051a4:	c9                   	leave  
801051a5:	c3                   	ret    

801051a6 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051a6:	55                   	push   %ebp
801051a7:	89 e5                	mov    %esp,%ebp
801051a9:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801051ac:	8d 45 fc             	lea    -0x4(%ebp),%eax
801051af:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b3:	8b 45 08             	mov    0x8(%ebp),%eax
801051b6:	89 04 24             	mov    %eax,(%esp)
801051b9:	e8 b0 ff ff ff       	call   8010516e <argint>
801051be:	85 c0                	test   %eax,%eax
801051c0:	79 07                	jns    801051c9 <argptr+0x23>
    return -1;
801051c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c7:	eb 3d                	jmp    80105206 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801051c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051cc:	89 c2                	mov    %eax,%edx
801051ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051d4:	8b 00                	mov    (%eax),%eax
801051d6:	39 c2                	cmp    %eax,%edx
801051d8:	73 16                	jae    801051f0 <argptr+0x4a>
801051da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051dd:	89 c2                	mov    %eax,%edx
801051df:	8b 45 10             	mov    0x10(%ebp),%eax
801051e2:	01 c2                	add    %eax,%edx
801051e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ea:	8b 00                	mov    (%eax),%eax
801051ec:	39 c2                	cmp    %eax,%edx
801051ee:	76 07                	jbe    801051f7 <argptr+0x51>
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f5:	eb 0f                	jmp    80105206 <argptr+0x60>
  *pp = (char*)i;
801051f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051fa:	89 c2                	mov    %eax,%edx
801051fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ff:	89 10                	mov    %edx,(%eax)
  return 0;
80105201:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105206:	c9                   	leave  
80105207:	c3                   	ret    

80105208 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105208:	55                   	push   %ebp
80105209:	89 e5                	mov    %esp,%ebp
8010520b:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010520e:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105211:	89 44 24 04          	mov    %eax,0x4(%esp)
80105215:	8b 45 08             	mov    0x8(%ebp),%eax
80105218:	89 04 24             	mov    %eax,(%esp)
8010521b:	e8 4e ff ff ff       	call   8010516e <argint>
80105220:	85 c0                	test   %eax,%eax
80105222:	79 07                	jns    8010522b <argstr+0x23>
    return -1;
80105224:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105229:	eb 1e                	jmp    80105249 <argstr+0x41>
  return fetchstr(proc, addr, pp);
8010522b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010522e:	89 c2                	mov    %eax,%edx
80105230:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105239:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010523d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105241:	89 04 24             	mov    %eax,(%esp)
80105244:	e8 c9 fe ff ff       	call   80105112 <fetchstr>
}
80105249:	c9                   	leave  
8010524a:	c3                   	ret    

8010524b <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
8010524b:	55                   	push   %ebp
8010524c:	89 e5                	mov    %esp,%ebp
8010524e:	53                   	push   %ebx
8010524f:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105252:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105258:	8b 40 18             	mov    0x18(%eax),%eax
8010525b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010525e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
80105261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105265:	78 2e                	js     80105295 <syscall+0x4a>
80105267:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
8010526b:	7f 28                	jg     80105295 <syscall+0x4a>
8010526d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105270:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105277:	85 c0                	test   %eax,%eax
80105279:	74 1a                	je     80105295 <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
8010527b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105281:	8b 58 18             	mov    0x18(%eax),%ebx
80105284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105287:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010528e:	ff d0                	call   *%eax
80105290:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105293:	eb 73                	jmp    80105308 <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
80105295:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105299:	7e 30                	jle    801052cb <syscall+0x80>
8010529b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010529e:	83 f8 15             	cmp    $0x15,%eax
801052a1:	77 28                	ja     801052cb <syscall+0x80>
801052a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a6:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801052ad:	85 c0                	test   %eax,%eax
801052af:	74 1a                	je     801052cb <syscall+0x80>
    proc->tf->eax = syscalls[num]();
801052b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b7:	8b 58 18             	mov    0x18(%eax),%ebx
801052ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052bd:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801052c4:	ff d0                	call   *%eax
801052c6:	89 43 1c             	mov    %eax,0x1c(%ebx)
801052c9:	eb 3d                	jmp    80105308 <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801052cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d1:	8d 48 6c             	lea    0x6c(%eax),%ecx
801052d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801052da:	8b 40 10             	mov    0x10(%eax),%eax
801052dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
801052e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801052e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ec:	c7 04 24 e2 85 10 80 	movl   $0x801085e2,(%esp)
801052f3:	e8 a8 b0 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801052f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052fe:	8b 40 18             	mov    0x18(%eax),%eax
80105301:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105308:	83 c4 24             	add    $0x24,%esp
8010530b:	5b                   	pop    %ebx
8010530c:	5d                   	pop    %ebp
8010530d:	c3                   	ret    

8010530e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010530e:	55                   	push   %ebp
8010530f:	89 e5                	mov    %esp,%ebp
80105311:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105314:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105317:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531b:	8b 45 08             	mov    0x8(%ebp),%eax
8010531e:	89 04 24             	mov    %eax,(%esp)
80105321:	e8 48 fe ff ff       	call   8010516e <argint>
80105326:	85 c0                	test   %eax,%eax
80105328:	79 07                	jns    80105331 <argfd+0x23>
    return -1;
8010532a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532f:	eb 50                	jmp    80105381 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105334:	85 c0                	test   %eax,%eax
80105336:	78 21                	js     80105359 <argfd+0x4b>
80105338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010533b:	83 f8 0f             	cmp    $0xf,%eax
8010533e:	7f 19                	jg     80105359 <argfd+0x4b>
80105340:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105346:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105349:	83 c2 08             	add    $0x8,%edx
8010534c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105350:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105357:	75 07                	jne    80105360 <argfd+0x52>
    return -1;
80105359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535e:	eb 21                	jmp    80105381 <argfd+0x73>
  if(pfd)
80105360:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105364:	74 08                	je     8010536e <argfd+0x60>
    *pfd = fd;
80105366:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105369:	8b 45 0c             	mov    0xc(%ebp),%eax
8010536c:	89 10                	mov    %edx,(%eax)
  if(pf)
8010536e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105372:	74 08                	je     8010537c <argfd+0x6e>
    *pf = f;
80105374:	8b 45 10             	mov    0x10(%ebp),%eax
80105377:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010537a:	89 10                	mov    %edx,(%eax)
  return 0;
8010537c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105381:	c9                   	leave  
80105382:	c3                   	ret    

80105383 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105383:	55                   	push   %ebp
80105384:	89 e5                	mov    %esp,%ebp
80105386:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105390:	eb 30                	jmp    801053c2 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105392:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105398:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010539b:	83 c2 08             	add    $0x8,%edx
8010539e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801053a2:	85 c0                	test   %eax,%eax
801053a4:	75 18                	jne    801053be <fdalloc+0x3b>
      proc->ofile[fd] = f;
801053a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053af:	8d 4a 08             	lea    0x8(%edx),%ecx
801053b2:	8b 55 08             	mov    0x8(%ebp),%edx
801053b5:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801053b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053bc:	eb 0f                	jmp    801053cd <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801053be:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053c2:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801053c6:	7e ca                	jle    80105392 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801053c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053cd:	c9                   	leave  
801053ce:	c3                   	ret    

801053cf <sys_dup>:

int
sys_dup(void)
{
801053cf:	55                   	push   %ebp
801053d0:	89 e5                	mov    %esp,%ebp
801053d2:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801053d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d8:	89 44 24 08          	mov    %eax,0x8(%esp)
801053dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801053e3:	00 
801053e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053eb:	e8 1e ff ff ff       	call   8010530e <argfd>
801053f0:	85 c0                	test   %eax,%eax
801053f2:	79 07                	jns    801053fb <sys_dup+0x2c>
    return -1;
801053f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f9:	eb 29                	jmp    80105424 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801053fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053fe:	89 04 24             	mov    %eax,(%esp)
80105401:	e8 7d ff ff ff       	call   80105383 <fdalloc>
80105406:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010540d:	79 07                	jns    80105416 <sys_dup+0x47>
    return -1;
8010540f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105414:	eb 0e                	jmp    80105424 <sys_dup+0x55>
  filedup(f);
80105416:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105419:	89 04 24             	mov    %eax,(%esp)
8010541c:	e8 58 bb ff ff       	call   80100f79 <filedup>
  return fd;
80105421:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105424:	c9                   	leave  
80105425:	c3                   	ret    

80105426 <sys_read>:

int
sys_read(void)
{
80105426:	55                   	push   %ebp
80105427:	89 e5                	mov    %esp,%ebp
80105429:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010542c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105433:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010543a:	00 
8010543b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105442:	e8 c7 fe ff ff       	call   8010530e <argfd>
80105447:	85 c0                	test   %eax,%eax
80105449:	78 35                	js     80105480 <sys_read+0x5a>
8010544b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010544e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105452:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105459:	e8 10 fd ff ff       	call   8010516e <argint>
8010545e:	85 c0                	test   %eax,%eax
80105460:	78 1e                	js     80105480 <sys_read+0x5a>
80105462:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105465:	89 44 24 08          	mov    %eax,0x8(%esp)
80105469:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010546c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105470:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105477:	e8 2a fd ff ff       	call   801051a6 <argptr>
8010547c:	85 c0                	test   %eax,%eax
8010547e:	79 07                	jns    80105487 <sys_read+0x61>
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105485:	eb 19                	jmp    801054a0 <sys_read+0x7a>
  return fileread(f, p, n);
80105487:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010548a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010548d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105490:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105494:	89 54 24 04          	mov    %edx,0x4(%esp)
80105498:	89 04 24             	mov    %eax,(%esp)
8010549b:	e8 46 bc ff ff       	call   801010e6 <fileread>
}
801054a0:	c9                   	leave  
801054a1:	c3                   	ret    

801054a2 <sys_write>:

int
sys_write(void)
{
801054a2:	55                   	push   %ebp
801054a3:	89 e5                	mov    %esp,%ebp
801054a5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ab:	89 44 24 08          	mov    %eax,0x8(%esp)
801054af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054b6:	00 
801054b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054be:	e8 4b fe ff ff       	call   8010530e <argfd>
801054c3:	85 c0                	test   %eax,%eax
801054c5:	78 35                	js     801054fc <sys_write+0x5a>
801054c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801054ce:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801054d5:	e8 94 fc ff ff       	call   8010516e <argint>
801054da:	85 c0                	test   %eax,%eax
801054dc:	78 1e                	js     801054fc <sys_write+0x5a>
801054de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054e1:	89 44 24 08          	mov    %eax,0x8(%esp)
801054e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801054ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054f3:	e8 ae fc ff ff       	call   801051a6 <argptr>
801054f8:	85 c0                	test   %eax,%eax
801054fa:	79 07                	jns    80105503 <sys_write+0x61>
    return -1;
801054fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105501:	eb 19                	jmp    8010551c <sys_write+0x7a>
  return filewrite(f, p, n);
80105503:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105506:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105510:	89 54 24 04          	mov    %edx,0x4(%esp)
80105514:	89 04 24             	mov    %eax,(%esp)
80105517:	e8 86 bc ff ff       	call   801011a2 <filewrite>
}
8010551c:	c9                   	leave  
8010551d:	c3                   	ret    

8010551e <sys_close>:

int
sys_close(void)
{
8010551e:	55                   	push   %ebp
8010551f:	89 e5                	mov    %esp,%ebp
80105521:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105524:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105527:	89 44 24 08          	mov    %eax,0x8(%esp)
8010552b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010552e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105532:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105539:	e8 d0 fd ff ff       	call   8010530e <argfd>
8010553e:	85 c0                	test   %eax,%eax
80105540:	79 07                	jns    80105549 <sys_close+0x2b>
    return -1;
80105542:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105547:	eb 24                	jmp    8010556d <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105549:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010554f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105552:	83 c2 08             	add    $0x8,%edx
80105555:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010555c:	00 
  fileclose(f);
8010555d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105560:	89 04 24             	mov    %eax,(%esp)
80105563:	e8 59 ba ff ff       	call   80100fc1 <fileclose>
  return 0;
80105568:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010556d:	c9                   	leave  
8010556e:	c3                   	ret    

8010556f <sys_fstat>:

int
sys_fstat(void)
{
8010556f:	55                   	push   %ebp
80105570:	89 e5                	mov    %esp,%ebp
80105572:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105575:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105578:	89 44 24 08          	mov    %eax,0x8(%esp)
8010557c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105583:	00 
80105584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010558b:	e8 7e fd ff ff       	call   8010530e <argfd>
80105590:	85 c0                	test   %eax,%eax
80105592:	78 1f                	js     801055b3 <sys_fstat+0x44>
80105594:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010559b:	00 
8010559c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010559f:	89 44 24 04          	mov    %eax,0x4(%esp)
801055a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055aa:	e8 f7 fb ff ff       	call   801051a6 <argptr>
801055af:	85 c0                	test   %eax,%eax
801055b1:	79 07                	jns    801055ba <sys_fstat+0x4b>
    return -1;
801055b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b8:	eb 12                	jmp    801055cc <sys_fstat+0x5d>
  return filestat(f, st);
801055ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c0:	89 54 24 04          	mov    %edx,0x4(%esp)
801055c4:	89 04 24             	mov    %eax,(%esp)
801055c7:	e8 cb ba ff ff       	call   80101097 <filestat>
}
801055cc:	c9                   	leave  
801055cd:	c3                   	ret    

801055ce <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801055ce:	55                   	push   %ebp
801055cf:	89 e5                	mov    %esp,%ebp
801055d1:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055d4:	8d 45 d8             	lea    -0x28(%ebp),%eax
801055d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801055db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055e2:	e8 21 fc ff ff       	call   80105208 <argstr>
801055e7:	85 c0                	test   %eax,%eax
801055e9:	78 17                	js     80105602 <sys_link+0x34>
801055eb:	8d 45 dc             	lea    -0x24(%ebp),%eax
801055ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801055f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055f9:	e8 0a fc ff ff       	call   80105208 <argstr>
801055fe:	85 c0                	test   %eax,%eax
80105600:	79 0a                	jns    8010560c <sys_link+0x3e>
    return -1;
80105602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105607:	e9 3d 01 00 00       	jmp    80105749 <sys_link+0x17b>
  if((ip = namei(old)) == 0)
8010560c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010560f:	89 04 24             	mov    %eax,(%esp)
80105612:	e8 e2 cd ff ff       	call   801023f9 <namei>
80105617:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010561a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010561e:	75 0a                	jne    8010562a <sys_link+0x5c>
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105625:	e9 1f 01 00 00       	jmp    80105749 <sys_link+0x17b>

  begin_trans();
8010562a:	e8 a9 db ff ff       	call   801031d8 <begin_trans>

  ilock(ip);
8010562f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105632:	89 04 24             	mov    %eax,(%esp)
80105635:	e8 14 c2 ff ff       	call   8010184e <ilock>
  if(ip->type == T_DIR){
8010563a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010563d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105641:	66 83 f8 01          	cmp    $0x1,%ax
80105645:	75 1a                	jne    80105661 <sys_link+0x93>
    iunlockput(ip);
80105647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010564a:	89 04 24             	mov    %eax,(%esp)
8010564d:	e8 80 c4 ff ff       	call   80101ad2 <iunlockput>
    commit_trans();
80105652:	e8 ca db ff ff       	call   80103221 <commit_trans>
    return -1;
80105657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565c:	e9 e8 00 00 00       	jmp    80105749 <sys_link+0x17b>
  }

  ip->nlink++;
80105661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105664:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105668:	8d 50 01             	lea    0x1(%eax),%edx
8010566b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105675:	89 04 24             	mov    %eax,(%esp)
80105678:	e8 15 c0 ff ff       	call   80101692 <iupdate>
  iunlock(ip);
8010567d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105680:	89 04 24             	mov    %eax,(%esp)
80105683:	e8 14 c3 ff ff       	call   8010199c <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105688:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010568b:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010568e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105692:	89 04 24             	mov    %eax,(%esp)
80105695:	e8 81 cd ff ff       	call   8010241b <nameiparent>
8010569a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010569d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056a1:	75 02                	jne    801056a5 <sys_link+0xd7>
    goto bad;
801056a3:	eb 68                	jmp    8010570d <sys_link+0x13f>
  ilock(dp);
801056a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a8:	89 04 24             	mov    %eax,(%esp)
801056ab:	e8 9e c1 ff ff       	call   8010184e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b3:	8b 10                	mov    (%eax),%edx
801056b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b8:	8b 00                	mov    (%eax),%eax
801056ba:	39 c2                	cmp    %eax,%edx
801056bc:	75 20                	jne    801056de <sys_link+0x110>
801056be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c1:	8b 40 04             	mov    0x4(%eax),%eax
801056c4:	89 44 24 08          	mov    %eax,0x8(%esp)
801056c8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801056cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801056cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d2:	89 04 24             	mov    %eax,(%esp)
801056d5:	e8 5f ca ff ff       	call   80102139 <dirlink>
801056da:	85 c0                	test   %eax,%eax
801056dc:	79 0d                	jns    801056eb <sys_link+0x11d>
    iunlockput(dp);
801056de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056e1:	89 04 24             	mov    %eax,(%esp)
801056e4:	e8 e9 c3 ff ff       	call   80101ad2 <iunlockput>
    goto bad;
801056e9:	eb 22                	jmp    8010570d <sys_link+0x13f>
  }
  iunlockput(dp);
801056eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056ee:	89 04 24             	mov    %eax,(%esp)
801056f1:	e8 dc c3 ff ff       	call   80101ad2 <iunlockput>
  iput(ip);
801056f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f9:	89 04 24             	mov    %eax,(%esp)
801056fc:	e8 00 c3 ff ff       	call   80101a01 <iput>

  commit_trans();
80105701:	e8 1b db ff ff       	call   80103221 <commit_trans>

  return 0;
80105706:	b8 00 00 00 00       	mov    $0x0,%eax
8010570b:	eb 3c                	jmp    80105749 <sys_link+0x17b>

bad:
  ilock(ip);
8010570d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105710:	89 04 24             	mov    %eax,(%esp)
80105713:	e8 36 c1 ff ff       	call   8010184e <ilock>
  ip->nlink--;
80105718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010571f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105725:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572c:	89 04 24             	mov    %eax,(%esp)
8010572f:	e8 5e bf ff ff       	call   80101692 <iupdate>
  iunlockput(ip);
80105734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105737:	89 04 24             	mov    %eax,(%esp)
8010573a:	e8 93 c3 ff ff       	call   80101ad2 <iunlockput>
  commit_trans();
8010573f:	e8 dd da ff ff       	call   80103221 <commit_trans>
  return -1;
80105744:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105749:	c9                   	leave  
8010574a:	c3                   	ret    

8010574b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010574b:	55                   	push   %ebp
8010574c:	89 e5                	mov    %esp,%ebp
8010574e:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105751:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105758:	eb 4b                	jmp    801057a5 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010575a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105764:	00 
80105765:	89 44 24 08          	mov    %eax,0x8(%esp)
80105769:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010576c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105770:	8b 45 08             	mov    0x8(%ebp),%eax
80105773:	89 04 24             	mov    %eax,(%esp)
80105776:	e8 e0 c5 ff ff       	call   80101d5b <readi>
8010577b:	83 f8 10             	cmp    $0x10,%eax
8010577e:	74 0c                	je     8010578c <isdirempty+0x41>
      panic("isdirempty: readi");
80105780:	c7 04 24 fe 85 10 80 	movl   $0x801085fe,(%esp)
80105787:	e8 ae ad ff ff       	call   8010053a <panic>
    if(de.inum != 0)
8010578c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105790:	66 85 c0             	test   %ax,%ax
80105793:	74 07                	je     8010579c <isdirempty+0x51>
      return 0;
80105795:	b8 00 00 00 00       	mov    $0x0,%eax
8010579a:	eb 1b                	jmp    801057b7 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010579c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579f:	83 c0 10             	add    $0x10,%eax
801057a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057a8:	8b 45 08             	mov    0x8(%ebp),%eax
801057ab:	8b 40 18             	mov    0x18(%eax),%eax
801057ae:	39 c2                	cmp    %eax,%edx
801057b0:	72 a8                	jb     8010575a <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801057b2:	b8 01 00 00 00       	mov    $0x1,%eax
}
801057b7:	c9                   	leave  
801057b8:	c3                   	ret    

801057b9 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801057b9:	55                   	push   %ebp
801057ba:	89 e5                	mov    %esp,%ebp
801057bc:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801057bf:	8d 45 cc             	lea    -0x34(%ebp),%eax
801057c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801057c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057cd:	e8 36 fa ff ff       	call   80105208 <argstr>
801057d2:	85 c0                	test   %eax,%eax
801057d4:	79 0a                	jns    801057e0 <sys_unlink+0x27>
    return -1;
801057d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057db:	e9 aa 01 00 00       	jmp    8010598a <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
801057e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
801057e3:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801057e6:	89 54 24 04          	mov    %edx,0x4(%esp)
801057ea:	89 04 24             	mov    %eax,(%esp)
801057ed:	e8 29 cc ff ff       	call   8010241b <nameiparent>
801057f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057f9:	75 0a                	jne    80105805 <sys_unlink+0x4c>
    return -1;
801057fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105800:	e9 85 01 00 00       	jmp    8010598a <sys_unlink+0x1d1>

  begin_trans();
80105805:	e8 ce d9 ff ff       	call   801031d8 <begin_trans>

  ilock(dp);
8010580a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580d:	89 04 24             	mov    %eax,(%esp)
80105810:	e8 39 c0 ff ff       	call   8010184e <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105815:	c7 44 24 04 10 86 10 	movl   $0x80108610,0x4(%esp)
8010581c:	80 
8010581d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105820:	89 04 24             	mov    %eax,(%esp)
80105823:	e8 26 c8 ff ff       	call   8010204e <namecmp>
80105828:	85 c0                	test   %eax,%eax
8010582a:	0f 84 45 01 00 00    	je     80105975 <sys_unlink+0x1bc>
80105830:	c7 44 24 04 12 86 10 	movl   $0x80108612,0x4(%esp)
80105837:	80 
80105838:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010583b:	89 04 24             	mov    %eax,(%esp)
8010583e:	e8 0b c8 ff ff       	call   8010204e <namecmp>
80105843:	85 c0                	test   %eax,%eax
80105845:	0f 84 2a 01 00 00    	je     80105975 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010584b:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010584e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105852:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105855:	89 44 24 04          	mov    %eax,0x4(%esp)
80105859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585c:	89 04 24             	mov    %eax,(%esp)
8010585f:	e8 0c c8 ff ff       	call   80102070 <dirlookup>
80105864:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105867:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010586b:	75 05                	jne    80105872 <sys_unlink+0xb9>
    goto bad;
8010586d:	e9 03 01 00 00       	jmp    80105975 <sys_unlink+0x1bc>
  ilock(ip);
80105872:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105875:	89 04 24             	mov    %eax,(%esp)
80105878:	e8 d1 bf ff ff       	call   8010184e <ilock>

  if(ip->nlink < 1)
8010587d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105880:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105884:	66 85 c0             	test   %ax,%ax
80105887:	7f 0c                	jg     80105895 <sys_unlink+0xdc>
    panic("unlink: nlink < 1");
80105889:	c7 04 24 15 86 10 80 	movl   $0x80108615,(%esp)
80105890:	e8 a5 ac ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105898:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010589c:	66 83 f8 01          	cmp    $0x1,%ax
801058a0:	75 1f                	jne    801058c1 <sys_unlink+0x108>
801058a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a5:	89 04 24             	mov    %eax,(%esp)
801058a8:	e8 9e fe ff ff       	call   8010574b <isdirempty>
801058ad:	85 c0                	test   %eax,%eax
801058af:	75 10                	jne    801058c1 <sys_unlink+0x108>
    iunlockput(ip);
801058b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b4:	89 04 24             	mov    %eax,(%esp)
801058b7:	e8 16 c2 ff ff       	call   80101ad2 <iunlockput>
    goto bad;
801058bc:	e9 b4 00 00 00       	jmp    80105975 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
801058c1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801058c8:	00 
801058c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058d0:	00 
801058d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058d4:	89 04 24             	mov    %eax,(%esp)
801058d7:	e8 5c f5 ff ff       	call   80104e38 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
801058df:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801058e6:	00 
801058e7:	89 44 24 08          	mov    %eax,0x8(%esp)
801058eb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801058f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f5:	89 04 24             	mov    %eax,(%esp)
801058f8:	e8 c2 c5 ff ff       	call   80101ebf <writei>
801058fd:	83 f8 10             	cmp    $0x10,%eax
80105900:	74 0c                	je     8010590e <sys_unlink+0x155>
    panic("unlink: writei");
80105902:	c7 04 24 27 86 10 80 	movl   $0x80108627,(%esp)
80105909:	e8 2c ac ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
8010590e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105911:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105915:	66 83 f8 01          	cmp    $0x1,%ax
80105919:	75 1c                	jne    80105937 <sys_unlink+0x17e>
    dp->nlink--;
8010591b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105922:	8d 50 ff             	lea    -0x1(%eax),%edx
80105925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105928:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010592c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010592f:	89 04 24             	mov    %eax,(%esp)
80105932:	e8 5b bd ff ff       	call   80101692 <iupdate>
  }
  iunlockput(dp);
80105937:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593a:	89 04 24             	mov    %eax,(%esp)
8010593d:	e8 90 c1 ff ff       	call   80101ad2 <iunlockput>

  ip->nlink--;
80105942:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105945:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105949:	8d 50 ff             	lea    -0x1(%eax),%edx
8010594c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010594f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105953:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105956:	89 04 24             	mov    %eax,(%esp)
80105959:	e8 34 bd ff ff       	call   80101692 <iupdate>
  iunlockput(ip);
8010595e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105961:	89 04 24             	mov    %eax,(%esp)
80105964:	e8 69 c1 ff ff       	call   80101ad2 <iunlockput>

  commit_trans();
80105969:	e8 b3 d8 ff ff       	call   80103221 <commit_trans>

  return 0;
8010596e:	b8 00 00 00 00       	mov    $0x0,%eax
80105973:	eb 15                	jmp    8010598a <sys_unlink+0x1d1>

bad:
  iunlockput(dp);
80105975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105978:	89 04 24             	mov    %eax,(%esp)
8010597b:	e8 52 c1 ff ff       	call   80101ad2 <iunlockput>
  commit_trans();
80105980:	e8 9c d8 ff ff       	call   80103221 <commit_trans>
  return -1;
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010598a:	c9                   	leave  
8010598b:	c3                   	ret    

8010598c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010598c:	55                   	push   %ebp
8010598d:	89 e5                	mov    %esp,%ebp
8010598f:	83 ec 48             	sub    $0x48,%esp
80105992:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105995:	8b 55 10             	mov    0x10(%ebp),%edx
80105998:	8b 45 14             	mov    0x14(%ebp),%eax
8010599b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010599f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801059a3:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801059a7:	8d 45 de             	lea    -0x22(%ebp),%eax
801059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801059ae:	8b 45 08             	mov    0x8(%ebp),%eax
801059b1:	89 04 24             	mov    %eax,(%esp)
801059b4:	e8 62 ca ff ff       	call   8010241b <nameiparent>
801059b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059c0:	75 0a                	jne    801059cc <create+0x40>
    return 0;
801059c2:	b8 00 00 00 00       	mov    $0x0,%eax
801059c7:	e9 7e 01 00 00       	jmp    80105b4a <create+0x1be>
  ilock(dp);
801059cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059cf:	89 04 24             	mov    %eax,(%esp)
801059d2:	e8 77 be ff ff       	call   8010184e <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801059d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059da:	89 44 24 08          	mov    %eax,0x8(%esp)
801059de:	8d 45 de             	lea    -0x22(%ebp),%eax
801059e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801059e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e8:	89 04 24             	mov    %eax,(%esp)
801059eb:	e8 80 c6 ff ff       	call   80102070 <dirlookup>
801059f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059f7:	74 47                	je     80105a40 <create+0xb4>
    iunlockput(dp);
801059f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059fc:	89 04 24             	mov    %eax,(%esp)
801059ff:	e8 ce c0 ff ff       	call   80101ad2 <iunlockput>
    ilock(ip);
80105a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a07:	89 04 24             	mov    %eax,(%esp)
80105a0a:	e8 3f be ff ff       	call   8010184e <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a0f:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a14:	75 15                	jne    80105a2b <create+0x9f>
80105a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a19:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a1d:	66 83 f8 02          	cmp    $0x2,%ax
80105a21:	75 08                	jne    80105a2b <create+0x9f>
      return ip;
80105a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a26:	e9 1f 01 00 00       	jmp    80105b4a <create+0x1be>
    iunlockput(ip);
80105a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a2e:	89 04 24             	mov    %eax,(%esp)
80105a31:	e8 9c c0 ff ff       	call   80101ad2 <iunlockput>
    return 0;
80105a36:	b8 00 00 00 00       	mov    $0x0,%eax
80105a3b:	e9 0a 01 00 00       	jmp    80105b4a <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105a40:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a47:	8b 00                	mov    (%eax),%eax
80105a49:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a4d:	89 04 24             	mov    %eax,(%esp)
80105a50:	e8 5e bb ff ff       	call   801015b3 <ialloc>
80105a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a5c:	75 0c                	jne    80105a6a <create+0xde>
    panic("create: ialloc");
80105a5e:	c7 04 24 36 86 10 80 	movl   $0x80108636,(%esp)
80105a65:	e8 d0 aa ff ff       	call   8010053a <panic>

  ilock(ip);
80105a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6d:	89 04 24             	mov    %eax,(%esp)
80105a70:	e8 d9 bd ff ff       	call   8010184e <ilock>
  ip->major = major;
80105a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a78:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105a7c:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a83:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105a87:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8e:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a97:	89 04 24             	mov    %eax,(%esp)
80105a9a:	e8 f3 bb ff ff       	call   80101692 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105a9f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105aa4:	75 6a                	jne    80105b10 <create+0x184>
    dp->nlink++;  // for ".."
80105aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105aad:	8d 50 01             	lea    0x1(%eax),%edx
80105ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab3:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aba:	89 04 24             	mov    %eax,(%esp)
80105abd:	e8 d0 bb ff ff       	call   80101692 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac5:	8b 40 04             	mov    0x4(%eax),%eax
80105ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105acc:	c7 44 24 04 10 86 10 	movl   $0x80108610,0x4(%esp)
80105ad3:	80 
80105ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ad7:	89 04 24             	mov    %eax,(%esp)
80105ada:	e8 5a c6 ff ff       	call   80102139 <dirlink>
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	78 21                	js     80105b04 <create+0x178>
80105ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae6:	8b 40 04             	mov    0x4(%eax),%eax
80105ae9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aed:	c7 44 24 04 12 86 10 	movl   $0x80108612,0x4(%esp)
80105af4:	80 
80105af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af8:	89 04 24             	mov    %eax,(%esp)
80105afb:	e8 39 c6 ff ff       	call   80102139 <dirlink>
80105b00:	85 c0                	test   %eax,%eax
80105b02:	79 0c                	jns    80105b10 <create+0x184>
      panic("create dots");
80105b04:	c7 04 24 45 86 10 80 	movl   $0x80108645,(%esp)
80105b0b:	e8 2a aa ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b13:	8b 40 04             	mov    0x4(%eax),%eax
80105b16:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b1a:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b24:	89 04 24             	mov    %eax,(%esp)
80105b27:	e8 0d c6 ff ff       	call   80102139 <dirlink>
80105b2c:	85 c0                	test   %eax,%eax
80105b2e:	79 0c                	jns    80105b3c <create+0x1b0>
    panic("create: dirlink");
80105b30:	c7 04 24 51 86 10 80 	movl   $0x80108651,(%esp)
80105b37:	e8 fe a9 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3f:	89 04 24             	mov    %eax,(%esp)
80105b42:	e8 8b bf ff ff       	call   80101ad2 <iunlockput>

  return ip;
80105b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105b4a:	c9                   	leave  
80105b4b:	c3                   	ret    

80105b4c <sys_open>:

int
sys_open(void)
{
80105b4c:	55                   	push   %ebp
80105b4d:	89 e5                	mov    %esp,%ebp
80105b4f:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b52:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105b55:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b60:	e8 a3 f6 ff ff       	call   80105208 <argstr>
80105b65:	85 c0                	test   %eax,%eax
80105b67:	78 17                	js     80105b80 <sys_open+0x34>
80105b69:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b77:	e8 f2 f5 ff ff       	call   8010516e <argint>
80105b7c:	85 c0                	test   %eax,%eax
80105b7e:	79 0a                	jns    80105b8a <sys_open+0x3e>
    return -1;
80105b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b85:	e9 48 01 00 00       	jmp    80105cd2 <sys_open+0x186>
  if(omode & O_CREATE){
80105b8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b8d:	25 00 02 00 00       	and    $0x200,%eax
80105b92:	85 c0                	test   %eax,%eax
80105b94:	74 40                	je     80105bd6 <sys_open+0x8a>
    begin_trans();
80105b96:	e8 3d d6 ff ff       	call   801031d8 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105b9e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105ba5:	00 
80105ba6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105bad:	00 
80105bae:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105bb5:	00 
80105bb6:	89 04 24             	mov    %eax,(%esp)
80105bb9:	e8 ce fd ff ff       	call   8010598c <create>
80105bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105bc1:	e8 5b d6 ff ff       	call   80103221 <commit_trans>
    if(ip == 0)
80105bc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bca:	75 5c                	jne    80105c28 <sys_open+0xdc>
      return -1;
80105bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd1:	e9 fc 00 00 00       	jmp    80105cd2 <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
80105bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105bd9:	89 04 24             	mov    %eax,(%esp)
80105bdc:	e8 18 c8 ff ff       	call   801023f9 <namei>
80105be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105be8:	75 0a                	jne    80105bf4 <sys_open+0xa8>
      return -1;
80105bea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bef:	e9 de 00 00 00       	jmp    80105cd2 <sys_open+0x186>
    ilock(ip);
80105bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf7:	89 04 24             	mov    %eax,(%esp)
80105bfa:	e8 4f bc ff ff       	call   8010184e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c02:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c06:	66 83 f8 01          	cmp    $0x1,%ax
80105c0a:	75 1c                	jne    80105c28 <sys_open+0xdc>
80105c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c0f:	85 c0                	test   %eax,%eax
80105c11:	74 15                	je     80105c28 <sys_open+0xdc>
      iunlockput(ip);
80105c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c16:	89 04 24             	mov    %eax,(%esp)
80105c19:	e8 b4 be ff ff       	call   80101ad2 <iunlockput>
      return -1;
80105c1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c23:	e9 aa 00 00 00       	jmp    80105cd2 <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c28:	e8 ec b2 ff ff       	call   80100f19 <filealloc>
80105c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c34:	74 14                	je     80105c4a <sys_open+0xfe>
80105c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c39:	89 04 24             	mov    %eax,(%esp)
80105c3c:	e8 42 f7 ff ff       	call   80105383 <fdalloc>
80105c41:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105c44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105c48:	79 23                	jns    80105c6d <sys_open+0x121>
    if(f)
80105c4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c4e:	74 0b                	je     80105c5b <sys_open+0x10f>
      fileclose(f);
80105c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c53:	89 04 24             	mov    %eax,(%esp)
80105c56:	e8 66 b3 ff ff       	call   80100fc1 <fileclose>
    iunlockput(ip);
80105c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c5e:	89 04 24             	mov    %eax,(%esp)
80105c61:	e8 6c be ff ff       	call   80101ad2 <iunlockput>
    return -1;
80105c66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c6b:	eb 65                	jmp    80105cd2 <sys_open+0x186>
  }
  iunlock(ip);
80105c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c70:	89 04 24             	mov    %eax,(%esp)
80105c73:	e8 24 bd ff ff       	call   8010199c <iunlock>

  f->type = FD_INODE;
80105c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c7b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c87:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c97:	83 e0 01             	and    $0x1,%eax
80105c9a:	85 c0                	test   %eax,%eax
80105c9c:	0f 94 c0             	sete   %al
80105c9f:	89 c2                	mov    %eax,%edx
80105ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca4:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ca7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105caa:	83 e0 01             	and    $0x1,%eax
80105cad:	85 c0                	test   %eax,%eax
80105caf:	75 0a                	jne    80105cbb <sys_open+0x16f>
80105cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cb4:	83 e0 02             	and    $0x2,%eax
80105cb7:	85 c0                	test   %eax,%eax
80105cb9:	74 07                	je     80105cc2 <sys_open+0x176>
80105cbb:	b8 01 00 00 00       	mov    $0x1,%eax
80105cc0:	eb 05                	jmp    80105cc7 <sys_open+0x17b>
80105cc2:	b8 00 00 00 00       	mov    $0x0,%eax
80105cc7:	89 c2                	mov    %eax,%edx
80105cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccc:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    

80105cd4 <sys_mkdir>:

int
sys_mkdir(void)
{
80105cd4:	55                   	push   %ebp
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105cda:	e8 f9 d4 ff ff       	call   801031d8 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105cdf:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ce6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ced:	e8 16 f5 ff ff       	call   80105208 <argstr>
80105cf2:	85 c0                	test   %eax,%eax
80105cf4:	78 2c                	js     80105d22 <sys_mkdir+0x4e>
80105cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105d00:	00 
80105d01:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105d08:	00 
80105d09:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105d10:	00 
80105d11:	89 04 24             	mov    %eax,(%esp)
80105d14:	e8 73 fc ff ff       	call   8010598c <create>
80105d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d20:	75 0c                	jne    80105d2e <sys_mkdir+0x5a>
    commit_trans();
80105d22:	e8 fa d4 ff ff       	call   80103221 <commit_trans>
    return -1;
80105d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2c:	eb 15                	jmp    80105d43 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d31:	89 04 24             	mov    %eax,(%esp)
80105d34:	e8 99 bd ff ff       	call   80101ad2 <iunlockput>
  commit_trans();
80105d39:	e8 e3 d4 ff ff       	call   80103221 <commit_trans>
  return 0;
80105d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d43:	c9                   	leave  
80105d44:	c3                   	ret    

80105d45 <sys_mknod>:

int
sys_mknod(void)
{
80105d45:	55                   	push   %ebp
80105d46:	89 e5                	mov    %esp,%ebp
80105d48:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105d4b:	e8 88 d4 ff ff       	call   801031d8 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105d50:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d53:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d5e:	e8 a5 f4 ff ff       	call   80105208 <argstr>
80105d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d6a:	78 5e                	js     80105dca <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105d6c:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d7a:	e8 ef f3 ff ff       	call   8010516e <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105d7f:	85 c0                	test   %eax,%eax
80105d81:	78 47                	js     80105dca <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105d83:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d86:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d8a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105d91:	e8 d8 f3 ff ff       	call   8010516e <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105d96:	85 c0                	test   %eax,%eax
80105d98:	78 30                	js     80105dca <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d9d:	0f bf c8             	movswl %ax,%ecx
80105da0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105da3:	0f bf d0             	movswl %ax,%edx
80105da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105da9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105dad:	89 54 24 08          	mov    %edx,0x8(%esp)
80105db1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105db8:	00 
80105db9:	89 04 24             	mov    %eax,(%esp)
80105dbc:	e8 cb fb ff ff       	call   8010598c <create>
80105dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dc8:	75 0c                	jne    80105dd6 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105dca:	e8 52 d4 ff ff       	call   80103221 <commit_trans>
    return -1;
80105dcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd4:	eb 15                	jmp    80105deb <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd9:	89 04 24             	mov    %eax,(%esp)
80105ddc:	e8 f1 bc ff ff       	call   80101ad2 <iunlockput>
  commit_trans();
80105de1:	e8 3b d4 ff ff       	call   80103221 <commit_trans>
  return 0;
80105de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105deb:	c9                   	leave  
80105dec:	c3                   	ret    

80105ded <sys_chdir>:

int
sys_chdir(void)
{
80105ded:	55                   	push   %ebp
80105dee:	89 e5                	mov    %esp,%ebp
80105df0:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105df3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e01:	e8 02 f4 ff ff       	call   80105208 <argstr>
80105e06:	85 c0                	test   %eax,%eax
80105e08:	78 14                	js     80105e1e <sys_chdir+0x31>
80105e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0d:	89 04 24             	mov    %eax,(%esp)
80105e10:	e8 e4 c5 ff ff       	call   801023f9 <namei>
80105e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e1c:	75 07                	jne    80105e25 <sys_chdir+0x38>
    return -1;
80105e1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e23:	eb 57                	jmp    80105e7c <sys_chdir+0x8f>
  ilock(ip);
80105e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e28:	89 04 24             	mov    %eax,(%esp)
80105e2b:	e8 1e ba ff ff       	call   8010184e <ilock>
  if(ip->type != T_DIR){
80105e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e33:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e37:	66 83 f8 01          	cmp    $0x1,%ax
80105e3b:	74 12                	je     80105e4f <sys_chdir+0x62>
    iunlockput(ip);
80105e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e40:	89 04 24             	mov    %eax,(%esp)
80105e43:	e8 8a bc ff ff       	call   80101ad2 <iunlockput>
    return -1;
80105e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4d:	eb 2d                	jmp    80105e7c <sys_chdir+0x8f>
  }
  iunlock(ip);
80105e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e52:	89 04 24             	mov    %eax,(%esp)
80105e55:	e8 42 bb ff ff       	call   8010199c <iunlock>
  iput(proc->cwd);
80105e5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e60:	8b 40 68             	mov    0x68(%eax),%eax
80105e63:	89 04 24             	mov    %eax,(%esp)
80105e66:	e8 96 bb ff ff       	call   80101a01 <iput>
  proc->cwd = ip;
80105e6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e74:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e7c:	c9                   	leave  
80105e7d:	c3                   	ret    

80105e7e <sys_exec>:

int
sys_exec(void)
{
80105e7e:	55                   	push   %ebp
80105e7f:	89 e5                	mov    %esp,%ebp
80105e81:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e87:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e95:	e8 6e f3 ff ff       	call   80105208 <argstr>
80105e9a:	85 c0                	test   %eax,%eax
80105e9c:	78 1a                	js     80105eb8 <sys_exec+0x3a>
80105e9e:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ea8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105eaf:	e8 ba f2 ff ff       	call   8010516e <argint>
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	79 0a                	jns    80105ec2 <sys_exec+0x44>
    return -1;
80105eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebd:	e9 de 00 00 00       	jmp    80105fa0 <sys_exec+0x122>
  }
  memset(argv, 0, sizeof(argv));
80105ec2:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105ec9:	00 
80105eca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ed1:	00 
80105ed2:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105ed8:	89 04 24             	mov    %eax,(%esp)
80105edb:	e8 58 ef ff ff       	call   80104e38 <memset>
  for(i=0;; i++){
80105ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eea:	83 f8 1f             	cmp    $0x1f,%eax
80105eed:	76 0a                	jbe    80105ef9 <sys_exec+0x7b>
      return -1;
80105eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef4:	e9 a7 00 00 00       	jmp    80105fa0 <sys_exec+0x122>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
80105ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efc:	c1 e0 02             	shl    $0x2,%eax
80105eff:	89 c2                	mov    %eax,%edx
80105f01:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105f07:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80105f0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f10:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
80105f16:	89 54 24 08          	mov    %edx,0x8(%esp)
80105f1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105f1e:	89 04 24             	mov    %eax,(%esp)
80105f21:	e8 b8 f1 ff ff       	call   801050de <fetchint>
80105f26:	85 c0                	test   %eax,%eax
80105f28:	79 07                	jns    80105f31 <sys_exec+0xb3>
      return -1;
80105f2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f2f:	eb 6f                	jmp    80105fa0 <sys_exec+0x122>
    if(uarg == 0){
80105f31:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105f37:	85 c0                	test   %eax,%eax
80105f39:	75 26                	jne    80105f61 <sys_exec+0xe3>
      argv[i] = 0;
80105f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3e:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105f45:	00 00 00 00 
      break;
80105f49:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4d:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105f53:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f57:	89 04 24             	mov    %eax,(%esp)
80105f5a:	e8 90 ab ff ff       	call   80100aef <exec>
80105f5f:	eb 3f                	jmp    80105fa0 <sys_exec+0x122>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
80105f61:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f6a:	c1 e2 02             	shl    $0x2,%edx
80105f6d:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80105f70:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80105f76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f7c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105f80:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f84:	89 04 24             	mov    %eax,(%esp)
80105f87:	e8 86 f1 ff ff       	call   80105112 <fetchstr>
80105f8c:	85 c0                	test   %eax,%eax
80105f8e:	79 07                	jns    80105f97 <sys_exec+0x119>
      return -1;
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f95:	eb 09                	jmp    80105fa0 <sys_exec+0x122>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105f97:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
80105f9b:	e9 47 ff ff ff       	jmp    80105ee7 <sys_exec+0x69>
  return exec(path, argv);
}
80105fa0:	c9                   	leave  
80105fa1:	c3                   	ret    

80105fa2 <sys_pipe>:

int
sys_pipe(void)
{
80105fa2:	55                   	push   %ebp
80105fa3:	89 e5                	mov    %esp,%ebp
80105fa5:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fa8:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105faf:	00 
80105fb0:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fbe:	e8 e3 f1 ff ff       	call   801051a6 <argptr>
80105fc3:	85 c0                	test   %eax,%eax
80105fc5:	79 0a                	jns    80105fd1 <sys_pipe+0x2f>
    return -1;
80105fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fcc:	e9 9b 00 00 00       	jmp    8010606c <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80105fd1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fd8:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fdb:	89 04 24             	mov    %eax,(%esp)
80105fde:	e8 ef db ff ff       	call   80103bd2 <pipealloc>
80105fe3:	85 c0                	test   %eax,%eax
80105fe5:	79 07                	jns    80105fee <sys_pipe+0x4c>
    return -1;
80105fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fec:	eb 7e                	jmp    8010606c <sys_pipe+0xca>
  fd0 = -1;
80105fee:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ff8:	89 04 24             	mov    %eax,(%esp)
80105ffb:	e8 83 f3 ff ff       	call   80105383 <fdalloc>
80106000:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106007:	78 14                	js     8010601d <sys_pipe+0x7b>
80106009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010600c:	89 04 24             	mov    %eax,(%esp)
8010600f:	e8 6f f3 ff ff       	call   80105383 <fdalloc>
80106014:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106017:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010601b:	79 37                	jns    80106054 <sys_pipe+0xb2>
    if(fd0 >= 0)
8010601d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106021:	78 14                	js     80106037 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106023:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106029:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010602c:	83 c2 08             	add    $0x8,%edx
8010602f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106036:	00 
    fileclose(rf);
80106037:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010603a:	89 04 24             	mov    %eax,(%esp)
8010603d:	e8 7f af ff ff       	call   80100fc1 <fileclose>
    fileclose(wf);
80106042:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106045:	89 04 24             	mov    %eax,(%esp)
80106048:	e8 74 af ff ff       	call   80100fc1 <fileclose>
    return -1;
8010604d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106052:	eb 18                	jmp    8010606c <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106054:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106057:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010605a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010605c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010605f:	8d 50 04             	lea    0x4(%eax),%edx
80106062:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106065:	89 02                	mov    %eax,(%edx)
  return 0;
80106067:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010606c:	c9                   	leave  
8010606d:	c3                   	ret    

8010606e <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010606e:	55                   	push   %ebp
8010606f:	89 e5                	mov    %esp,%ebp
80106071:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106074:	e8 25 e2 ff ff       	call   8010429e <fork>
}
80106079:	c9                   	leave  
8010607a:	c3                   	ret    

8010607b <sys_exit>:

int
sys_exit(void)
{
8010607b:	55                   	push   %ebp
8010607c:	89 e5                	mov    %esp,%ebp
8010607e:	83 ec 08             	sub    $0x8,%esp
  exit();
80106081:	e8 7b e3 ff ff       	call   80104401 <exit>
  return 0;  // not reached
80106086:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010608b:	c9                   	leave  
8010608c:	c3                   	ret    

8010608d <sys_wait>:

int
sys_wait(void)
{
8010608d:	55                   	push   %ebp
8010608e:	89 e5                	mov    %esp,%ebp
80106090:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106093:	e8 84 e4 ff ff       	call   8010451c <wait>
}
80106098:	c9                   	leave  
80106099:	c3                   	ret    

8010609a <sys_kill>:

int
sys_kill(void)
{
8010609a:	55                   	push   %ebp
8010609b:	89 e5                	mov    %esp,%ebp
8010609d:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801060a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060ae:	e8 bb f0 ff ff       	call   8010516e <argint>
801060b3:	85 c0                	test   %eax,%eax
801060b5:	79 07                	jns    801060be <sys_kill+0x24>
    return -1;
801060b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060bc:	eb 0b                	jmp    801060c9 <sys_kill+0x2f>
  return kill(pid);
801060be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c1:	89 04 24             	mov    %eax,(%esp)
801060c4:	e8 4f e9 ff ff       	call   80104a18 <kill>
}
801060c9:	c9                   	leave  
801060ca:	c3                   	ret    

801060cb <sys_getpid>:

int
sys_getpid(void)
{
801060cb:	55                   	push   %ebp
801060cc:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801060ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060d4:	8b 40 10             	mov    0x10(%eax),%eax
}
801060d7:	5d                   	pop    %ebp
801060d8:	c3                   	ret    

801060d9 <sys_sbrk>:

int
sys_sbrk(void)
{
801060d9:	55                   	push   %ebp
801060da:	89 e5                	mov    %esp,%ebp
801060dc:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801060df:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801060e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060ed:	e8 7c f0 ff ff       	call   8010516e <argint>
801060f2:	85 c0                	test   %eax,%eax
801060f4:	79 07                	jns    801060fd <sys_sbrk+0x24>
    return -1;
801060f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fb:	eb 24                	jmp    80106121 <sys_sbrk+0x48>
  addr = proc->sz;
801060fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106103:	8b 00                	mov    (%eax),%eax
80106105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610b:	89 04 24             	mov    %eax,(%esp)
8010610e:	e8 e6 e0 ff ff       	call   801041f9 <growproc>
80106113:	85 c0                	test   %eax,%eax
80106115:	79 07                	jns    8010611e <sys_sbrk+0x45>
    return -1;
80106117:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010611c:	eb 03                	jmp    80106121 <sys_sbrk+0x48>
  return addr;
8010611e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106121:	c9                   	leave  
80106122:	c3                   	ret    

80106123 <sys_sleep>:

int
sys_sleep(void)
{
80106123:	55                   	push   %ebp
80106124:	89 e5                	mov    %esp,%ebp
80106126:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106129:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010612c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106137:	e8 32 f0 ff ff       	call   8010516e <argint>
8010613c:	85 c0                	test   %eax,%eax
8010613e:	79 07                	jns    80106147 <sys_sleep+0x24>
    return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106145:	eb 6c                	jmp    801061b3 <sys_sleep+0x90>
  acquire(&tickslock);
80106147:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
8010614e:	e8 91 ea ff ff       	call   80104be4 <acquire>
  ticks0 = ticks;
80106153:	a1 a0 29 11 80       	mov    0x801129a0,%eax
80106158:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010615b:	eb 34                	jmp    80106191 <sys_sleep+0x6e>
    if(proc->killed){
8010615d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106163:	8b 40 24             	mov    0x24(%eax),%eax
80106166:	85 c0                	test   %eax,%eax
80106168:	74 13                	je     8010617d <sys_sleep+0x5a>
      release(&tickslock);
8010616a:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
80106171:	e8 d0 ea ff ff       	call   80104c46 <release>
      return -1;
80106176:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010617b:	eb 36                	jmp    801061b3 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010617d:	c7 44 24 04 60 21 11 	movl   $0x80112160,0x4(%esp)
80106184:	80 
80106185:	c7 04 24 a0 29 11 80 	movl   $0x801129a0,(%esp)
8010618c:	e8 80 e7 ff ff       	call   80104911 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106191:	a1 a0 29 11 80       	mov    0x801129a0,%eax
80106196:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106199:	89 c2                	mov    %eax,%edx
8010619b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619e:	39 c2                	cmp    %eax,%edx
801061a0:	72 bb                	jb     8010615d <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801061a2:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
801061a9:	e8 98 ea ff ff       	call   80104c46 <release>
  return 0;
801061ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061b3:	c9                   	leave  
801061b4:	c3                   	ret    

801061b5 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061b5:	55                   	push   %ebp
801061b6:	89 e5                	mov    %esp,%ebp
801061b8:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801061bb:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
801061c2:	e8 1d ea ff ff       	call   80104be4 <acquire>
  xticks = ticks;
801061c7:	a1 a0 29 11 80       	mov    0x801129a0,%eax
801061cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801061cf:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
801061d6:	e8 6b ea ff ff       	call   80104c46 <release>
  return xticks;
801061db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061de:	c9                   	leave  
801061df:	c3                   	ret    

801061e0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	83 ec 08             	sub    $0x8,%esp
801061e6:	8b 55 08             	mov    0x8(%ebp),%edx
801061e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801061ec:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801061f0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061f3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801061f7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801061fb:	ee                   	out    %al,(%dx)
}
801061fc:	c9                   	leave  
801061fd:	c3                   	ret    

801061fe <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801061fe:	55                   	push   %ebp
801061ff:	89 e5                	mov    %esp,%ebp
80106201:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106204:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
8010620b:	00 
8010620c:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106213:	e8 c8 ff ff ff       	call   801061e0 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106218:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
8010621f:	00 
80106220:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106227:	e8 b4 ff ff ff       	call   801061e0 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010622c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106233:	00 
80106234:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010623b:	e8 a0 ff ff ff       	call   801061e0 <outb>
  picenable(IRQ_TIMER);
80106240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106247:	e8 19 d8 ff ff       	call   80103a65 <picenable>
}
8010624c:	c9                   	leave  
8010624d:	c3                   	ret    

8010624e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010624e:	1e                   	push   %ds
  pushl %es
8010624f:	06                   	push   %es
  pushl %fs
80106250:	0f a0                	push   %fs
  pushl %gs
80106252:	0f a8                	push   %gs
  pushal
80106254:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106255:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106259:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010625b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010625d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106261:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106263:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106265:	54                   	push   %esp
  call trap
80106266:	e8 d8 01 00 00       	call   80106443 <trap>
  addl $4, %esp
8010626b:	83 c4 04             	add    $0x4,%esp

8010626e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010626e:	61                   	popa   
  popl %gs
8010626f:	0f a9                	pop    %gs
  popl %fs
80106271:	0f a1                	pop    %fs
  popl %es
80106273:	07                   	pop    %es
  popl %ds
80106274:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106275:	83 c4 08             	add    $0x8,%esp
  iret
80106278:	cf                   	iret   

80106279 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106279:	55                   	push   %ebp
8010627a:	89 e5                	mov    %esp,%ebp
8010627c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010627f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106282:	83 e8 01             	sub    $0x1,%eax
80106285:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106289:	8b 45 08             	mov    0x8(%ebp),%eax
8010628c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106290:	8b 45 08             	mov    0x8(%ebp),%eax
80106293:	c1 e8 10             	shr    $0x10,%eax
80106296:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010629a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010629d:	0f 01 18             	lidtl  (%eax)
}
801062a0:	c9                   	leave  
801062a1:	c3                   	ret    

801062a2 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801062a2:	55                   	push   %ebp
801062a3:	89 e5                	mov    %esp,%ebp
801062a5:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062a8:	0f 20 d0             	mov    %cr2,%eax
801062ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801062ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062b1:	c9                   	leave  
801062b2:	c3                   	ret    

801062b3 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
801062b3:	55                   	push   %ebp
801062b4:	89 e5                	mov    %esp,%ebp
801062b6:	83 ec 28             	sub    $0x28,%esp
	int i;

	for (i = 0; i < 256; i++)
801062b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801062c0:	e9 c3 00 00 00       	jmp    80106388 <tvinit+0xd5>
		SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c8:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801062cf:	89 c2                	mov    %eax,%edx
801062d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d4:	66 89 14 c5 a0 21 11 	mov    %dx,-0x7feede60(,%eax,8)
801062db:	80 
801062dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062df:	66 c7 04 c5 a2 21 11 	movw   $0x8,-0x7feede5e(,%eax,8)
801062e6:	80 08 00 
801062e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ec:	0f b6 14 c5 a4 21 11 	movzbl -0x7feede5c(,%eax,8),%edx
801062f3:	80 
801062f4:	83 e2 e0             	and    $0xffffffe0,%edx
801062f7:	88 14 c5 a4 21 11 80 	mov    %dl,-0x7feede5c(,%eax,8)
801062fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106301:	0f b6 14 c5 a4 21 11 	movzbl -0x7feede5c(,%eax,8),%edx
80106308:	80 
80106309:	83 e2 1f             	and    $0x1f,%edx
8010630c:	88 14 c5 a4 21 11 80 	mov    %dl,-0x7feede5c(,%eax,8)
80106313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106316:	0f b6 14 c5 a5 21 11 	movzbl -0x7feede5b(,%eax,8),%edx
8010631d:	80 
8010631e:	83 e2 f0             	and    $0xfffffff0,%edx
80106321:	83 ca 0e             	or     $0xe,%edx
80106324:	88 14 c5 a5 21 11 80 	mov    %dl,-0x7feede5b(,%eax,8)
8010632b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632e:	0f b6 14 c5 a5 21 11 	movzbl -0x7feede5b(,%eax,8),%edx
80106335:	80 
80106336:	83 e2 ef             	and    $0xffffffef,%edx
80106339:	88 14 c5 a5 21 11 80 	mov    %dl,-0x7feede5b(,%eax,8)
80106340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106343:	0f b6 14 c5 a5 21 11 	movzbl -0x7feede5b(,%eax,8),%edx
8010634a:	80 
8010634b:	83 e2 9f             	and    $0xffffff9f,%edx
8010634e:	88 14 c5 a5 21 11 80 	mov    %dl,-0x7feede5b(,%eax,8)
80106355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106358:	0f b6 14 c5 a5 21 11 	movzbl -0x7feede5b(,%eax,8),%edx
8010635f:	80 
80106360:	83 ca 80             	or     $0xffffff80,%edx
80106363:	88 14 c5 a5 21 11 80 	mov    %dl,-0x7feede5b(,%eax,8)
8010636a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010636d:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106374:	c1 e8 10             	shr    $0x10,%eax
80106377:	89 c2                	mov    %eax,%edx
80106379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010637c:	66 89 14 c5 a6 21 11 	mov    %dx,-0x7feede5a(,%eax,8)
80106383:	80 
uint ticks;

void tvinit(void) {
	int i;

	for (i = 0; i < 256; i++)
80106384:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106388:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010638f:	0f 8e 30 ff ff ff    	jle    801062c5 <tvinit+0x12>
		SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106395:	a1 98 b1 10 80       	mov    0x8010b198,%eax
8010639a:	66 a3 a0 23 11 80    	mov    %ax,0x801123a0
801063a0:	66 c7 05 a2 23 11 80 	movw   $0x8,0x801123a2
801063a7:	08 00 
801063a9:	0f b6 05 a4 23 11 80 	movzbl 0x801123a4,%eax
801063b0:	83 e0 e0             	and    $0xffffffe0,%eax
801063b3:	a2 a4 23 11 80       	mov    %al,0x801123a4
801063b8:	0f b6 05 a4 23 11 80 	movzbl 0x801123a4,%eax
801063bf:	83 e0 1f             	and    $0x1f,%eax
801063c2:	a2 a4 23 11 80       	mov    %al,0x801123a4
801063c7:	0f b6 05 a5 23 11 80 	movzbl 0x801123a5,%eax
801063ce:	83 c8 0f             	or     $0xf,%eax
801063d1:	a2 a5 23 11 80       	mov    %al,0x801123a5
801063d6:	0f b6 05 a5 23 11 80 	movzbl 0x801123a5,%eax
801063dd:	83 e0 ef             	and    $0xffffffef,%eax
801063e0:	a2 a5 23 11 80       	mov    %al,0x801123a5
801063e5:	0f b6 05 a5 23 11 80 	movzbl 0x801123a5,%eax
801063ec:	83 c8 60             	or     $0x60,%eax
801063ef:	a2 a5 23 11 80       	mov    %al,0x801123a5
801063f4:	0f b6 05 a5 23 11 80 	movzbl 0x801123a5,%eax
801063fb:	83 c8 80             	or     $0xffffff80,%eax
801063fe:	a2 a5 23 11 80       	mov    %al,0x801123a5
80106403:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106408:	c1 e8 10             	shr    $0x10,%eax
8010640b:	66 a3 a6 23 11 80    	mov    %ax,0x801123a6

	initlock(&tickslock, "time");
80106411:	c7 44 24 04 64 86 10 	movl   $0x80108664,0x4(%esp)
80106418:	80 
80106419:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
80106420:	e8 9e e7 ff ff       	call   80104bc3 <initlock>
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    

80106427 <idtinit>:

void idtinit(void) {
80106427:	55                   	push   %ebp
80106428:	89 e5                	mov    %esp,%ebp
8010642a:	83 ec 08             	sub    $0x8,%esp
	lidt(idt, sizeof(idt));
8010642d:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106434:	00 
80106435:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
8010643c:	e8 38 fe ff ff       	call   80106279 <lidt>
}
80106441:	c9                   	leave  
80106442:	c3                   	ret    

80106443 <trap>:

//PAGEBREAK: 41
void trap(struct trapframe *tf) {
80106443:	55                   	push   %ebp
80106444:	89 e5                	mov    %esp,%ebp
80106446:	57                   	push   %edi
80106447:	56                   	push   %esi
80106448:	53                   	push   %ebx
80106449:	83 ec 3c             	sub    $0x3c,%esp
	if (tf->trapno == T_SYSCALL) {
8010644c:	8b 45 08             	mov    0x8(%ebp),%eax
8010644f:	8b 40 30             	mov    0x30(%eax),%eax
80106452:	83 f8 40             	cmp    $0x40,%eax
80106455:	75 3f                	jne    80106496 <trap+0x53>
		if (proc->killed)
80106457:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010645d:	8b 40 24             	mov    0x24(%eax),%eax
80106460:	85 c0                	test   %eax,%eax
80106462:	74 05                	je     80106469 <trap+0x26>
			exit();
80106464:	e8 98 df ff ff       	call   80104401 <exit>
		proc->tf = tf;
80106469:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010646f:	8b 55 08             	mov    0x8(%ebp),%edx
80106472:	89 50 18             	mov    %edx,0x18(%eax)
		syscall();
80106475:	e8 d1 ed ff ff       	call   8010524b <syscall>
		if (proc->killed)
8010647a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106480:	8b 40 24             	mov    0x24(%eax),%eax
80106483:	85 c0                	test   %eax,%eax
80106485:	74 0a                	je     80106491 <trap+0x4e>
			exit();
80106487:	e8 75 df ff ff       	call   80104401 <exit>
		return;
8010648c:	e9 62 02 00 00       	jmp    801066f3 <trap+0x2b0>
80106491:	e9 5d 02 00 00       	jmp    801066f3 <trap+0x2b0>
	}

	switch (tf->trapno) {
80106496:	8b 45 08             	mov    0x8(%ebp),%eax
80106499:	8b 40 30             	mov    0x30(%eax),%eax
8010649c:	83 e8 20             	sub    $0x20,%eax
8010649f:	83 f8 1f             	cmp    $0x1f,%eax
801064a2:	0f 87 e3 00 00 00    	ja     8010658b <trap+0x148>
801064a8:	8b 04 85 0c 87 10 80 	mov    -0x7fef78f4(,%eax,4),%eax
801064af:	ff e0                	jmp    *%eax
	case T_IRQ0 + IRQ_TIMER:
		if (cpu->id == 0) {
801064b1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064b7:	0f b6 00             	movzbl (%eax),%eax
801064ba:	84 c0                	test   %al,%al
801064bc:	75 58                	jne    80106516 <trap+0xd3>
			acquire(&tickslock);
801064be:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
801064c5:	e8 1a e7 ff ff       	call   80104be4 <acquire>
			ticks++;
801064ca:	a1 a0 29 11 80       	mov    0x801129a0,%eax
801064cf:	83 c0 01             	add    $0x1,%eax
801064d2:	a3 a0 29 11 80       	mov    %eax,0x801129a0
			if (proc && proc->state == RUNNING) {
801064d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064dd:	85 c0                	test   %eax,%eax
801064df:	74 1d                	je     801064fe <trap+0xbb>
801064e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064e7:	8b 40 0c             	mov    0xc(%eax),%eax
801064ea:	83 f8 04             	cmp    $0x4,%eax
801064ed:	75 0f                	jne    801064fe <trap+0xbb>
				proc->quanta++;
801064ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064f5:	8b 50 7c             	mov    0x7c(%eax),%edx
801064f8:	83 c2 01             	add    $0x1,%edx
801064fb:	89 50 7c             	mov    %edx,0x7c(%eax)
			}
			wakeup(&ticks);
801064fe:	c7 04 24 a0 29 11 80 	movl   $0x801129a0,(%esp)
80106505:	e8 e3 e4 ff ff       	call   801049ed <wakeup>
			release(&tickslock);
8010650a:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
80106511:	e8 30 e7 ff ff       	call   80104c46 <release>
		}
		lapiceoi();
80106516:	e8 8b c9 ff ff       	call   80102ea6 <lapiceoi>
		break;
8010651b:	e9 41 01 00 00       	jmp    80106661 <trap+0x21e>
	case T_IRQ0 + IRQ_IDE:
		ideintr();
80106520:	e8 ac c1 ff ff       	call   801026d1 <ideintr>
		lapiceoi();
80106525:	e8 7c c9 ff ff       	call   80102ea6 <lapiceoi>
		break;
8010652a:	e9 32 01 00 00       	jmp    80106661 <trap+0x21e>
	case T_IRQ0 + IRQ_IDE + 1:
		// Bochs generates spurious IDE1 interrupts.
		break;
	case T_IRQ0 + IRQ_KBD:
		kbdintr();
8010652f:	e8 5e c7 ff ff       	call   80102c92 <kbdintr>
		lapiceoi();
80106534:	e8 6d c9 ff ff       	call   80102ea6 <lapiceoi>
		break;
80106539:	e9 23 01 00 00       	jmp    80106661 <trap+0x21e>
	case T_IRQ0 + IRQ_COM1:
		uartintr();
8010653e:	e8 a5 03 00 00       	call   801068e8 <uartintr>
		lapiceoi();
80106543:	e8 5e c9 ff ff       	call   80102ea6 <lapiceoi>
		break;
80106548:	e9 14 01 00 00       	jmp    80106661 <trap+0x21e>
	case T_IRQ0 + 7:
	case T_IRQ0 + IRQ_SPURIOUS:
		cprintf("cpu%d: spurious interrupt at %x:%x\n", cpu->id, tf->cs,
8010654d:	8b 45 08             	mov    0x8(%ebp),%eax
80106550:	8b 48 38             	mov    0x38(%eax),%ecx
80106553:	8b 45 08             	mov    0x8(%ebp),%eax
80106556:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010655a:	0f b7 d0             	movzwl %ax,%edx
8010655d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106563:	0f b6 00             	movzbl (%eax),%eax
80106566:	0f b6 c0             	movzbl %al,%eax
80106569:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010656d:	89 54 24 08          	mov    %edx,0x8(%esp)
80106571:	89 44 24 04          	mov    %eax,0x4(%esp)
80106575:	c7 04 24 6c 86 10 80 	movl   $0x8010866c,(%esp)
8010657c:	e8 1f 9e ff ff       	call   801003a0 <cprintf>
				tf->eip);
		lapiceoi();
80106581:	e8 20 c9 ff ff       	call   80102ea6 <lapiceoi>
		break;
80106586:	e9 d6 00 00 00       	jmp    80106661 <trap+0x21e>

		//PAGEBREAK: 13
	default:
		if (proc == 0 || (tf->cs & 3) == 0) {
8010658b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106591:	85 c0                	test   %eax,%eax
80106593:	74 11                	je     801065a6 <trap+0x163>
80106595:	8b 45 08             	mov    0x8(%ebp),%eax
80106598:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010659c:	0f b7 c0             	movzwl %ax,%eax
8010659f:	83 e0 03             	and    $0x3,%eax
801065a2:	85 c0                	test   %eax,%eax
801065a4:	75 46                	jne    801065ec <trap+0x1a9>
			// In kernel, it must be our mistake.
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065a6:	e8 f7 fc ff ff       	call   801062a2 <rcr2>
801065ab:	8b 55 08             	mov    0x8(%ebp),%edx
801065ae:	8b 5a 38             	mov    0x38(%edx),%ebx
					tf->trapno, cpu->id, tf->eip, rcr2());
801065b1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801065b8:	0f b6 12             	movzbl (%edx),%edx

		//PAGEBREAK: 13
	default:
		if (proc == 0 || (tf->cs & 3) == 0) {
			// In kernel, it must be our mistake.
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065bb:	0f b6 ca             	movzbl %dl,%ecx
801065be:	8b 55 08             	mov    0x8(%ebp),%edx
801065c1:	8b 52 30             	mov    0x30(%edx),%edx
801065c4:	89 44 24 10          	mov    %eax,0x10(%esp)
801065c8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801065cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801065d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801065d4:	c7 04 24 90 86 10 80 	movl   $0x80108690,(%esp)
801065db:	e8 c0 9d ff ff       	call   801003a0 <cprintf>
					tf->trapno, cpu->id, tf->eip, rcr2());
			panic("trap");
801065e0:	c7 04 24 c2 86 10 80 	movl   $0x801086c2,(%esp)
801065e7:	e8 4e 9f ff ff       	call   8010053a <panic>
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
801065ec:	e8 b1 fc ff ff       	call   801062a2 <rcr2>
801065f1:	89 c2                	mov    %eax,%edx
801065f3:	8b 45 08             	mov    0x8(%ebp),%eax
801065f6:	8b 78 38             	mov    0x38(%eax),%edi
				"eip 0x%x addr 0x%x--kill proc\n", proc->pid, proc->name,
				tf->trapno, tf->err, cpu->id, tf->eip, rcr2());
801065f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801065ff:	0f b6 00             	movzbl (%eax),%eax
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
					tf->trapno, cpu->id, tf->eip, rcr2());
			panic("trap");
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80106602:	0f b6 f0             	movzbl %al,%esi
80106605:	8b 45 08             	mov    0x8(%ebp),%eax
80106608:	8b 58 34             	mov    0x34(%eax),%ebx
8010660b:	8b 45 08             	mov    0x8(%ebp),%eax
8010660e:	8b 48 30             	mov    0x30(%eax),%ecx
				"eip 0x%x addr 0x%x--kill proc\n", proc->pid, proc->name,
80106611:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106617:	83 c0 6c             	add    $0x6c,%eax
8010661a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010661d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
					tf->trapno, cpu->id, tf->eip, rcr2());
			panic("trap");
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80106623:	8b 40 10             	mov    0x10(%eax),%eax
80106626:	89 54 24 1c          	mov    %edx,0x1c(%esp)
8010662a:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010662e:	89 74 24 14          	mov    %esi,0x14(%esp)
80106632:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106636:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010663a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010663d:	89 74 24 08          	mov    %esi,0x8(%esp)
80106641:	89 44 24 04          	mov    %eax,0x4(%esp)
80106645:	c7 04 24 c8 86 10 80 	movl   $0x801086c8,(%esp)
8010664c:	e8 4f 9d ff ff       	call   801003a0 <cprintf>
				"eip 0x%x addr 0x%x--kill proc\n", proc->pid, proc->name,
				tf->trapno, tf->err, cpu->id, tf->eip, rcr2());
		proc->killed = 1;
80106651:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106657:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010665e:	eb 01                	jmp    80106661 <trap+0x21e>
		ideintr();
		lapiceoi();
		break;
	case T_IRQ0 + IRQ_IDE + 1:
		// Bochs generates spurious IDE1 interrupts.
		break;
80106660:	90                   	nop
	}

	// Force process exit if it has been killed and is in user space.
	// (If it is still executing in the kernel, let it keep running
	// until it gets to the regular system call return.)
	if (proc && proc->killed && (tf->cs & 3) == DPL_USER)
80106661:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106667:	85 c0                	test   %eax,%eax
80106669:	74 24                	je     8010668f <trap+0x24c>
8010666b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106671:	8b 40 24             	mov    0x24(%eax),%eax
80106674:	85 c0                	test   %eax,%eax
80106676:	74 17                	je     8010668f <trap+0x24c>
80106678:	8b 45 08             	mov    0x8(%ebp),%eax
8010667b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010667f:	0f b7 c0             	movzwl %ax,%eax
80106682:	83 e0 03             	and    $0x3,%eax
80106685:	83 f8 03             	cmp    $0x3,%eax
80106688:	75 05                	jne    8010668f <trap+0x24c>
		exit();
8010668a:	e8 72 dd ff ff       	call   80104401 <exit>

	// Force process to give up CPU on clock tick.
	// If interrupts were on while locks held, would need to check nlock.
	if (proc && proc->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
8010668f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106695:	85 c0                	test   %eax,%eax
80106697:	74 2c                	je     801066c5 <trap+0x282>
80106699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010669f:	8b 40 0c             	mov    0xc(%eax),%eax
801066a2:	83 f8 04             	cmp    $0x4,%eax
801066a5:	75 1e                	jne    801066c5 <trap+0x282>
801066a7:	8b 45 08             	mov    0x8(%ebp),%eax
801066aa:	8b 40 30             	mov    0x30(%eax),%eax
801066ad:	83 f8 20             	cmp    $0x20,%eax
801066b0:	75 13                	jne    801066c5 <trap+0x282>
		if (proc->quanta == QUANTA) {
801066b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066b8:	8b 40 7c             	mov    0x7c(%eax),%eax
801066bb:	83 f8 05             	cmp    $0x5,%eax
801066be:	75 05                	jne    801066c5 <trap+0x282>
			yield();
801066c0:	e8 d3 e1 ff ff       	call   80104898 <yield>
		}

	// Check if the process has been killed since we yielded
	if (proc && proc->killed && (tf->cs & 3) == DPL_USER)
801066c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066cb:	85 c0                	test   %eax,%eax
801066cd:	74 24                	je     801066f3 <trap+0x2b0>
801066cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066d5:	8b 40 24             	mov    0x24(%eax),%eax
801066d8:	85 c0                	test   %eax,%eax
801066da:	74 17                	je     801066f3 <trap+0x2b0>
801066dc:	8b 45 08             	mov    0x8(%ebp),%eax
801066df:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801066e3:	0f b7 c0             	movzwl %ax,%eax
801066e6:	83 e0 03             	and    $0x3,%eax
801066e9:	83 f8 03             	cmp    $0x3,%eax
801066ec:	75 05                	jne    801066f3 <trap+0x2b0>
		exit();
801066ee:	e8 0e dd ff ff       	call   80104401 <exit>
}
801066f3:	83 c4 3c             	add    $0x3c,%esp
801066f6:	5b                   	pop    %ebx
801066f7:	5e                   	pop    %esi
801066f8:	5f                   	pop    %edi
801066f9:	5d                   	pop    %ebp
801066fa:	c3                   	ret    

801066fb <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801066fb:	55                   	push   %ebp
801066fc:	89 e5                	mov    %esp,%ebp
801066fe:	83 ec 14             	sub    $0x14,%esp
80106701:	8b 45 08             	mov    0x8(%ebp),%eax
80106704:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106708:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010670c:	89 c2                	mov    %eax,%edx
8010670e:	ec                   	in     (%dx),%al
8010670f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106712:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106716:	c9                   	leave  
80106717:	c3                   	ret    

80106718 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106718:	55                   	push   %ebp
80106719:	89 e5                	mov    %esp,%ebp
8010671b:	83 ec 08             	sub    $0x8,%esp
8010671e:	8b 55 08             	mov    0x8(%ebp),%edx
80106721:	8b 45 0c             	mov    0xc(%ebp),%eax
80106724:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106728:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010672b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010672f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106733:	ee                   	out    %al,(%dx)
}
80106734:	c9                   	leave  
80106735:	c3                   	ret    

80106736 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106736:	55                   	push   %ebp
80106737:	89 e5                	mov    %esp,%ebp
80106739:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010673c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106743:	00 
80106744:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010674b:	e8 c8 ff ff ff       	call   80106718 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106750:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106757:	00 
80106758:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010675f:	e8 b4 ff ff ff       	call   80106718 <outb>
  outb(COM1+0, 115200/9600);
80106764:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
8010676b:	00 
8010676c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106773:	e8 a0 ff ff ff       	call   80106718 <outb>
  outb(COM1+1, 0);
80106778:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010677f:	00 
80106780:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106787:	e8 8c ff ff ff       	call   80106718 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010678c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106793:	00 
80106794:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010679b:	e8 78 ff ff ff       	call   80106718 <outb>
  outb(COM1+4, 0);
801067a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067a7:	00 
801067a8:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801067af:	e8 64 ff ff ff       	call   80106718 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801067b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801067bb:	00 
801067bc:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801067c3:	e8 50 ff ff ff       	call   80106718 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801067c8:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801067cf:	e8 27 ff ff ff       	call   801066fb <inb>
801067d4:	3c ff                	cmp    $0xff,%al
801067d6:	75 02                	jne    801067da <uartinit+0xa4>
    return;
801067d8:	eb 6a                	jmp    80106844 <uartinit+0x10e>
  uart = 1;
801067da:	c7 05 54 b6 10 80 01 	movl   $0x1,0x8010b654
801067e1:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801067e4:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801067eb:	e8 0b ff ff ff       	call   801066fb <inb>
  inb(COM1+0);
801067f0:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801067f7:	e8 ff fe ff ff       	call   801066fb <inb>
  picenable(IRQ_COM1);
801067fc:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106803:	e8 5d d2 ff ff       	call   80103a65 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106808:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010680f:	00 
80106810:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106817:	e8 34 c1 ff ff       	call   80102950 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010681c:	c7 45 f4 8c 87 10 80 	movl   $0x8010878c,-0xc(%ebp)
80106823:	eb 15                	jmp    8010683a <uartinit+0x104>
    uartputc(*p);
80106825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106828:	0f b6 00             	movzbl (%eax),%eax
8010682b:	0f be c0             	movsbl %al,%eax
8010682e:	89 04 24             	mov    %eax,(%esp)
80106831:	e8 10 00 00 00       	call   80106846 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106836:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010683a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010683d:	0f b6 00             	movzbl (%eax),%eax
80106840:	84 c0                	test   %al,%al
80106842:	75 e1                	jne    80106825 <uartinit+0xef>
    uartputc(*p);
}
80106844:	c9                   	leave  
80106845:	c3                   	ret    

80106846 <uartputc>:

void
uartputc(int c)
{
80106846:	55                   	push   %ebp
80106847:	89 e5                	mov    %esp,%ebp
80106849:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010684c:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80106851:	85 c0                	test   %eax,%eax
80106853:	75 02                	jne    80106857 <uartputc+0x11>
    return;
80106855:	eb 4b                	jmp    801068a2 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010685e:	eb 10                	jmp    80106870 <uartputc+0x2a>
    microdelay(10);
80106860:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106867:	e8 5f c6 ff ff       	call   80102ecb <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010686c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106870:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106874:	7f 16                	jg     8010688c <uartputc+0x46>
80106876:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010687d:	e8 79 fe ff ff       	call   801066fb <inb>
80106882:	0f b6 c0             	movzbl %al,%eax
80106885:	83 e0 20             	and    $0x20,%eax
80106888:	85 c0                	test   %eax,%eax
8010688a:	74 d4                	je     80106860 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
8010688c:	8b 45 08             	mov    0x8(%ebp),%eax
8010688f:	0f b6 c0             	movzbl %al,%eax
80106892:	89 44 24 04          	mov    %eax,0x4(%esp)
80106896:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010689d:	e8 76 fe ff ff       	call   80106718 <outb>
}
801068a2:	c9                   	leave  
801068a3:	c3                   	ret    

801068a4 <uartgetc>:

static int
uartgetc(void)
{
801068a4:	55                   	push   %ebp
801068a5:	89 e5                	mov    %esp,%ebp
801068a7:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801068aa:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801068af:	85 c0                	test   %eax,%eax
801068b1:	75 07                	jne    801068ba <uartgetc+0x16>
    return -1;
801068b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b8:	eb 2c                	jmp    801068e6 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801068ba:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801068c1:	e8 35 fe ff ff       	call   801066fb <inb>
801068c6:	0f b6 c0             	movzbl %al,%eax
801068c9:	83 e0 01             	and    $0x1,%eax
801068cc:	85 c0                	test   %eax,%eax
801068ce:	75 07                	jne    801068d7 <uartgetc+0x33>
    return -1;
801068d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d5:	eb 0f                	jmp    801068e6 <uartgetc+0x42>
  return inb(COM1+0);
801068d7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068de:	e8 18 fe ff ff       	call   801066fb <inb>
801068e3:	0f b6 c0             	movzbl %al,%eax
}
801068e6:	c9                   	leave  
801068e7:	c3                   	ret    

801068e8 <uartintr>:

void
uartintr(void)
{
801068e8:	55                   	push   %ebp
801068e9:	89 e5                	mov    %esp,%ebp
801068eb:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801068ee:	c7 04 24 a4 68 10 80 	movl   $0x801068a4,(%esp)
801068f5:	e8 b3 9e ff ff       	call   801007ad <consoleintr>
}
801068fa:	c9                   	leave  
801068fb:	c3                   	ret    

801068fc <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $0
801068fe:	6a 00                	push   $0x0
  jmp alltraps
80106900:	e9 49 f9 ff ff       	jmp    8010624e <alltraps>

80106905 <vector1>:
.globl vector1
vector1:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $1
80106907:	6a 01                	push   $0x1
  jmp alltraps
80106909:	e9 40 f9 ff ff       	jmp    8010624e <alltraps>

8010690e <vector2>:
.globl vector2
vector2:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $2
80106910:	6a 02                	push   $0x2
  jmp alltraps
80106912:	e9 37 f9 ff ff       	jmp    8010624e <alltraps>

80106917 <vector3>:
.globl vector3
vector3:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $3
80106919:	6a 03                	push   $0x3
  jmp alltraps
8010691b:	e9 2e f9 ff ff       	jmp    8010624e <alltraps>

80106920 <vector4>:
.globl vector4
vector4:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $4
80106922:	6a 04                	push   $0x4
  jmp alltraps
80106924:	e9 25 f9 ff ff       	jmp    8010624e <alltraps>

80106929 <vector5>:
.globl vector5
vector5:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $5
8010692b:	6a 05                	push   $0x5
  jmp alltraps
8010692d:	e9 1c f9 ff ff       	jmp    8010624e <alltraps>

80106932 <vector6>:
.globl vector6
vector6:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $6
80106934:	6a 06                	push   $0x6
  jmp alltraps
80106936:	e9 13 f9 ff ff       	jmp    8010624e <alltraps>

8010693b <vector7>:
.globl vector7
vector7:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $7
8010693d:	6a 07                	push   $0x7
  jmp alltraps
8010693f:	e9 0a f9 ff ff       	jmp    8010624e <alltraps>

80106944 <vector8>:
.globl vector8
vector8:
  pushl $8
80106944:	6a 08                	push   $0x8
  jmp alltraps
80106946:	e9 03 f9 ff ff       	jmp    8010624e <alltraps>

8010694b <vector9>:
.globl vector9
vector9:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $9
8010694d:	6a 09                	push   $0x9
  jmp alltraps
8010694f:	e9 fa f8 ff ff       	jmp    8010624e <alltraps>

80106954 <vector10>:
.globl vector10
vector10:
  pushl $10
80106954:	6a 0a                	push   $0xa
  jmp alltraps
80106956:	e9 f3 f8 ff ff       	jmp    8010624e <alltraps>

8010695b <vector11>:
.globl vector11
vector11:
  pushl $11
8010695b:	6a 0b                	push   $0xb
  jmp alltraps
8010695d:	e9 ec f8 ff ff       	jmp    8010624e <alltraps>

80106962 <vector12>:
.globl vector12
vector12:
  pushl $12
80106962:	6a 0c                	push   $0xc
  jmp alltraps
80106964:	e9 e5 f8 ff ff       	jmp    8010624e <alltraps>

80106969 <vector13>:
.globl vector13
vector13:
  pushl $13
80106969:	6a 0d                	push   $0xd
  jmp alltraps
8010696b:	e9 de f8 ff ff       	jmp    8010624e <alltraps>

80106970 <vector14>:
.globl vector14
vector14:
  pushl $14
80106970:	6a 0e                	push   $0xe
  jmp alltraps
80106972:	e9 d7 f8 ff ff       	jmp    8010624e <alltraps>

80106977 <vector15>:
.globl vector15
vector15:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $15
80106979:	6a 0f                	push   $0xf
  jmp alltraps
8010697b:	e9 ce f8 ff ff       	jmp    8010624e <alltraps>

80106980 <vector16>:
.globl vector16
vector16:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $16
80106982:	6a 10                	push   $0x10
  jmp alltraps
80106984:	e9 c5 f8 ff ff       	jmp    8010624e <alltraps>

80106989 <vector17>:
.globl vector17
vector17:
  pushl $17
80106989:	6a 11                	push   $0x11
  jmp alltraps
8010698b:	e9 be f8 ff ff       	jmp    8010624e <alltraps>

80106990 <vector18>:
.globl vector18
vector18:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $18
80106992:	6a 12                	push   $0x12
  jmp alltraps
80106994:	e9 b5 f8 ff ff       	jmp    8010624e <alltraps>

80106999 <vector19>:
.globl vector19
vector19:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $19
8010699b:	6a 13                	push   $0x13
  jmp alltraps
8010699d:	e9 ac f8 ff ff       	jmp    8010624e <alltraps>

801069a2 <vector20>:
.globl vector20
vector20:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $20
801069a4:	6a 14                	push   $0x14
  jmp alltraps
801069a6:	e9 a3 f8 ff ff       	jmp    8010624e <alltraps>

801069ab <vector21>:
.globl vector21
vector21:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $21
801069ad:	6a 15                	push   $0x15
  jmp alltraps
801069af:	e9 9a f8 ff ff       	jmp    8010624e <alltraps>

801069b4 <vector22>:
.globl vector22
vector22:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $22
801069b6:	6a 16                	push   $0x16
  jmp alltraps
801069b8:	e9 91 f8 ff ff       	jmp    8010624e <alltraps>

801069bd <vector23>:
.globl vector23
vector23:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $23
801069bf:	6a 17                	push   $0x17
  jmp alltraps
801069c1:	e9 88 f8 ff ff       	jmp    8010624e <alltraps>

801069c6 <vector24>:
.globl vector24
vector24:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $24
801069c8:	6a 18                	push   $0x18
  jmp alltraps
801069ca:	e9 7f f8 ff ff       	jmp    8010624e <alltraps>

801069cf <vector25>:
.globl vector25
vector25:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $25
801069d1:	6a 19                	push   $0x19
  jmp alltraps
801069d3:	e9 76 f8 ff ff       	jmp    8010624e <alltraps>

801069d8 <vector26>:
.globl vector26
vector26:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $26
801069da:	6a 1a                	push   $0x1a
  jmp alltraps
801069dc:	e9 6d f8 ff ff       	jmp    8010624e <alltraps>

801069e1 <vector27>:
.globl vector27
vector27:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $27
801069e3:	6a 1b                	push   $0x1b
  jmp alltraps
801069e5:	e9 64 f8 ff ff       	jmp    8010624e <alltraps>

801069ea <vector28>:
.globl vector28
vector28:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $28
801069ec:	6a 1c                	push   $0x1c
  jmp alltraps
801069ee:	e9 5b f8 ff ff       	jmp    8010624e <alltraps>

801069f3 <vector29>:
.globl vector29
vector29:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $29
801069f5:	6a 1d                	push   $0x1d
  jmp alltraps
801069f7:	e9 52 f8 ff ff       	jmp    8010624e <alltraps>

801069fc <vector30>:
.globl vector30
vector30:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $30
801069fe:	6a 1e                	push   $0x1e
  jmp alltraps
80106a00:	e9 49 f8 ff ff       	jmp    8010624e <alltraps>

80106a05 <vector31>:
.globl vector31
vector31:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $31
80106a07:	6a 1f                	push   $0x1f
  jmp alltraps
80106a09:	e9 40 f8 ff ff       	jmp    8010624e <alltraps>

80106a0e <vector32>:
.globl vector32
vector32:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $32
80106a10:	6a 20                	push   $0x20
  jmp alltraps
80106a12:	e9 37 f8 ff ff       	jmp    8010624e <alltraps>

80106a17 <vector33>:
.globl vector33
vector33:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $33
80106a19:	6a 21                	push   $0x21
  jmp alltraps
80106a1b:	e9 2e f8 ff ff       	jmp    8010624e <alltraps>

80106a20 <vector34>:
.globl vector34
vector34:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $34
80106a22:	6a 22                	push   $0x22
  jmp alltraps
80106a24:	e9 25 f8 ff ff       	jmp    8010624e <alltraps>

80106a29 <vector35>:
.globl vector35
vector35:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $35
80106a2b:	6a 23                	push   $0x23
  jmp alltraps
80106a2d:	e9 1c f8 ff ff       	jmp    8010624e <alltraps>

80106a32 <vector36>:
.globl vector36
vector36:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $36
80106a34:	6a 24                	push   $0x24
  jmp alltraps
80106a36:	e9 13 f8 ff ff       	jmp    8010624e <alltraps>

80106a3b <vector37>:
.globl vector37
vector37:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $37
80106a3d:	6a 25                	push   $0x25
  jmp alltraps
80106a3f:	e9 0a f8 ff ff       	jmp    8010624e <alltraps>

80106a44 <vector38>:
.globl vector38
vector38:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $38
80106a46:	6a 26                	push   $0x26
  jmp alltraps
80106a48:	e9 01 f8 ff ff       	jmp    8010624e <alltraps>

80106a4d <vector39>:
.globl vector39
vector39:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $39
80106a4f:	6a 27                	push   $0x27
  jmp alltraps
80106a51:	e9 f8 f7 ff ff       	jmp    8010624e <alltraps>

80106a56 <vector40>:
.globl vector40
vector40:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $40
80106a58:	6a 28                	push   $0x28
  jmp alltraps
80106a5a:	e9 ef f7 ff ff       	jmp    8010624e <alltraps>

80106a5f <vector41>:
.globl vector41
vector41:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $41
80106a61:	6a 29                	push   $0x29
  jmp alltraps
80106a63:	e9 e6 f7 ff ff       	jmp    8010624e <alltraps>

80106a68 <vector42>:
.globl vector42
vector42:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $42
80106a6a:	6a 2a                	push   $0x2a
  jmp alltraps
80106a6c:	e9 dd f7 ff ff       	jmp    8010624e <alltraps>

80106a71 <vector43>:
.globl vector43
vector43:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $43
80106a73:	6a 2b                	push   $0x2b
  jmp alltraps
80106a75:	e9 d4 f7 ff ff       	jmp    8010624e <alltraps>

80106a7a <vector44>:
.globl vector44
vector44:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $44
80106a7c:	6a 2c                	push   $0x2c
  jmp alltraps
80106a7e:	e9 cb f7 ff ff       	jmp    8010624e <alltraps>

80106a83 <vector45>:
.globl vector45
vector45:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $45
80106a85:	6a 2d                	push   $0x2d
  jmp alltraps
80106a87:	e9 c2 f7 ff ff       	jmp    8010624e <alltraps>

80106a8c <vector46>:
.globl vector46
vector46:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $46
80106a8e:	6a 2e                	push   $0x2e
  jmp alltraps
80106a90:	e9 b9 f7 ff ff       	jmp    8010624e <alltraps>

80106a95 <vector47>:
.globl vector47
vector47:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $47
80106a97:	6a 2f                	push   $0x2f
  jmp alltraps
80106a99:	e9 b0 f7 ff ff       	jmp    8010624e <alltraps>

80106a9e <vector48>:
.globl vector48
vector48:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $48
80106aa0:	6a 30                	push   $0x30
  jmp alltraps
80106aa2:	e9 a7 f7 ff ff       	jmp    8010624e <alltraps>

80106aa7 <vector49>:
.globl vector49
vector49:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $49
80106aa9:	6a 31                	push   $0x31
  jmp alltraps
80106aab:	e9 9e f7 ff ff       	jmp    8010624e <alltraps>

80106ab0 <vector50>:
.globl vector50
vector50:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $50
80106ab2:	6a 32                	push   $0x32
  jmp alltraps
80106ab4:	e9 95 f7 ff ff       	jmp    8010624e <alltraps>

80106ab9 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $51
80106abb:	6a 33                	push   $0x33
  jmp alltraps
80106abd:	e9 8c f7 ff ff       	jmp    8010624e <alltraps>

80106ac2 <vector52>:
.globl vector52
vector52:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $52
80106ac4:	6a 34                	push   $0x34
  jmp alltraps
80106ac6:	e9 83 f7 ff ff       	jmp    8010624e <alltraps>

80106acb <vector53>:
.globl vector53
vector53:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $53
80106acd:	6a 35                	push   $0x35
  jmp alltraps
80106acf:	e9 7a f7 ff ff       	jmp    8010624e <alltraps>

80106ad4 <vector54>:
.globl vector54
vector54:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $54
80106ad6:	6a 36                	push   $0x36
  jmp alltraps
80106ad8:	e9 71 f7 ff ff       	jmp    8010624e <alltraps>

80106add <vector55>:
.globl vector55
vector55:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $55
80106adf:	6a 37                	push   $0x37
  jmp alltraps
80106ae1:	e9 68 f7 ff ff       	jmp    8010624e <alltraps>

80106ae6 <vector56>:
.globl vector56
vector56:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $56
80106ae8:	6a 38                	push   $0x38
  jmp alltraps
80106aea:	e9 5f f7 ff ff       	jmp    8010624e <alltraps>

80106aef <vector57>:
.globl vector57
vector57:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $57
80106af1:	6a 39                	push   $0x39
  jmp alltraps
80106af3:	e9 56 f7 ff ff       	jmp    8010624e <alltraps>

80106af8 <vector58>:
.globl vector58
vector58:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $58
80106afa:	6a 3a                	push   $0x3a
  jmp alltraps
80106afc:	e9 4d f7 ff ff       	jmp    8010624e <alltraps>

80106b01 <vector59>:
.globl vector59
vector59:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $59
80106b03:	6a 3b                	push   $0x3b
  jmp alltraps
80106b05:	e9 44 f7 ff ff       	jmp    8010624e <alltraps>

80106b0a <vector60>:
.globl vector60
vector60:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $60
80106b0c:	6a 3c                	push   $0x3c
  jmp alltraps
80106b0e:	e9 3b f7 ff ff       	jmp    8010624e <alltraps>

80106b13 <vector61>:
.globl vector61
vector61:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $61
80106b15:	6a 3d                	push   $0x3d
  jmp alltraps
80106b17:	e9 32 f7 ff ff       	jmp    8010624e <alltraps>

80106b1c <vector62>:
.globl vector62
vector62:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $62
80106b1e:	6a 3e                	push   $0x3e
  jmp alltraps
80106b20:	e9 29 f7 ff ff       	jmp    8010624e <alltraps>

80106b25 <vector63>:
.globl vector63
vector63:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $63
80106b27:	6a 3f                	push   $0x3f
  jmp alltraps
80106b29:	e9 20 f7 ff ff       	jmp    8010624e <alltraps>

80106b2e <vector64>:
.globl vector64
vector64:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $64
80106b30:	6a 40                	push   $0x40
  jmp alltraps
80106b32:	e9 17 f7 ff ff       	jmp    8010624e <alltraps>

80106b37 <vector65>:
.globl vector65
vector65:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $65
80106b39:	6a 41                	push   $0x41
  jmp alltraps
80106b3b:	e9 0e f7 ff ff       	jmp    8010624e <alltraps>

80106b40 <vector66>:
.globl vector66
vector66:
  pushl $0
80106b40:	6a 00                	push   $0x0
  pushl $66
80106b42:	6a 42                	push   $0x42
  jmp alltraps
80106b44:	e9 05 f7 ff ff       	jmp    8010624e <alltraps>

80106b49 <vector67>:
.globl vector67
vector67:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $67
80106b4b:	6a 43                	push   $0x43
  jmp alltraps
80106b4d:	e9 fc f6 ff ff       	jmp    8010624e <alltraps>

80106b52 <vector68>:
.globl vector68
vector68:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $68
80106b54:	6a 44                	push   $0x44
  jmp alltraps
80106b56:	e9 f3 f6 ff ff       	jmp    8010624e <alltraps>

80106b5b <vector69>:
.globl vector69
vector69:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $69
80106b5d:	6a 45                	push   $0x45
  jmp alltraps
80106b5f:	e9 ea f6 ff ff       	jmp    8010624e <alltraps>

80106b64 <vector70>:
.globl vector70
vector70:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $70
80106b66:	6a 46                	push   $0x46
  jmp alltraps
80106b68:	e9 e1 f6 ff ff       	jmp    8010624e <alltraps>

80106b6d <vector71>:
.globl vector71
vector71:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $71
80106b6f:	6a 47                	push   $0x47
  jmp alltraps
80106b71:	e9 d8 f6 ff ff       	jmp    8010624e <alltraps>

80106b76 <vector72>:
.globl vector72
vector72:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $72
80106b78:	6a 48                	push   $0x48
  jmp alltraps
80106b7a:	e9 cf f6 ff ff       	jmp    8010624e <alltraps>

80106b7f <vector73>:
.globl vector73
vector73:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $73
80106b81:	6a 49                	push   $0x49
  jmp alltraps
80106b83:	e9 c6 f6 ff ff       	jmp    8010624e <alltraps>

80106b88 <vector74>:
.globl vector74
vector74:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $74
80106b8a:	6a 4a                	push   $0x4a
  jmp alltraps
80106b8c:	e9 bd f6 ff ff       	jmp    8010624e <alltraps>

80106b91 <vector75>:
.globl vector75
vector75:
  pushl $0
80106b91:	6a 00                	push   $0x0
  pushl $75
80106b93:	6a 4b                	push   $0x4b
  jmp alltraps
80106b95:	e9 b4 f6 ff ff       	jmp    8010624e <alltraps>

80106b9a <vector76>:
.globl vector76
vector76:
  pushl $0
80106b9a:	6a 00                	push   $0x0
  pushl $76
80106b9c:	6a 4c                	push   $0x4c
  jmp alltraps
80106b9e:	e9 ab f6 ff ff       	jmp    8010624e <alltraps>

80106ba3 <vector77>:
.globl vector77
vector77:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $77
80106ba5:	6a 4d                	push   $0x4d
  jmp alltraps
80106ba7:	e9 a2 f6 ff ff       	jmp    8010624e <alltraps>

80106bac <vector78>:
.globl vector78
vector78:
  pushl $0
80106bac:	6a 00                	push   $0x0
  pushl $78
80106bae:	6a 4e                	push   $0x4e
  jmp alltraps
80106bb0:	e9 99 f6 ff ff       	jmp    8010624e <alltraps>

80106bb5 <vector79>:
.globl vector79
vector79:
  pushl $0
80106bb5:	6a 00                	push   $0x0
  pushl $79
80106bb7:	6a 4f                	push   $0x4f
  jmp alltraps
80106bb9:	e9 90 f6 ff ff       	jmp    8010624e <alltraps>

80106bbe <vector80>:
.globl vector80
vector80:
  pushl $0
80106bbe:	6a 00                	push   $0x0
  pushl $80
80106bc0:	6a 50                	push   $0x50
  jmp alltraps
80106bc2:	e9 87 f6 ff ff       	jmp    8010624e <alltraps>

80106bc7 <vector81>:
.globl vector81
vector81:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $81
80106bc9:	6a 51                	push   $0x51
  jmp alltraps
80106bcb:	e9 7e f6 ff ff       	jmp    8010624e <alltraps>

80106bd0 <vector82>:
.globl vector82
vector82:
  pushl $0
80106bd0:	6a 00                	push   $0x0
  pushl $82
80106bd2:	6a 52                	push   $0x52
  jmp alltraps
80106bd4:	e9 75 f6 ff ff       	jmp    8010624e <alltraps>

80106bd9 <vector83>:
.globl vector83
vector83:
  pushl $0
80106bd9:	6a 00                	push   $0x0
  pushl $83
80106bdb:	6a 53                	push   $0x53
  jmp alltraps
80106bdd:	e9 6c f6 ff ff       	jmp    8010624e <alltraps>

80106be2 <vector84>:
.globl vector84
vector84:
  pushl $0
80106be2:	6a 00                	push   $0x0
  pushl $84
80106be4:	6a 54                	push   $0x54
  jmp alltraps
80106be6:	e9 63 f6 ff ff       	jmp    8010624e <alltraps>

80106beb <vector85>:
.globl vector85
vector85:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $85
80106bed:	6a 55                	push   $0x55
  jmp alltraps
80106bef:	e9 5a f6 ff ff       	jmp    8010624e <alltraps>

80106bf4 <vector86>:
.globl vector86
vector86:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $86
80106bf6:	6a 56                	push   $0x56
  jmp alltraps
80106bf8:	e9 51 f6 ff ff       	jmp    8010624e <alltraps>

80106bfd <vector87>:
.globl vector87
vector87:
  pushl $0
80106bfd:	6a 00                	push   $0x0
  pushl $87
80106bff:	6a 57                	push   $0x57
  jmp alltraps
80106c01:	e9 48 f6 ff ff       	jmp    8010624e <alltraps>

80106c06 <vector88>:
.globl vector88
vector88:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $88
80106c08:	6a 58                	push   $0x58
  jmp alltraps
80106c0a:	e9 3f f6 ff ff       	jmp    8010624e <alltraps>

80106c0f <vector89>:
.globl vector89
vector89:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $89
80106c11:	6a 59                	push   $0x59
  jmp alltraps
80106c13:	e9 36 f6 ff ff       	jmp    8010624e <alltraps>

80106c18 <vector90>:
.globl vector90
vector90:
  pushl $0
80106c18:	6a 00                	push   $0x0
  pushl $90
80106c1a:	6a 5a                	push   $0x5a
  jmp alltraps
80106c1c:	e9 2d f6 ff ff       	jmp    8010624e <alltraps>

80106c21 <vector91>:
.globl vector91
vector91:
  pushl $0
80106c21:	6a 00                	push   $0x0
  pushl $91
80106c23:	6a 5b                	push   $0x5b
  jmp alltraps
80106c25:	e9 24 f6 ff ff       	jmp    8010624e <alltraps>

80106c2a <vector92>:
.globl vector92
vector92:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $92
80106c2c:	6a 5c                	push   $0x5c
  jmp alltraps
80106c2e:	e9 1b f6 ff ff       	jmp    8010624e <alltraps>

80106c33 <vector93>:
.globl vector93
vector93:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $93
80106c35:	6a 5d                	push   $0x5d
  jmp alltraps
80106c37:	e9 12 f6 ff ff       	jmp    8010624e <alltraps>

80106c3c <vector94>:
.globl vector94
vector94:
  pushl $0
80106c3c:	6a 00                	push   $0x0
  pushl $94
80106c3e:	6a 5e                	push   $0x5e
  jmp alltraps
80106c40:	e9 09 f6 ff ff       	jmp    8010624e <alltraps>

80106c45 <vector95>:
.globl vector95
vector95:
  pushl $0
80106c45:	6a 00                	push   $0x0
  pushl $95
80106c47:	6a 5f                	push   $0x5f
  jmp alltraps
80106c49:	e9 00 f6 ff ff       	jmp    8010624e <alltraps>

80106c4e <vector96>:
.globl vector96
vector96:
  pushl $0
80106c4e:	6a 00                	push   $0x0
  pushl $96
80106c50:	6a 60                	push   $0x60
  jmp alltraps
80106c52:	e9 f7 f5 ff ff       	jmp    8010624e <alltraps>

80106c57 <vector97>:
.globl vector97
vector97:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $97
80106c59:	6a 61                	push   $0x61
  jmp alltraps
80106c5b:	e9 ee f5 ff ff       	jmp    8010624e <alltraps>

80106c60 <vector98>:
.globl vector98
vector98:
  pushl $0
80106c60:	6a 00                	push   $0x0
  pushl $98
80106c62:	6a 62                	push   $0x62
  jmp alltraps
80106c64:	e9 e5 f5 ff ff       	jmp    8010624e <alltraps>

80106c69 <vector99>:
.globl vector99
vector99:
  pushl $0
80106c69:	6a 00                	push   $0x0
  pushl $99
80106c6b:	6a 63                	push   $0x63
  jmp alltraps
80106c6d:	e9 dc f5 ff ff       	jmp    8010624e <alltraps>

80106c72 <vector100>:
.globl vector100
vector100:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $100
80106c74:	6a 64                	push   $0x64
  jmp alltraps
80106c76:	e9 d3 f5 ff ff       	jmp    8010624e <alltraps>

80106c7b <vector101>:
.globl vector101
vector101:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $101
80106c7d:	6a 65                	push   $0x65
  jmp alltraps
80106c7f:	e9 ca f5 ff ff       	jmp    8010624e <alltraps>

80106c84 <vector102>:
.globl vector102
vector102:
  pushl $0
80106c84:	6a 00                	push   $0x0
  pushl $102
80106c86:	6a 66                	push   $0x66
  jmp alltraps
80106c88:	e9 c1 f5 ff ff       	jmp    8010624e <alltraps>

80106c8d <vector103>:
.globl vector103
vector103:
  pushl $0
80106c8d:	6a 00                	push   $0x0
  pushl $103
80106c8f:	6a 67                	push   $0x67
  jmp alltraps
80106c91:	e9 b8 f5 ff ff       	jmp    8010624e <alltraps>

80106c96 <vector104>:
.globl vector104
vector104:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $104
80106c98:	6a 68                	push   $0x68
  jmp alltraps
80106c9a:	e9 af f5 ff ff       	jmp    8010624e <alltraps>

80106c9f <vector105>:
.globl vector105
vector105:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $105
80106ca1:	6a 69                	push   $0x69
  jmp alltraps
80106ca3:	e9 a6 f5 ff ff       	jmp    8010624e <alltraps>

80106ca8 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $106
80106caa:	6a 6a                	push   $0x6a
  jmp alltraps
80106cac:	e9 9d f5 ff ff       	jmp    8010624e <alltraps>

80106cb1 <vector107>:
.globl vector107
vector107:
  pushl $0
80106cb1:	6a 00                	push   $0x0
  pushl $107
80106cb3:	6a 6b                	push   $0x6b
  jmp alltraps
80106cb5:	e9 94 f5 ff ff       	jmp    8010624e <alltraps>

80106cba <vector108>:
.globl vector108
vector108:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $108
80106cbc:	6a 6c                	push   $0x6c
  jmp alltraps
80106cbe:	e9 8b f5 ff ff       	jmp    8010624e <alltraps>

80106cc3 <vector109>:
.globl vector109
vector109:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $109
80106cc5:	6a 6d                	push   $0x6d
  jmp alltraps
80106cc7:	e9 82 f5 ff ff       	jmp    8010624e <alltraps>

80106ccc <vector110>:
.globl vector110
vector110:
  pushl $0
80106ccc:	6a 00                	push   $0x0
  pushl $110
80106cce:	6a 6e                	push   $0x6e
  jmp alltraps
80106cd0:	e9 79 f5 ff ff       	jmp    8010624e <alltraps>

80106cd5 <vector111>:
.globl vector111
vector111:
  pushl $0
80106cd5:	6a 00                	push   $0x0
  pushl $111
80106cd7:	6a 6f                	push   $0x6f
  jmp alltraps
80106cd9:	e9 70 f5 ff ff       	jmp    8010624e <alltraps>

80106cde <vector112>:
.globl vector112
vector112:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $112
80106ce0:	6a 70                	push   $0x70
  jmp alltraps
80106ce2:	e9 67 f5 ff ff       	jmp    8010624e <alltraps>

80106ce7 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $113
80106ce9:	6a 71                	push   $0x71
  jmp alltraps
80106ceb:	e9 5e f5 ff ff       	jmp    8010624e <alltraps>

80106cf0 <vector114>:
.globl vector114
vector114:
  pushl $0
80106cf0:	6a 00                	push   $0x0
  pushl $114
80106cf2:	6a 72                	push   $0x72
  jmp alltraps
80106cf4:	e9 55 f5 ff ff       	jmp    8010624e <alltraps>

80106cf9 <vector115>:
.globl vector115
vector115:
  pushl $0
80106cf9:	6a 00                	push   $0x0
  pushl $115
80106cfb:	6a 73                	push   $0x73
  jmp alltraps
80106cfd:	e9 4c f5 ff ff       	jmp    8010624e <alltraps>

80106d02 <vector116>:
.globl vector116
vector116:
  pushl $0
80106d02:	6a 00                	push   $0x0
  pushl $116
80106d04:	6a 74                	push   $0x74
  jmp alltraps
80106d06:	e9 43 f5 ff ff       	jmp    8010624e <alltraps>

80106d0b <vector117>:
.globl vector117
vector117:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $117
80106d0d:	6a 75                	push   $0x75
  jmp alltraps
80106d0f:	e9 3a f5 ff ff       	jmp    8010624e <alltraps>

80106d14 <vector118>:
.globl vector118
vector118:
  pushl $0
80106d14:	6a 00                	push   $0x0
  pushl $118
80106d16:	6a 76                	push   $0x76
  jmp alltraps
80106d18:	e9 31 f5 ff ff       	jmp    8010624e <alltraps>

80106d1d <vector119>:
.globl vector119
vector119:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $119
80106d1f:	6a 77                	push   $0x77
  jmp alltraps
80106d21:	e9 28 f5 ff ff       	jmp    8010624e <alltraps>

80106d26 <vector120>:
.globl vector120
vector120:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $120
80106d28:	6a 78                	push   $0x78
  jmp alltraps
80106d2a:	e9 1f f5 ff ff       	jmp    8010624e <alltraps>

80106d2f <vector121>:
.globl vector121
vector121:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $121
80106d31:	6a 79                	push   $0x79
  jmp alltraps
80106d33:	e9 16 f5 ff ff       	jmp    8010624e <alltraps>

80106d38 <vector122>:
.globl vector122
vector122:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $122
80106d3a:	6a 7a                	push   $0x7a
  jmp alltraps
80106d3c:	e9 0d f5 ff ff       	jmp    8010624e <alltraps>

80106d41 <vector123>:
.globl vector123
vector123:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $123
80106d43:	6a 7b                	push   $0x7b
  jmp alltraps
80106d45:	e9 04 f5 ff ff       	jmp    8010624e <alltraps>

80106d4a <vector124>:
.globl vector124
vector124:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $124
80106d4c:	6a 7c                	push   $0x7c
  jmp alltraps
80106d4e:	e9 fb f4 ff ff       	jmp    8010624e <alltraps>

80106d53 <vector125>:
.globl vector125
vector125:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $125
80106d55:	6a 7d                	push   $0x7d
  jmp alltraps
80106d57:	e9 f2 f4 ff ff       	jmp    8010624e <alltraps>

80106d5c <vector126>:
.globl vector126
vector126:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $126
80106d5e:	6a 7e                	push   $0x7e
  jmp alltraps
80106d60:	e9 e9 f4 ff ff       	jmp    8010624e <alltraps>

80106d65 <vector127>:
.globl vector127
vector127:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $127
80106d67:	6a 7f                	push   $0x7f
  jmp alltraps
80106d69:	e9 e0 f4 ff ff       	jmp    8010624e <alltraps>

80106d6e <vector128>:
.globl vector128
vector128:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $128
80106d70:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106d75:	e9 d4 f4 ff ff       	jmp    8010624e <alltraps>

80106d7a <vector129>:
.globl vector129
vector129:
  pushl $0
80106d7a:	6a 00                	push   $0x0
  pushl $129
80106d7c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106d81:	e9 c8 f4 ff ff       	jmp    8010624e <alltraps>

80106d86 <vector130>:
.globl vector130
vector130:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $130
80106d88:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106d8d:	e9 bc f4 ff ff       	jmp    8010624e <alltraps>

80106d92 <vector131>:
.globl vector131
vector131:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $131
80106d94:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106d99:	e9 b0 f4 ff ff       	jmp    8010624e <alltraps>

80106d9e <vector132>:
.globl vector132
vector132:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $132
80106da0:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106da5:	e9 a4 f4 ff ff       	jmp    8010624e <alltraps>

80106daa <vector133>:
.globl vector133
vector133:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $133
80106dac:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106db1:	e9 98 f4 ff ff       	jmp    8010624e <alltraps>

80106db6 <vector134>:
.globl vector134
vector134:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $134
80106db8:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106dbd:	e9 8c f4 ff ff       	jmp    8010624e <alltraps>

80106dc2 <vector135>:
.globl vector135
vector135:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $135
80106dc4:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106dc9:	e9 80 f4 ff ff       	jmp    8010624e <alltraps>

80106dce <vector136>:
.globl vector136
vector136:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $136
80106dd0:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106dd5:	e9 74 f4 ff ff       	jmp    8010624e <alltraps>

80106dda <vector137>:
.globl vector137
vector137:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $137
80106ddc:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106de1:	e9 68 f4 ff ff       	jmp    8010624e <alltraps>

80106de6 <vector138>:
.globl vector138
vector138:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $138
80106de8:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ded:	e9 5c f4 ff ff       	jmp    8010624e <alltraps>

80106df2 <vector139>:
.globl vector139
vector139:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $139
80106df4:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106df9:	e9 50 f4 ff ff       	jmp    8010624e <alltraps>

80106dfe <vector140>:
.globl vector140
vector140:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $140
80106e00:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e05:	e9 44 f4 ff ff       	jmp    8010624e <alltraps>

80106e0a <vector141>:
.globl vector141
vector141:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $141
80106e0c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e11:	e9 38 f4 ff ff       	jmp    8010624e <alltraps>

80106e16 <vector142>:
.globl vector142
vector142:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $142
80106e18:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e1d:	e9 2c f4 ff ff       	jmp    8010624e <alltraps>

80106e22 <vector143>:
.globl vector143
vector143:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $143
80106e24:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106e29:	e9 20 f4 ff ff       	jmp    8010624e <alltraps>

80106e2e <vector144>:
.globl vector144
vector144:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $144
80106e30:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106e35:	e9 14 f4 ff ff       	jmp    8010624e <alltraps>

80106e3a <vector145>:
.globl vector145
vector145:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $145
80106e3c:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106e41:	e9 08 f4 ff ff       	jmp    8010624e <alltraps>

80106e46 <vector146>:
.globl vector146
vector146:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $146
80106e48:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106e4d:	e9 fc f3 ff ff       	jmp    8010624e <alltraps>

80106e52 <vector147>:
.globl vector147
vector147:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $147
80106e54:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106e59:	e9 f0 f3 ff ff       	jmp    8010624e <alltraps>

80106e5e <vector148>:
.globl vector148
vector148:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $148
80106e60:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106e65:	e9 e4 f3 ff ff       	jmp    8010624e <alltraps>

80106e6a <vector149>:
.globl vector149
vector149:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $149
80106e6c:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106e71:	e9 d8 f3 ff ff       	jmp    8010624e <alltraps>

80106e76 <vector150>:
.globl vector150
vector150:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $150
80106e78:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106e7d:	e9 cc f3 ff ff       	jmp    8010624e <alltraps>

80106e82 <vector151>:
.globl vector151
vector151:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $151
80106e84:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106e89:	e9 c0 f3 ff ff       	jmp    8010624e <alltraps>

80106e8e <vector152>:
.globl vector152
vector152:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $152
80106e90:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106e95:	e9 b4 f3 ff ff       	jmp    8010624e <alltraps>

80106e9a <vector153>:
.globl vector153
vector153:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $153
80106e9c:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106ea1:	e9 a8 f3 ff ff       	jmp    8010624e <alltraps>

80106ea6 <vector154>:
.globl vector154
vector154:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $154
80106ea8:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ead:	e9 9c f3 ff ff       	jmp    8010624e <alltraps>

80106eb2 <vector155>:
.globl vector155
vector155:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $155
80106eb4:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106eb9:	e9 90 f3 ff ff       	jmp    8010624e <alltraps>

80106ebe <vector156>:
.globl vector156
vector156:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $156
80106ec0:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ec5:	e9 84 f3 ff ff       	jmp    8010624e <alltraps>

80106eca <vector157>:
.globl vector157
vector157:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $157
80106ecc:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106ed1:	e9 78 f3 ff ff       	jmp    8010624e <alltraps>

80106ed6 <vector158>:
.globl vector158
vector158:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $158
80106ed8:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106edd:	e9 6c f3 ff ff       	jmp    8010624e <alltraps>

80106ee2 <vector159>:
.globl vector159
vector159:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $159
80106ee4:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ee9:	e9 60 f3 ff ff       	jmp    8010624e <alltraps>

80106eee <vector160>:
.globl vector160
vector160:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $160
80106ef0:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106ef5:	e9 54 f3 ff ff       	jmp    8010624e <alltraps>

80106efa <vector161>:
.globl vector161
vector161:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $161
80106efc:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f01:	e9 48 f3 ff ff       	jmp    8010624e <alltraps>

80106f06 <vector162>:
.globl vector162
vector162:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $162
80106f08:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f0d:	e9 3c f3 ff ff       	jmp    8010624e <alltraps>

80106f12 <vector163>:
.globl vector163
vector163:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $163
80106f14:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f19:	e9 30 f3 ff ff       	jmp    8010624e <alltraps>

80106f1e <vector164>:
.globl vector164
vector164:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $164
80106f20:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106f25:	e9 24 f3 ff ff       	jmp    8010624e <alltraps>

80106f2a <vector165>:
.globl vector165
vector165:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $165
80106f2c:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106f31:	e9 18 f3 ff ff       	jmp    8010624e <alltraps>

80106f36 <vector166>:
.globl vector166
vector166:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $166
80106f38:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106f3d:	e9 0c f3 ff ff       	jmp    8010624e <alltraps>

80106f42 <vector167>:
.globl vector167
vector167:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $167
80106f44:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106f49:	e9 00 f3 ff ff       	jmp    8010624e <alltraps>

80106f4e <vector168>:
.globl vector168
vector168:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $168
80106f50:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106f55:	e9 f4 f2 ff ff       	jmp    8010624e <alltraps>

80106f5a <vector169>:
.globl vector169
vector169:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $169
80106f5c:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106f61:	e9 e8 f2 ff ff       	jmp    8010624e <alltraps>

80106f66 <vector170>:
.globl vector170
vector170:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $170
80106f68:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106f6d:	e9 dc f2 ff ff       	jmp    8010624e <alltraps>

80106f72 <vector171>:
.globl vector171
vector171:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $171
80106f74:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106f79:	e9 d0 f2 ff ff       	jmp    8010624e <alltraps>

80106f7e <vector172>:
.globl vector172
vector172:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $172
80106f80:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106f85:	e9 c4 f2 ff ff       	jmp    8010624e <alltraps>

80106f8a <vector173>:
.globl vector173
vector173:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $173
80106f8c:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106f91:	e9 b8 f2 ff ff       	jmp    8010624e <alltraps>

80106f96 <vector174>:
.globl vector174
vector174:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $174
80106f98:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106f9d:	e9 ac f2 ff ff       	jmp    8010624e <alltraps>

80106fa2 <vector175>:
.globl vector175
vector175:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $175
80106fa4:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106fa9:	e9 a0 f2 ff ff       	jmp    8010624e <alltraps>

80106fae <vector176>:
.globl vector176
vector176:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $176
80106fb0:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106fb5:	e9 94 f2 ff ff       	jmp    8010624e <alltraps>

80106fba <vector177>:
.globl vector177
vector177:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $177
80106fbc:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106fc1:	e9 88 f2 ff ff       	jmp    8010624e <alltraps>

80106fc6 <vector178>:
.globl vector178
vector178:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $178
80106fc8:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106fcd:	e9 7c f2 ff ff       	jmp    8010624e <alltraps>

80106fd2 <vector179>:
.globl vector179
vector179:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $179
80106fd4:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106fd9:	e9 70 f2 ff ff       	jmp    8010624e <alltraps>

80106fde <vector180>:
.globl vector180
vector180:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $180
80106fe0:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106fe5:	e9 64 f2 ff ff       	jmp    8010624e <alltraps>

80106fea <vector181>:
.globl vector181
vector181:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $181
80106fec:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106ff1:	e9 58 f2 ff ff       	jmp    8010624e <alltraps>

80106ff6 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $182
80106ff8:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ffd:	e9 4c f2 ff ff       	jmp    8010624e <alltraps>

80107002 <vector183>:
.globl vector183
vector183:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $183
80107004:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107009:	e9 40 f2 ff ff       	jmp    8010624e <alltraps>

8010700e <vector184>:
.globl vector184
vector184:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $184
80107010:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107015:	e9 34 f2 ff ff       	jmp    8010624e <alltraps>

8010701a <vector185>:
.globl vector185
vector185:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $185
8010701c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107021:	e9 28 f2 ff ff       	jmp    8010624e <alltraps>

80107026 <vector186>:
.globl vector186
vector186:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $186
80107028:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010702d:	e9 1c f2 ff ff       	jmp    8010624e <alltraps>

80107032 <vector187>:
.globl vector187
vector187:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $187
80107034:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107039:	e9 10 f2 ff ff       	jmp    8010624e <alltraps>

8010703e <vector188>:
.globl vector188
vector188:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $188
80107040:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107045:	e9 04 f2 ff ff       	jmp    8010624e <alltraps>

8010704a <vector189>:
.globl vector189
vector189:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $189
8010704c:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107051:	e9 f8 f1 ff ff       	jmp    8010624e <alltraps>

80107056 <vector190>:
.globl vector190
vector190:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $190
80107058:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010705d:	e9 ec f1 ff ff       	jmp    8010624e <alltraps>

80107062 <vector191>:
.globl vector191
vector191:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $191
80107064:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107069:	e9 e0 f1 ff ff       	jmp    8010624e <alltraps>

8010706e <vector192>:
.globl vector192
vector192:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $192
80107070:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107075:	e9 d4 f1 ff ff       	jmp    8010624e <alltraps>

8010707a <vector193>:
.globl vector193
vector193:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $193
8010707c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107081:	e9 c8 f1 ff ff       	jmp    8010624e <alltraps>

80107086 <vector194>:
.globl vector194
vector194:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $194
80107088:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010708d:	e9 bc f1 ff ff       	jmp    8010624e <alltraps>

80107092 <vector195>:
.globl vector195
vector195:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $195
80107094:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107099:	e9 b0 f1 ff ff       	jmp    8010624e <alltraps>

8010709e <vector196>:
.globl vector196
vector196:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $196
801070a0:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801070a5:	e9 a4 f1 ff ff       	jmp    8010624e <alltraps>

801070aa <vector197>:
.globl vector197
vector197:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $197
801070ac:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801070b1:	e9 98 f1 ff ff       	jmp    8010624e <alltraps>

801070b6 <vector198>:
.globl vector198
vector198:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $198
801070b8:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801070bd:	e9 8c f1 ff ff       	jmp    8010624e <alltraps>

801070c2 <vector199>:
.globl vector199
vector199:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $199
801070c4:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801070c9:	e9 80 f1 ff ff       	jmp    8010624e <alltraps>

801070ce <vector200>:
.globl vector200
vector200:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $200
801070d0:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801070d5:	e9 74 f1 ff ff       	jmp    8010624e <alltraps>

801070da <vector201>:
.globl vector201
vector201:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $201
801070dc:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801070e1:	e9 68 f1 ff ff       	jmp    8010624e <alltraps>

801070e6 <vector202>:
.globl vector202
vector202:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $202
801070e8:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801070ed:	e9 5c f1 ff ff       	jmp    8010624e <alltraps>

801070f2 <vector203>:
.globl vector203
vector203:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $203
801070f4:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801070f9:	e9 50 f1 ff ff       	jmp    8010624e <alltraps>

801070fe <vector204>:
.globl vector204
vector204:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $204
80107100:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107105:	e9 44 f1 ff ff       	jmp    8010624e <alltraps>

8010710a <vector205>:
.globl vector205
vector205:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $205
8010710c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107111:	e9 38 f1 ff ff       	jmp    8010624e <alltraps>

80107116 <vector206>:
.globl vector206
vector206:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $206
80107118:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010711d:	e9 2c f1 ff ff       	jmp    8010624e <alltraps>

80107122 <vector207>:
.globl vector207
vector207:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $207
80107124:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107129:	e9 20 f1 ff ff       	jmp    8010624e <alltraps>

8010712e <vector208>:
.globl vector208
vector208:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $208
80107130:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107135:	e9 14 f1 ff ff       	jmp    8010624e <alltraps>

8010713a <vector209>:
.globl vector209
vector209:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $209
8010713c:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107141:	e9 08 f1 ff ff       	jmp    8010624e <alltraps>

80107146 <vector210>:
.globl vector210
vector210:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $210
80107148:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010714d:	e9 fc f0 ff ff       	jmp    8010624e <alltraps>

80107152 <vector211>:
.globl vector211
vector211:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $211
80107154:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107159:	e9 f0 f0 ff ff       	jmp    8010624e <alltraps>

8010715e <vector212>:
.globl vector212
vector212:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $212
80107160:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107165:	e9 e4 f0 ff ff       	jmp    8010624e <alltraps>

8010716a <vector213>:
.globl vector213
vector213:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $213
8010716c:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107171:	e9 d8 f0 ff ff       	jmp    8010624e <alltraps>

80107176 <vector214>:
.globl vector214
vector214:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $214
80107178:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010717d:	e9 cc f0 ff ff       	jmp    8010624e <alltraps>

80107182 <vector215>:
.globl vector215
vector215:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $215
80107184:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107189:	e9 c0 f0 ff ff       	jmp    8010624e <alltraps>

8010718e <vector216>:
.globl vector216
vector216:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $216
80107190:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107195:	e9 b4 f0 ff ff       	jmp    8010624e <alltraps>

8010719a <vector217>:
.globl vector217
vector217:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $217
8010719c:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801071a1:	e9 a8 f0 ff ff       	jmp    8010624e <alltraps>

801071a6 <vector218>:
.globl vector218
vector218:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $218
801071a8:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801071ad:	e9 9c f0 ff ff       	jmp    8010624e <alltraps>

801071b2 <vector219>:
.globl vector219
vector219:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $219
801071b4:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801071b9:	e9 90 f0 ff ff       	jmp    8010624e <alltraps>

801071be <vector220>:
.globl vector220
vector220:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $220
801071c0:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801071c5:	e9 84 f0 ff ff       	jmp    8010624e <alltraps>

801071ca <vector221>:
.globl vector221
vector221:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $221
801071cc:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801071d1:	e9 78 f0 ff ff       	jmp    8010624e <alltraps>

801071d6 <vector222>:
.globl vector222
vector222:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $222
801071d8:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801071dd:	e9 6c f0 ff ff       	jmp    8010624e <alltraps>

801071e2 <vector223>:
.globl vector223
vector223:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $223
801071e4:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801071e9:	e9 60 f0 ff ff       	jmp    8010624e <alltraps>

801071ee <vector224>:
.globl vector224
vector224:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $224
801071f0:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801071f5:	e9 54 f0 ff ff       	jmp    8010624e <alltraps>

801071fa <vector225>:
.globl vector225
vector225:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $225
801071fc:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107201:	e9 48 f0 ff ff       	jmp    8010624e <alltraps>

80107206 <vector226>:
.globl vector226
vector226:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $226
80107208:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010720d:	e9 3c f0 ff ff       	jmp    8010624e <alltraps>

80107212 <vector227>:
.globl vector227
vector227:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $227
80107214:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107219:	e9 30 f0 ff ff       	jmp    8010624e <alltraps>

8010721e <vector228>:
.globl vector228
vector228:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $228
80107220:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107225:	e9 24 f0 ff ff       	jmp    8010624e <alltraps>

8010722a <vector229>:
.globl vector229
vector229:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $229
8010722c:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107231:	e9 18 f0 ff ff       	jmp    8010624e <alltraps>

80107236 <vector230>:
.globl vector230
vector230:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $230
80107238:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010723d:	e9 0c f0 ff ff       	jmp    8010624e <alltraps>

80107242 <vector231>:
.globl vector231
vector231:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $231
80107244:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107249:	e9 00 f0 ff ff       	jmp    8010624e <alltraps>

8010724e <vector232>:
.globl vector232
vector232:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $232
80107250:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107255:	e9 f4 ef ff ff       	jmp    8010624e <alltraps>

8010725a <vector233>:
.globl vector233
vector233:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $233
8010725c:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107261:	e9 e8 ef ff ff       	jmp    8010624e <alltraps>

80107266 <vector234>:
.globl vector234
vector234:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $234
80107268:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010726d:	e9 dc ef ff ff       	jmp    8010624e <alltraps>

80107272 <vector235>:
.globl vector235
vector235:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $235
80107274:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107279:	e9 d0 ef ff ff       	jmp    8010624e <alltraps>

8010727e <vector236>:
.globl vector236
vector236:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $236
80107280:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107285:	e9 c4 ef ff ff       	jmp    8010624e <alltraps>

8010728a <vector237>:
.globl vector237
vector237:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $237
8010728c:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107291:	e9 b8 ef ff ff       	jmp    8010624e <alltraps>

80107296 <vector238>:
.globl vector238
vector238:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $238
80107298:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010729d:	e9 ac ef ff ff       	jmp    8010624e <alltraps>

801072a2 <vector239>:
.globl vector239
vector239:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $239
801072a4:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801072a9:	e9 a0 ef ff ff       	jmp    8010624e <alltraps>

801072ae <vector240>:
.globl vector240
vector240:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $240
801072b0:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801072b5:	e9 94 ef ff ff       	jmp    8010624e <alltraps>

801072ba <vector241>:
.globl vector241
vector241:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $241
801072bc:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801072c1:	e9 88 ef ff ff       	jmp    8010624e <alltraps>

801072c6 <vector242>:
.globl vector242
vector242:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $242
801072c8:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801072cd:	e9 7c ef ff ff       	jmp    8010624e <alltraps>

801072d2 <vector243>:
.globl vector243
vector243:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $243
801072d4:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801072d9:	e9 70 ef ff ff       	jmp    8010624e <alltraps>

801072de <vector244>:
.globl vector244
vector244:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $244
801072e0:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801072e5:	e9 64 ef ff ff       	jmp    8010624e <alltraps>

801072ea <vector245>:
.globl vector245
vector245:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $245
801072ec:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801072f1:	e9 58 ef ff ff       	jmp    8010624e <alltraps>

801072f6 <vector246>:
.globl vector246
vector246:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $246
801072f8:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801072fd:	e9 4c ef ff ff       	jmp    8010624e <alltraps>

80107302 <vector247>:
.globl vector247
vector247:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $247
80107304:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107309:	e9 40 ef ff ff       	jmp    8010624e <alltraps>

8010730e <vector248>:
.globl vector248
vector248:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $248
80107310:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107315:	e9 34 ef ff ff       	jmp    8010624e <alltraps>

8010731a <vector249>:
.globl vector249
vector249:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $249
8010731c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107321:	e9 28 ef ff ff       	jmp    8010624e <alltraps>

80107326 <vector250>:
.globl vector250
vector250:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $250
80107328:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010732d:	e9 1c ef ff ff       	jmp    8010624e <alltraps>

80107332 <vector251>:
.globl vector251
vector251:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $251
80107334:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107339:	e9 10 ef ff ff       	jmp    8010624e <alltraps>

8010733e <vector252>:
.globl vector252
vector252:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $252
80107340:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107345:	e9 04 ef ff ff       	jmp    8010624e <alltraps>

8010734a <vector253>:
.globl vector253
vector253:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $253
8010734c:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107351:	e9 f8 ee ff ff       	jmp    8010624e <alltraps>

80107356 <vector254>:
.globl vector254
vector254:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $254
80107358:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010735d:	e9 ec ee ff ff       	jmp    8010624e <alltraps>

80107362 <vector255>:
.globl vector255
vector255:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $255
80107364:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107369:	e9 e0 ee ff ff       	jmp    8010624e <alltraps>

8010736e <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010736e:	55                   	push   %ebp
8010736f:	89 e5                	mov    %esp,%ebp
80107371:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107374:	8b 45 0c             	mov    0xc(%ebp),%eax
80107377:	83 e8 01             	sub    $0x1,%eax
8010737a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010737e:	8b 45 08             	mov    0x8(%ebp),%eax
80107381:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107385:	8b 45 08             	mov    0x8(%ebp),%eax
80107388:	c1 e8 10             	shr    $0x10,%eax
8010738b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010738f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107392:	0f 01 10             	lgdtl  (%eax)
}
80107395:	c9                   	leave  
80107396:	c3                   	ret    

80107397 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107397:	55                   	push   %ebp
80107398:	89 e5                	mov    %esp,%ebp
8010739a:	83 ec 04             	sub    $0x4,%esp
8010739d:	8b 45 08             	mov    0x8(%ebp),%eax
801073a0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801073a4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801073a8:	0f 00 d8             	ltr    %ax
}
801073ab:	c9                   	leave  
801073ac:	c3                   	ret    

801073ad <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801073ad:	55                   	push   %ebp
801073ae:	89 e5                	mov    %esp,%ebp
801073b0:	83 ec 04             	sub    $0x4,%esp
801073b3:	8b 45 08             	mov    0x8(%ebp),%eax
801073b6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801073ba:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801073be:	8e e8                	mov    %eax,%gs
}
801073c0:	c9                   	leave  
801073c1:	c3                   	ret    

801073c2 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801073c2:	55                   	push   %ebp
801073c3:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073c5:	8b 45 08             	mov    0x8(%ebp),%eax
801073c8:	0f 22 d8             	mov    %eax,%cr3
}
801073cb:	5d                   	pop    %ebp
801073cc:	c3                   	ret    

801073cd <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801073cd:	55                   	push   %ebp
801073ce:	89 e5                	mov    %esp,%ebp
801073d0:	8b 45 08             	mov    0x8(%ebp),%eax
801073d3:	05 00 00 00 80       	add    $0x80000000,%eax
801073d8:	5d                   	pop    %ebp
801073d9:	c3                   	ret    

801073da <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801073da:	55                   	push   %ebp
801073db:	89 e5                	mov    %esp,%ebp
801073dd:	8b 45 08             	mov    0x8(%ebp),%eax
801073e0:	05 00 00 00 80       	add    $0x80000000,%eax
801073e5:	5d                   	pop    %ebp
801073e6:	c3                   	ret    

801073e7 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801073e7:	55                   	push   %ebp
801073e8:	89 e5                	mov    %esp,%ebp
801073ea:	53                   	push   %ebx
801073eb:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801073ee:	e8 5b ba ff ff       	call   80102e4e <cpunum>
801073f3:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801073f9:	05 20 f9 10 80       	add    $0x8010f920,%eax
801073fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107404:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010740a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010740d:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107416:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010741a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107421:	83 e2 f0             	and    $0xfffffff0,%edx
80107424:	83 ca 0a             	or     $0xa,%edx
80107427:	88 50 7d             	mov    %dl,0x7d(%eax)
8010742a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107431:	83 ca 10             	or     $0x10,%edx
80107434:	88 50 7d             	mov    %dl,0x7d(%eax)
80107437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010743a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010743e:	83 e2 9f             	and    $0xffffff9f,%edx
80107441:	88 50 7d             	mov    %dl,0x7d(%eax)
80107444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107447:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010744b:	83 ca 80             	or     $0xffffff80,%edx
8010744e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107451:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107454:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107458:	83 ca 0f             	or     $0xf,%edx
8010745b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010745e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107461:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107465:	83 e2 ef             	and    $0xffffffef,%edx
80107468:	88 50 7e             	mov    %dl,0x7e(%eax)
8010746b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010746e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107472:	83 e2 df             	and    $0xffffffdf,%edx
80107475:	88 50 7e             	mov    %dl,0x7e(%eax)
80107478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010747f:	83 ca 40             	or     $0x40,%edx
80107482:	88 50 7e             	mov    %dl,0x7e(%eax)
80107485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107488:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010748c:	83 ca 80             	or     $0xffffff80,%edx
8010748f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107495:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107499:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801074a3:	ff ff 
801074a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a8:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801074af:	00 00 
801074b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b4:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801074bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074be:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801074c5:	83 e2 f0             	and    $0xfffffff0,%edx
801074c8:	83 ca 02             	or     $0x2,%edx
801074cb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801074db:	83 ca 10             	or     $0x10,%edx
801074de:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e7:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801074ee:	83 e2 9f             	and    $0xffffff9f,%edx
801074f1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074fa:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107501:	83 ca 80             	or     $0xffffff80,%edx
80107504:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010750a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107514:	83 ca 0f             	or     $0xf,%edx
80107517:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010751d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107520:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107527:	83 e2 ef             	and    $0xffffffef,%edx
8010752a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107533:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010753a:	83 e2 df             	and    $0xffffffdf,%edx
8010753d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107546:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010754d:	83 ca 40             	or     $0x40,%edx
80107550:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107559:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107560:	83 ca 80             	or     $0xffffff80,%edx
80107563:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107569:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107576:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010757d:	ff ff 
8010757f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107582:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107589:	00 00 
8010758b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107598:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010759f:	83 e2 f0             	and    $0xfffffff0,%edx
801075a2:	83 ca 0a             	or     $0xa,%edx
801075a5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ae:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801075b5:	83 ca 10             	or     $0x10,%edx
801075b8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c1:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801075c8:	83 ca 60             	or     $0x60,%edx
801075cb:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801075db:	83 ca 80             	or     $0xffffff80,%edx
801075de:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801075ee:	83 ca 0f             	or     $0xf,%edx
801075f1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801075f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fa:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107601:	83 e2 ef             	and    $0xffffffef,%edx
80107604:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010760a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107614:	83 e2 df             	and    $0xffffffdf,%edx
80107617:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010761d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107620:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107627:	83 ca 40             	or     $0x40,%edx
8010762a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107633:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010763a:	83 ca 80             	or     $0xffffff80,%edx
8010763d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107646:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010764d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107650:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107657:	ff ff 
80107659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107663:	00 00 
80107665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107668:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010766f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107672:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107679:	83 e2 f0             	and    $0xfffffff0,%edx
8010767c:	83 ca 02             	or     $0x2,%edx
8010767f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107688:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010768f:	83 ca 10             	or     $0x10,%edx
80107692:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801076a2:	83 ca 60             	or     $0x60,%edx
801076a5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ae:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801076b5:	83 ca 80             	or     $0xffffff80,%edx
801076b8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801076c8:	83 ca 0f             	or     $0xf,%edx
801076cb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801076db:	83 e2 ef             	and    $0xffffffef,%edx
801076de:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801076ee:	83 e2 df             	and    $0xffffffdf,%edx
801076f1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fa:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107701:	83 ca 40             	or     $0x40,%edx
80107704:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010770a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010770d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107714:	83 ca 80             	or     $0xffffff80,%edx
80107717:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010771d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107720:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772a:	05 b4 00 00 00       	add    $0xb4,%eax
8010772f:	89 c3                	mov    %eax,%ebx
80107731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107734:	05 b4 00 00 00       	add    $0xb4,%eax
80107739:	c1 e8 10             	shr    $0x10,%eax
8010773c:	89 c1                	mov    %eax,%ecx
8010773e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107741:	05 b4 00 00 00       	add    $0xb4,%eax
80107746:	c1 e8 18             	shr    $0x18,%eax
80107749:	89 c2                	mov    %eax,%edx
8010774b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774e:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107755:	00 00 
80107757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775a:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107761:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107764:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
8010776a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010776d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107774:	83 e1 f0             	and    $0xfffffff0,%ecx
80107777:	83 c9 02             	or     $0x2,%ecx
8010777a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107783:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010778a:	83 c9 10             	or     $0x10,%ecx
8010778d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107796:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010779d:	83 e1 9f             	and    $0xffffff9f,%ecx
801077a0:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801077a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a9:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801077b0:	83 c9 80             	or     $0xffffff80,%ecx
801077b3:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801077b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bc:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801077c3:	83 e1 f0             	and    $0xfffffff0,%ecx
801077c6:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cf:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801077d6:	83 e1 ef             	and    $0xffffffef,%ecx
801077d9:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e2:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801077e9:	83 e1 df             	and    $0xffffffdf,%ecx
801077ec:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f5:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801077fc:	83 c9 40             	or     $0x40,%ecx
801077ff:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107808:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010780f:	83 c9 80             	or     $0xffffff80,%ecx
80107812:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781b:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107824:	83 c0 70             	add    $0x70,%eax
80107827:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
8010782e:	00 
8010782f:	89 04 24             	mov    %eax,(%esp)
80107832:	e8 37 fb ff ff       	call   8010736e <lgdt>
  loadgs(SEG_KCPU << 3);
80107837:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
8010783e:	e8 6a fb ff ff       	call   801073ad <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107846:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010784c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107853:	00 00 00 00 
}
80107857:	83 c4 24             	add    $0x24,%esp
8010785a:	5b                   	pop    %ebx
8010785b:	5d                   	pop    %ebp
8010785c:	c3                   	ret    

8010785d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010785d:	55                   	push   %ebp
8010785e:	89 e5                	mov    %esp,%ebp
80107860:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107863:	8b 45 0c             	mov    0xc(%ebp),%eax
80107866:	c1 e8 16             	shr    $0x16,%eax
80107869:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107870:	8b 45 08             	mov    0x8(%ebp),%eax
80107873:	01 d0                	add    %edx,%eax
80107875:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107878:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010787b:	8b 00                	mov    (%eax),%eax
8010787d:	83 e0 01             	and    $0x1,%eax
80107880:	85 c0                	test   %eax,%eax
80107882:	74 17                	je     8010789b <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107887:	8b 00                	mov    (%eax),%eax
80107889:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010788e:	89 04 24             	mov    %eax,(%esp)
80107891:	e8 44 fb ff ff       	call   801073da <p2v>
80107896:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107899:	eb 4b                	jmp    801078e6 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010789b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010789f:	74 0e                	je     801078af <walkpgdir+0x52>
801078a1:	e8 2f b2 ff ff       	call   80102ad5 <kalloc>
801078a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801078a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801078ad:	75 07                	jne    801078b6 <walkpgdir+0x59>
      return 0;
801078af:	b8 00 00 00 00       	mov    $0x0,%eax
801078b4:	eb 47                	jmp    801078fd <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801078b6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801078bd:	00 
801078be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801078c5:	00 
801078c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c9:	89 04 24             	mov    %eax,(%esp)
801078cc:	e8 67 d5 ff ff       	call   80104e38 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801078d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d4:	89 04 24             	mov    %eax,(%esp)
801078d7:	e8 f1 fa ff ff       	call   801073cd <v2p>
801078dc:	83 c8 07             	or     $0x7,%eax
801078df:	89 c2                	mov    %eax,%edx
801078e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078e4:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801078e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801078e9:	c1 e8 0c             	shr    $0xc,%eax
801078ec:	25 ff 03 00 00       	and    $0x3ff,%eax
801078f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801078f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fb:	01 d0                	add    %edx,%eax
}
801078fd:	c9                   	leave  
801078fe:	c3                   	ret    

801078ff <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801078ff:	55                   	push   %ebp
80107900:	89 e5                	mov    %esp,%ebp
80107902:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107905:	8b 45 0c             	mov    0xc(%ebp),%eax
80107908:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010790d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107910:	8b 55 0c             	mov    0xc(%ebp),%edx
80107913:	8b 45 10             	mov    0x10(%ebp),%eax
80107916:	01 d0                	add    %edx,%eax
80107918:	83 e8 01             	sub    $0x1,%eax
8010791b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107920:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107923:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010792a:	00 
8010792b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107932:	8b 45 08             	mov    0x8(%ebp),%eax
80107935:	89 04 24             	mov    %eax,(%esp)
80107938:	e8 20 ff ff ff       	call   8010785d <walkpgdir>
8010793d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107940:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107944:	75 07                	jne    8010794d <mappages+0x4e>
      return -1;
80107946:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010794b:	eb 48                	jmp    80107995 <mappages+0x96>
    if(*pte & PTE_P)
8010794d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107950:	8b 00                	mov    (%eax),%eax
80107952:	83 e0 01             	and    $0x1,%eax
80107955:	85 c0                	test   %eax,%eax
80107957:	74 0c                	je     80107965 <mappages+0x66>
      panic("remap");
80107959:	c7 04 24 94 87 10 80 	movl   $0x80108794,(%esp)
80107960:	e8 d5 8b ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107965:	8b 45 18             	mov    0x18(%ebp),%eax
80107968:	0b 45 14             	or     0x14(%ebp),%eax
8010796b:	83 c8 01             	or     $0x1,%eax
8010796e:	89 c2                	mov    %eax,%edx
80107970:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107973:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107978:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010797b:	75 08                	jne    80107985 <mappages+0x86>
      break;
8010797d:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010797e:	b8 00 00 00 00       	mov    $0x0,%eax
80107983:	eb 10                	jmp    80107995 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107985:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010798c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107993:	eb 8e                	jmp    80107923 <mappages+0x24>
  return 0;
}
80107995:	c9                   	leave  
80107996:	c3                   	ret    

80107997 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
80107997:	55                   	push   %ebp
80107998:	89 e5                	mov    %esp,%ebp
8010799a:	53                   	push   %ebx
8010799b:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010799e:	e8 32 b1 ff ff       	call   80102ad5 <kalloc>
801079a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079aa:	75 0a                	jne    801079b6 <setupkvm+0x1f>
    return 0;
801079ac:	b8 00 00 00 00       	mov    $0x0,%eax
801079b1:	e9 98 00 00 00       	jmp    80107a4e <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801079b6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801079bd:	00 
801079be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801079c5:	00 
801079c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079c9:	89 04 24             	mov    %eax,(%esp)
801079cc:	e8 67 d4 ff ff       	call   80104e38 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801079d1:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801079d8:	e8 fd f9 ff ff       	call   801073da <p2v>
801079dd:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801079e2:	76 0c                	jbe    801079f0 <setupkvm+0x59>
    panic("PHYSTOP too high");
801079e4:	c7 04 24 9a 87 10 80 	movl   $0x8010879a,(%esp)
801079eb:	e8 4a 8b ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079f0:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
801079f7:	eb 49                	jmp    80107a42 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801079f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079fc:	8b 48 0c             	mov    0xc(%eax),%ecx
801079ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a02:	8b 50 04             	mov    0x4(%eax),%edx
80107a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a08:	8b 58 08             	mov    0x8(%eax),%ebx
80107a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0e:	8b 40 04             	mov    0x4(%eax),%eax
80107a11:	29 c3                	sub    %eax,%ebx
80107a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a16:	8b 00                	mov    (%eax),%eax
80107a18:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107a1c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107a20:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107a24:	89 44 24 04          	mov    %eax,0x4(%esp)
80107a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a2b:	89 04 24             	mov    %eax,(%esp)
80107a2e:	e8 cc fe ff ff       	call   801078ff <mappages>
80107a33:	85 c0                	test   %eax,%eax
80107a35:	79 07                	jns    80107a3e <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107a37:	b8 00 00 00 00       	mov    $0x0,%eax
80107a3c:	eb 10                	jmp    80107a4e <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a3e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107a42:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107a49:	72 ae                	jb     801079f9 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107a4e:	83 c4 34             	add    $0x34,%esp
80107a51:	5b                   	pop    %ebx
80107a52:	5d                   	pop    %ebp
80107a53:	c3                   	ret    

80107a54 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107a54:	55                   	push   %ebp
80107a55:	89 e5                	mov    %esp,%ebp
80107a57:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107a5a:	e8 38 ff ff ff       	call   80107997 <setupkvm>
80107a5f:	a3 f8 29 11 80       	mov    %eax,0x801129f8
  switchkvm();
80107a64:	e8 02 00 00 00       	call   80107a6b <switchkvm>
}
80107a69:	c9                   	leave  
80107a6a:	c3                   	ret    

80107a6b <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107a6b:	55                   	push   %ebp
80107a6c:	89 e5                	mov    %esp,%ebp
80107a6e:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107a71:	a1 f8 29 11 80       	mov    0x801129f8,%eax
80107a76:	89 04 24             	mov    %eax,(%esp)
80107a79:	e8 4f f9 ff ff       	call   801073cd <v2p>
80107a7e:	89 04 24             	mov    %eax,(%esp)
80107a81:	e8 3c f9 ff ff       	call   801073c2 <lcr3>
}
80107a86:	c9                   	leave  
80107a87:	c3                   	ret    

80107a88 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107a88:	55                   	push   %ebp
80107a89:	89 e5                	mov    %esp,%ebp
80107a8b:	53                   	push   %ebx
80107a8c:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107a8f:	e8 a4 d2 ff ff       	call   80104d38 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107a94:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107a9a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107aa1:	83 c2 08             	add    $0x8,%edx
80107aa4:	89 d3                	mov    %edx,%ebx
80107aa6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107aad:	83 c2 08             	add    $0x8,%edx
80107ab0:	c1 ea 10             	shr    $0x10,%edx
80107ab3:	89 d1                	mov    %edx,%ecx
80107ab5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107abc:	83 c2 08             	add    $0x8,%edx
80107abf:	c1 ea 18             	shr    $0x18,%edx
80107ac2:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107ac9:	67 00 
80107acb:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107ad2:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107ad8:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107adf:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ae2:	83 c9 09             	or     $0x9,%ecx
80107ae5:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107aeb:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107af2:	83 c9 10             	or     $0x10,%ecx
80107af5:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107afb:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b02:	83 e1 9f             	and    $0xffffff9f,%ecx
80107b05:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107b0b:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b12:	83 c9 80             	or     $0xffffff80,%ecx
80107b15:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107b1b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b22:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b25:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b2b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b32:	83 e1 ef             	and    $0xffffffef,%ecx
80107b35:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b3b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b42:	83 e1 df             	and    $0xffffffdf,%ecx
80107b45:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b4b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b52:	83 c9 40             	or     $0x40,%ecx
80107b55:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b5b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b62:	83 e1 7f             	and    $0x7f,%ecx
80107b65:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b6b:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107b71:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b77:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107b7e:	83 e2 ef             	and    $0xffffffef,%edx
80107b81:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107b87:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b8d:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107b93:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b99:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107ba0:	8b 52 08             	mov    0x8(%edx),%edx
80107ba3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107ba9:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107bac:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107bb3:	e8 df f7 ff ff       	call   80107397 <ltr>
  if(p->pgdir == 0)
80107bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80107bbb:	8b 40 04             	mov    0x4(%eax),%eax
80107bbe:	85 c0                	test   %eax,%eax
80107bc0:	75 0c                	jne    80107bce <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107bc2:	c7 04 24 ab 87 10 80 	movl   $0x801087ab,(%esp)
80107bc9:	e8 6c 89 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107bce:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd1:	8b 40 04             	mov    0x4(%eax),%eax
80107bd4:	89 04 24             	mov    %eax,(%esp)
80107bd7:	e8 f1 f7 ff ff       	call   801073cd <v2p>
80107bdc:	89 04 24             	mov    %eax,(%esp)
80107bdf:	e8 de f7 ff ff       	call   801073c2 <lcr3>
  popcli();
80107be4:	e8 93 d1 ff ff       	call   80104d7c <popcli>
}
80107be9:	83 c4 14             	add    $0x14,%esp
80107bec:	5b                   	pop    %ebx
80107bed:	5d                   	pop    %ebp
80107bee:	c3                   	ret    

80107bef <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107bef:	55                   	push   %ebp
80107bf0:	89 e5                	mov    %esp,%ebp
80107bf2:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107bf5:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107bfc:	76 0c                	jbe    80107c0a <inituvm+0x1b>
    panic("inituvm: more than a page");
80107bfe:	c7 04 24 bf 87 10 80 	movl   $0x801087bf,(%esp)
80107c05:	e8 30 89 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107c0a:	e8 c6 ae ff ff       	call   80102ad5 <kalloc>
80107c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107c12:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c19:	00 
80107c1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c21:	00 
80107c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c25:	89 04 24             	mov    %eax,(%esp)
80107c28:	e8 0b d2 ff ff       	call   80104e38 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c30:	89 04 24             	mov    %eax,(%esp)
80107c33:	e8 95 f7 ff ff       	call   801073cd <v2p>
80107c38:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107c3f:	00 
80107c40:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107c44:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c4b:	00 
80107c4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c53:	00 
80107c54:	8b 45 08             	mov    0x8(%ebp),%eax
80107c57:	89 04 24             	mov    %eax,(%esp)
80107c5a:	e8 a0 fc ff ff       	call   801078ff <mappages>
  memmove(mem, init, sz);
80107c5f:	8b 45 10             	mov    0x10(%ebp),%eax
80107c62:	89 44 24 08          	mov    %eax,0x8(%esp)
80107c66:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c69:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c70:	89 04 24             	mov    %eax,(%esp)
80107c73:	e8 8f d2 ff ff       	call   80104f07 <memmove>
}
80107c78:	c9                   	leave  
80107c79:	c3                   	ret    

80107c7a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107c7a:	55                   	push   %ebp
80107c7b:	89 e5                	mov    %esp,%ebp
80107c7d:	53                   	push   %ebx
80107c7e:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107c81:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c84:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c89:	85 c0                	test   %eax,%eax
80107c8b:	74 0c                	je     80107c99 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107c8d:	c7 04 24 dc 87 10 80 	movl   $0x801087dc,(%esp)
80107c94:	e8 a1 88 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107c99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ca0:	e9 a9 00 00 00       	jmp    80107d4e <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cab:	01 d0                	add    %edx,%eax
80107cad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107cb4:	00 
80107cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80107cbc:	89 04 24             	mov    %eax,(%esp)
80107cbf:	e8 99 fb ff ff       	call   8010785d <walkpgdir>
80107cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107cc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ccb:	75 0c                	jne    80107cd9 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107ccd:	c7 04 24 ff 87 10 80 	movl   $0x801087ff,(%esp)
80107cd4:	e8 61 88 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cdc:	8b 00                	mov    (%eax),%eax
80107cde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ce3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce9:	8b 55 18             	mov    0x18(%ebp),%edx
80107cec:	29 c2                	sub    %eax,%edx
80107cee:	89 d0                	mov    %edx,%eax
80107cf0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107cf5:	77 0f                	ja     80107d06 <loaduvm+0x8c>
      n = sz - i;
80107cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cfa:	8b 55 18             	mov    0x18(%ebp),%edx
80107cfd:	29 c2                	sub    %eax,%edx
80107cff:	89 d0                	mov    %edx,%eax
80107d01:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d04:	eb 07                	jmp    80107d0d <loaduvm+0x93>
    else
      n = PGSIZE;
80107d06:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d10:	8b 55 14             	mov    0x14(%ebp),%edx
80107d13:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d19:	89 04 24             	mov    %eax,(%esp)
80107d1c:	e8 b9 f6 ff ff       	call   801073da <p2v>
80107d21:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107d24:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d30:	8b 45 10             	mov    0x10(%ebp),%eax
80107d33:	89 04 24             	mov    %eax,(%esp)
80107d36:	e8 20 a0 ff ff       	call   80101d5b <readi>
80107d3b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d3e:	74 07                	je     80107d47 <loaduvm+0xcd>
      return -1;
80107d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d45:	eb 18                	jmp    80107d5f <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107d47:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d51:	3b 45 18             	cmp    0x18(%ebp),%eax
80107d54:	0f 82 4b ff ff ff    	jb     80107ca5 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d5f:	83 c4 24             	add    $0x24,%esp
80107d62:	5b                   	pop    %ebx
80107d63:	5d                   	pop    %ebp
80107d64:	c3                   	ret    

80107d65 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d65:	55                   	push   %ebp
80107d66:	89 e5                	mov    %esp,%ebp
80107d68:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107d6b:	8b 45 10             	mov    0x10(%ebp),%eax
80107d6e:	85 c0                	test   %eax,%eax
80107d70:	79 0a                	jns    80107d7c <allocuvm+0x17>
    return 0;
80107d72:	b8 00 00 00 00       	mov    $0x0,%eax
80107d77:	e9 c1 00 00 00       	jmp    80107e3d <allocuvm+0xd8>
  if(newsz < oldsz)
80107d7c:	8b 45 10             	mov    0x10(%ebp),%eax
80107d7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d82:	73 08                	jae    80107d8c <allocuvm+0x27>
    return oldsz;
80107d84:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d87:	e9 b1 00 00 00       	jmp    80107e3d <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d8f:	05 ff 0f 00 00       	add    $0xfff,%eax
80107d94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107d9c:	e9 8d 00 00 00       	jmp    80107e2e <allocuvm+0xc9>
    mem = kalloc();
80107da1:	e8 2f ad ff ff       	call   80102ad5 <kalloc>
80107da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107da9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107dad:	75 2c                	jne    80107ddb <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107daf:	c7 04 24 1d 88 10 80 	movl   $0x8010881d,(%esp)
80107db6:	e8 e5 85 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dbe:	89 44 24 08          	mov    %eax,0x8(%esp)
80107dc2:	8b 45 10             	mov    0x10(%ebp),%eax
80107dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80107dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80107dcc:	89 04 24             	mov    %eax,(%esp)
80107dcf:	e8 6b 00 00 00       	call   80107e3f <deallocuvm>
      return 0;
80107dd4:	b8 00 00 00 00       	mov    $0x0,%eax
80107dd9:	eb 62                	jmp    80107e3d <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107ddb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107de2:	00 
80107de3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107dea:	00 
80107deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dee:	89 04 24             	mov    %eax,(%esp)
80107df1:	e8 42 d0 ff ff       	call   80104e38 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107df9:	89 04 24             	mov    %eax,(%esp)
80107dfc:	e8 cc f5 ff ff       	call   801073cd <v2p>
80107e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e04:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107e0b:	00 
80107e0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107e10:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e17:	00 
80107e18:	89 54 24 04          	mov    %edx,0x4(%esp)
80107e1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107e1f:	89 04 24             	mov    %eax,(%esp)
80107e22:	e8 d8 fa ff ff       	call   801078ff <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107e27:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e31:	3b 45 10             	cmp    0x10(%ebp),%eax
80107e34:	0f 82 67 ff ff ff    	jb     80107da1 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107e3a:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e3d:	c9                   	leave  
80107e3e:	c3                   	ret    

80107e3f <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e3f:	55                   	push   %ebp
80107e40:	89 e5                	mov    %esp,%ebp
80107e42:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107e45:	8b 45 10             	mov    0x10(%ebp),%eax
80107e48:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e4b:	72 08                	jb     80107e55 <deallocuvm+0x16>
    return oldsz;
80107e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e50:	e9 a4 00 00 00       	jmp    80107ef9 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107e55:	8b 45 10             	mov    0x10(%ebp),%eax
80107e58:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107e65:	e9 80 00 00 00       	jmp    80107eea <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e74:	00 
80107e75:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e79:	8b 45 08             	mov    0x8(%ebp),%eax
80107e7c:	89 04 24             	mov    %eax,(%esp)
80107e7f:	e8 d9 f9 ff ff       	call   8010785d <walkpgdir>
80107e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107e87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e8b:	75 09                	jne    80107e96 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107e8d:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107e94:	eb 4d                	jmp    80107ee3 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e99:	8b 00                	mov    (%eax),%eax
80107e9b:	83 e0 01             	and    $0x1,%eax
80107e9e:	85 c0                	test   %eax,%eax
80107ea0:	74 41                	je     80107ee3 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ea5:	8b 00                	mov    (%eax),%eax
80107ea7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eac:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107eaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107eb3:	75 0c                	jne    80107ec1 <deallocuvm+0x82>
        panic("kfree");
80107eb5:	c7 04 24 35 88 10 80 	movl   $0x80108835,(%esp)
80107ebc:	e8 79 86 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80107ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ec4:	89 04 24             	mov    %eax,(%esp)
80107ec7:	e8 0e f5 ff ff       	call   801073da <p2v>
80107ecc:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ed2:	89 04 24             	mov    %eax,(%esp)
80107ed5:	e8 62 ab ff ff       	call   80102a3c <kfree>
      *pte = 0;
80107eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107edd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107ee3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eed:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ef0:	0f 82 74 ff ff ff    	jb     80107e6a <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107ef6:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107ef9:	c9                   	leave  
80107efa:	c3                   	ret    

80107efb <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107efb:	55                   	push   %ebp
80107efc:	89 e5                	mov    %esp,%ebp
80107efe:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107f01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107f05:	75 0c                	jne    80107f13 <freevm+0x18>
    panic("freevm: no pgdir");
80107f07:	c7 04 24 3b 88 10 80 	movl   $0x8010883b,(%esp)
80107f0e:	e8 27 86 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107f13:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f1a:	00 
80107f1b:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107f22:	80 
80107f23:	8b 45 08             	mov    0x8(%ebp),%eax
80107f26:	89 04 24             	mov    %eax,(%esp)
80107f29:	e8 11 ff ff ff       	call   80107e3f <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107f2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f35:	eb 48                	jmp    80107f7f <freevm+0x84>
    if(pgdir[i] & PTE_P){
80107f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f41:	8b 45 08             	mov    0x8(%ebp),%eax
80107f44:	01 d0                	add    %edx,%eax
80107f46:	8b 00                	mov    (%eax),%eax
80107f48:	83 e0 01             	and    $0x1,%eax
80107f4b:	85 c0                	test   %eax,%eax
80107f4d:	74 2c                	je     80107f7b <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f59:	8b 45 08             	mov    0x8(%ebp),%eax
80107f5c:	01 d0                	add    %edx,%eax
80107f5e:	8b 00                	mov    (%eax),%eax
80107f60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f65:	89 04 24             	mov    %eax,(%esp)
80107f68:	e8 6d f4 ff ff       	call   801073da <p2v>
80107f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f73:	89 04 24             	mov    %eax,(%esp)
80107f76:	e8 c1 aa ff ff       	call   80102a3c <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107f7b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107f7f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107f86:	76 af                	jbe    80107f37 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107f88:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8b:	89 04 24             	mov    %eax,(%esp)
80107f8e:	e8 a9 aa ff ff       	call   80102a3c <kfree>
}
80107f93:	c9                   	leave  
80107f94:	c3                   	ret    

80107f95 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f95:	55                   	push   %ebp
80107f96:	89 e5                	mov    %esp,%ebp
80107f98:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107fa2:	00 
80107fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80107faa:	8b 45 08             	mov    0x8(%ebp),%eax
80107fad:	89 04 24             	mov    %eax,(%esp)
80107fb0:	e8 a8 f8 ff ff       	call   8010785d <walkpgdir>
80107fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107fb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107fbc:	75 0c                	jne    80107fca <clearpteu+0x35>
    panic("clearpteu");
80107fbe:	c7 04 24 4c 88 10 80 	movl   $0x8010884c,(%esp)
80107fc5:	e8 70 85 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80107fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcd:	8b 00                	mov    (%eax),%eax
80107fcf:	83 e0 fb             	and    $0xfffffffb,%eax
80107fd2:	89 c2                	mov    %eax,%edx
80107fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd7:	89 10                	mov    %edx,(%eax)
}
80107fd9:	c9                   	leave  
80107fda:	c3                   	ret    

80107fdb <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107fdb:	55                   	push   %ebp
80107fdc:	89 e5                	mov    %esp,%ebp
80107fde:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
80107fe1:	e8 b1 f9 ff ff       	call   80107997 <setupkvm>
80107fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fe9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fed:	75 0a                	jne    80107ff9 <copyuvm+0x1e>
    return 0;
80107fef:	b8 00 00 00 00       	mov    $0x0,%eax
80107ff4:	e9 f1 00 00 00       	jmp    801080ea <copyuvm+0x10f>
  for(i = 0; i < sz; i += PGSIZE){
80107ff9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108000:	e9 c4 00 00 00       	jmp    801080c9 <copyuvm+0xee>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108008:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010800f:	00 
80108010:	89 44 24 04          	mov    %eax,0x4(%esp)
80108014:	8b 45 08             	mov    0x8(%ebp),%eax
80108017:	89 04 24             	mov    %eax,(%esp)
8010801a:	e8 3e f8 ff ff       	call   8010785d <walkpgdir>
8010801f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108022:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108026:	75 0c                	jne    80108034 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108028:	c7 04 24 56 88 10 80 	movl   $0x80108856,(%esp)
8010802f:	e8 06 85 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108034:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108037:	8b 00                	mov    (%eax),%eax
80108039:	83 e0 01             	and    $0x1,%eax
8010803c:	85 c0                	test   %eax,%eax
8010803e:	75 0c                	jne    8010804c <copyuvm+0x71>
      panic("copyuvm: page not present");
80108040:	c7 04 24 70 88 10 80 	movl   $0x80108870,(%esp)
80108047:	e8 ee 84 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
8010804c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010804f:	8b 00                	mov    (%eax),%eax
80108051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108056:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
80108059:	e8 77 aa ff ff       	call   80102ad5 <kalloc>
8010805e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108061:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108065:	75 02                	jne    80108069 <copyuvm+0x8e>
      goto bad;
80108067:	eb 71                	jmp    801080da <copyuvm+0xff>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108069:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010806c:	89 04 24             	mov    %eax,(%esp)
8010806f:	e8 66 f3 ff ff       	call   801073da <p2v>
80108074:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010807b:	00 
8010807c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108083:	89 04 24             	mov    %eax,(%esp)
80108086:	e8 7c ce ff ff       	call   80104f07 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
8010808b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010808e:	89 04 24             	mov    %eax,(%esp)
80108091:	e8 37 f3 ff ff       	call   801073cd <v2p>
80108096:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108099:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801080a0:	00 
801080a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801080a5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080ac:	00 
801080ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801080b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080b4:	89 04 24             	mov    %eax,(%esp)
801080b7:	e8 43 f8 ff ff       	call   801078ff <mappages>
801080bc:	85 c0                	test   %eax,%eax
801080be:	79 02                	jns    801080c2 <copyuvm+0xe7>
      goto bad;
801080c0:	eb 18                	jmp    801080da <copyuvm+0xff>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801080c2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080cf:	0f 82 30 ff ff ff    	jb     80108005 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
801080d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080d8:	eb 10                	jmp    801080ea <copyuvm+0x10f>

bad:
  freevm(d);
801080da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080dd:	89 04 24             	mov    %eax,(%esp)
801080e0:	e8 16 fe ff ff       	call   80107efb <freevm>
  return 0;
801080e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080ea:	c9                   	leave  
801080eb:	c3                   	ret    

801080ec <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801080ec:	55                   	push   %ebp
801080ed:	89 e5                	mov    %esp,%ebp
801080ef:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080f2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080f9:	00 
801080fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801080fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80108101:	8b 45 08             	mov    0x8(%ebp),%eax
80108104:	89 04 24             	mov    %eax,(%esp)
80108107:	e8 51 f7 ff ff       	call   8010785d <walkpgdir>
8010810c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010810f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108112:	8b 00                	mov    (%eax),%eax
80108114:	83 e0 01             	and    $0x1,%eax
80108117:	85 c0                	test   %eax,%eax
80108119:	75 07                	jne    80108122 <uva2ka+0x36>
    return 0;
8010811b:	b8 00 00 00 00       	mov    $0x0,%eax
80108120:	eb 25                	jmp    80108147 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108125:	8b 00                	mov    (%eax),%eax
80108127:	83 e0 04             	and    $0x4,%eax
8010812a:	85 c0                	test   %eax,%eax
8010812c:	75 07                	jne    80108135 <uva2ka+0x49>
    return 0;
8010812e:	b8 00 00 00 00       	mov    $0x0,%eax
80108133:	eb 12                	jmp    80108147 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108135:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108138:	8b 00                	mov    (%eax),%eax
8010813a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010813f:	89 04 24             	mov    %eax,(%esp)
80108142:	e8 93 f2 ff ff       	call   801073da <p2v>
}
80108147:	c9                   	leave  
80108148:	c3                   	ret    

80108149 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108149:	55                   	push   %ebp
8010814a:	89 e5                	mov    %esp,%ebp
8010814c:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010814f:	8b 45 10             	mov    0x10(%ebp),%eax
80108152:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108155:	e9 87 00 00 00       	jmp    801081e1 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010815a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010815d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108162:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108165:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108168:	89 44 24 04          	mov    %eax,0x4(%esp)
8010816c:	8b 45 08             	mov    0x8(%ebp),%eax
8010816f:	89 04 24             	mov    %eax,(%esp)
80108172:	e8 75 ff ff ff       	call   801080ec <uva2ka>
80108177:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010817a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010817e:	75 07                	jne    80108187 <copyout+0x3e>
      return -1;
80108180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108185:	eb 69                	jmp    801081f0 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108187:	8b 45 0c             	mov    0xc(%ebp),%eax
8010818a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010818d:	29 c2                	sub    %eax,%edx
8010818f:	89 d0                	mov    %edx,%eax
80108191:	05 00 10 00 00       	add    $0x1000,%eax
80108196:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108199:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010819c:	3b 45 14             	cmp    0x14(%ebp),%eax
8010819f:	76 06                	jbe    801081a7 <copyout+0x5e>
      n = len;
801081a1:	8b 45 14             	mov    0x14(%ebp),%eax
801081a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801081a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081aa:	8b 55 0c             	mov    0xc(%ebp),%edx
801081ad:	29 c2                	sub    %eax,%edx
801081af:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081b2:	01 c2                	add    %eax,%edx
801081b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081b7:	89 44 24 08          	mov    %eax,0x8(%esp)
801081bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081be:	89 44 24 04          	mov    %eax,0x4(%esp)
801081c2:	89 14 24             	mov    %edx,(%esp)
801081c5:	e8 3d cd ff ff       	call   80104f07 <memmove>
    len -= n;
801081ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081cd:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801081d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081d3:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801081d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081d9:	05 00 10 00 00       	add    $0x1000,%eax
801081de:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801081e1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801081e5:	0f 85 6f ff ff ff    	jne    8010815a <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801081eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081f0:	c9                   	leave  
801081f1:	c3                   	ret    
