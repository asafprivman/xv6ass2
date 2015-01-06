
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

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
8010003a:	c7 44 24 04 4c 8a 10 	movl   $0x80108a4c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 56 52 00 00       	call   801052a4 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb0
80100055:	eb 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb4
8010005f:	eb 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
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
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 03 52 00 00       	call   801052c5 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
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
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 1e 52 00 00       	call   80105327 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 30 4e 00 00       	call   80104f54 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 b0 eb 10 80       	mov    0x8010ebb0,%eax
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
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 a6 51 00 00       	call   80105327 <release>
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
8010018f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 53 8a 10 80 	movl   $0x80108a53,(%esp)
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
801001ef:	c7 04 24 64 8a 10 80 	movl   $0x80108a64,(%esp)
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
80100229:	c7 04 24 6b 8a 10 80 	movl   $0x80108a6b,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 84 50 00 00       	call   801052c5 <acquire>

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
8010025f:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

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
8010029d:	e8 fc 4d 00 00       	call   8010509e <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 79 50 00 00       	call   80105327 <release>
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
80100340:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
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
801003a6:	a1 f4 c5 10 80       	mov    0x8010c5f4,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
801003bb:	e8 05 4f 00 00       	call   801052c5 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 72 8a 10 80 	movl   $0x80108a72,(%esp)
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
801004b0:	c7 45 ec 7b 8a 10 80 	movl   $0x80108a7b,-0x14(%ebp)
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
8010052c:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100533:	e8 ef 4d 00 00       	call   80105327 <release>
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
80100545:	c7 05 f4 c5 10 80 00 	movl   $0x0,0x8010c5f4
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 82 8a 10 80 	movl   $0x80108a82,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 91 8a 10 80 	movl   $0x80108a91,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 e2 4d 00 00       	call   80105376 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 93 8a 10 80 	movl   $0x80108a93,(%esp)
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
801005be:	c7 05 a0 c5 10 80 01 	movl   $0x1,0x8010c5a0
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
8010066a:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
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
80100693:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 31 4f 00 00       	call   801055e8 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 33 4e 00 00       	call   80105519 <memset>
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
8010073d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
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
80100756:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
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
80100776:	e8 1e 69 00 00       	call   80107099 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 12 69 00 00       	call   80107099 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 06 69 00 00       	call   80107099 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 f9 68 00 00       	call   80107099 <uartputc>
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
801007b3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801007ba:	e8 06 4b 00 00       	call   801052c5 <acquire>
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
801007ea:	e8 85 49 00 00       	call   80105174 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
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
80100810:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100816:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 f4 ed 10 80 	movzbl -0x7fef120c(%eax),%eax
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
8010083a:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100840:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
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
80100876:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
8010087c:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
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
8010089d:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 7c ee 10 80    	mov    %edx,0x8010ee7c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 f4 ed 10 80    	mov    %al,-0x7fef120c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008d5:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008e7:	a3 78 ee 10 80       	mov    %eax,0x8010ee78
          wakeup(&input.r);
801008ec:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
801008f3:	e8 a6 47 00 00       	call   8010509e <wakeup>
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
8010090d:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100914:	e8 0e 4a 00 00       	call   80105327 <release>
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
80100932:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100939:	e8 87 49 00 00       	call   801052c5 <acquire>
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
80100952:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100959:	e8 c9 49 00 00       	call   80105327 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 e5 0e 00 00       	call   8010184e <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 c0 ed 10 	movl   $0x8010edc0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
80100982:	e8 cd 45 00 00       	call   80104f54 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
8010098d:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 74 ee 10 80    	mov    %edx,0x8010ee74
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 f4 ed 10 80 	movzbl -0x7fef120c(%eax),%eax
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
801009c2:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 74 ee 10 80       	mov    %eax,0x8010ee74
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
801009f7:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801009fe:	e8 24 49 00 00       	call   80105327 <release>
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
80100a2b:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100a32:	e8 8e 48 00 00       	call   801052c5 <acquire>
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
80100a65:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100a6c:	e8 b6 48 00 00       	call   80105327 <release>
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
80100a87:	c7 44 24 04 97 8a 10 	movl   $0x80108a97,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100a96:	e8 09 48 00 00       	call   801052a4 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 9f 8a 10 	movl   $0x80108a9f,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100aaa:	e8 f5 47 00 00       	call   801052a4 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 2c f8 10 80 1a 	movl   $0x80100a1a,0x8010f82c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 28 f8 10 80 1b 	movl   $0x8010091b,0x8010f828
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 f4 c5 10 80 01 	movl   $0x1,0x8010c5f4
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 a3 2f 00 00       	call   80103a7c <picenable>
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
80100b70:	e8 7a 76 00 00       	call   801081ef <setupkvm>
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
80100c11:	e8 a7 79 00 00       	call   801085bd <allocuvm>
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
80100c4f:	e8 7e 78 00 00       	call   801084d2 <loaduvm>
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
80100cb8:	e8 00 79 00 00       	call   801085bd <allocuvm>
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
80100cdd:	e8 0b 7b 00 00       	call   801087ed <clearpteu>
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
80100d13:	e8 6b 4a 00 00       	call   80105783 <strlen>
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
80100d3c:	e8 42 4a 00 00       	call   80105783 <strlen>
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
80100d6c:	e8 30 7c 00 00       	call   801089a1 <copyout>
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
80100e13:	e8 89 7b 00 00       	call   801089a1 <copyout>
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
80100e6b:	e8 c9 48 00 00       	call   80105739 <safestrcpy>

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
80100ebd:	e8 1e 74 00 00       	call   801082e0 <switchuvm>
  freevm(oldpgdir);
80100ec2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ec5:	89 04 24             	mov    %eax,(%esp)
80100ec8:	e8 86 78 00 00       	call   80108753 <freevm>
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
80100ee0:	e8 6e 78 00 00       	call   80108753 <freevm>
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
80100f03:	c7 44 24 04 a5 8a 10 	movl   $0x80108aa5,0x4(%esp)
80100f0a:	80 
80100f0b:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f12:	e8 8d 43 00 00       	call   801052a4 <initlock>
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
80100f1f:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f26:	e8 9a 43 00 00       	call   801052c5 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f2b:	c7 45 f4 b4 ee 10 80 	movl   $0x8010eeb4,-0xc(%ebp)
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
80100f48:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f4f:	e8 d3 43 00 00       	call   80105327 <release>
      return f;
80100f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f57:	eb 1e                	jmp    80100f77 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f59:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f5d:	81 7d f4 14 f8 10 80 	cmpl   $0x8010f814,-0xc(%ebp)
80100f64:	72 ce                	jb     80100f34 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f66:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f6d:	e8 b5 43 00 00       	call   80105327 <release>
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
80100f7f:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100f86:	e8 3a 43 00 00       	call   801052c5 <acquire>
  if(f->ref < 1)
80100f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f8e:	8b 40 04             	mov    0x4(%eax),%eax
80100f91:	85 c0                	test   %eax,%eax
80100f93:	7f 0c                	jg     80100fa1 <filedup+0x28>
    panic("filedup");
80100f95:	c7 04 24 ac 8a 10 80 	movl   $0x80108aac,(%esp)
80100f9c:	e8 99 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa4:	8b 40 04             	mov    0x4(%eax),%eax
80100fa7:	8d 50 01             	lea    0x1(%eax),%edx
80100faa:	8b 45 08             	mov    0x8(%ebp),%eax
80100fad:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb0:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fb7:	e8 6b 43 00 00       	call   80105327 <release>
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
80100fc7:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80100fce:	e8 f2 42 00 00       	call   801052c5 <acquire>
  if(f->ref < 1)
80100fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd6:	8b 40 04             	mov    0x4(%eax),%eax
80100fd9:	85 c0                	test   %eax,%eax
80100fdb:	7f 0c                	jg     80100fe9 <fileclose+0x28>
    panic("fileclose");
80100fdd:	c7 04 24 b4 8a 10 80 	movl   $0x80108ab4,(%esp)
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
80101002:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80101009:	e8 19 43 00 00       	call   80105327 <release>
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
8010104c:	c7 04 24 80 ee 10 80 	movl   $0x8010ee80,(%esp)
80101053:	e8 cf 42 00 00       	call   80105327 <release>
  
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
80101071:	e8 b6 2c 00 00       	call   80103d2c <pipeclose>
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
80101122:	e8 86 2d 00 00       	call   80103ead <piperead>
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
80101194:	c7 04 24 be 8a 10 80 	movl   $0x80108abe,(%esp)
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
801011df:	e8 da 2b 00 00       	call   80103dbe <pipewrite>
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
801012a0:	c7 04 24 c7 8a 10 80 	movl   $0x80108ac7,(%esp)
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
801012d2:	c7 04 24 d7 8a 10 80 	movl   $0x80108ad7,(%esp)
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
80101318:	e8 cb 42 00 00       	call   801055e8 <memmove>
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
8010135e:	e8 b6 41 00 00       	call   80105519 <memset>
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
801014bb:	c7 04 24 e1 8a 10 80 	movl   $0x80108ae1,(%esp)
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
8010154d:	c7 04 24 f7 8a 10 80 	movl   $0x80108af7,(%esp)
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
8010159d:	c7 44 24 04 0a 8b 10 	movl   $0x80108b0a,0x4(%esp)
801015a4:	80 
801015a5:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801015ac:	e8 f3 3c 00 00       	call   801052a4 <initlock>
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
8010162e:	e8 e6 3e 00 00       	call   80105519 <memset>
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
80101684:	c7 04 24 11 8b 10 80 	movl   $0x80108b11,(%esp)
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
8010172d:	e8 b6 3e 00 00       	call   801055e8 <memmove>
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
80101750:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101757:	e8 69 3b 00 00       	call   801052c5 <acquire>

  // Is the inode already cached?
  empty = 0;
8010175c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101763:	c7 45 f4 b4 f8 10 80 	movl   $0x8010f8b4,-0xc(%ebp)
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
8010179a:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801017a1:	e8 81 3b 00 00       	call   80105327 <release>
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
801017c5:	81 7d f4 54 08 11 80 	cmpl   $0x80110854,-0xc(%ebp)
801017cc:	72 9e                	jb     8010176c <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017d2:	75 0c                	jne    801017e0 <iget+0x96>
    panic("iget: no inodes");
801017d4:	c7 04 24 23 8b 10 80 	movl   $0x80108b23,(%esp)
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
8010180b:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101812:	e8 10 3b 00 00       	call   80105327 <release>

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
80101822:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101829:	e8 97 3a 00 00       	call   801052c5 <acquire>
  ip->ref++;
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	8b 40 08             	mov    0x8(%eax),%eax
80101834:	8d 50 01             	lea    0x1(%eax),%edx
80101837:	8b 45 08             	mov    0x8(%ebp),%eax
8010183a:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010183d:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101844:	e8 de 3a 00 00       	call   80105327 <release>
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
80101864:	c7 04 24 33 8b 10 80 	movl   $0x80108b33,(%esp)
8010186b:	e8 ca ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101870:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101877:	e8 49 3a 00 00       	call   801052c5 <acquire>
  while(ip->flags & I_BUSY)
8010187c:	eb 13                	jmp    80101891 <ilock+0x43>
    sleep(ip, &icache.lock);
8010187e:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
80101885:	80 
80101886:	8b 45 08             	mov    0x8(%ebp),%eax
80101889:	89 04 24             	mov    %eax,(%esp)
8010188c:	e8 c3 36 00 00       	call   80104f54 <sleep>

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
801018af:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801018b6:	e8 6c 3a 00 00       	call   80105327 <release>

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
80101961:	e8 82 3c 00 00       	call   801055e8 <memmove>
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
8010198e:	c7 04 24 39 8b 10 80 	movl   $0x80108b39,(%esp)
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
801019bf:	c7 04 24 48 8b 10 80 	movl   $0x80108b48,(%esp)
801019c6:	e8 6f eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019cb:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801019d2:	e8 ee 38 00 00       	call   801052c5 <acquire>
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
801019ee:	e8 ab 36 00 00       	call   8010509e <wakeup>
  release(&icache.lock);
801019f3:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801019fa:	e8 28 39 00 00       	call   80105327 <release>
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
80101a07:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a0e:	e8 b2 38 00 00       	call   801052c5 <acquire>
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
80101a4c:	c7 04 24 50 8b 10 80 	movl   $0x80108b50,(%esp)
80101a53:	e8 e2 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5e:	83 c8 01             	or     $0x1,%eax
80101a61:	89 c2                	mov    %eax,%edx
80101a63:	8b 45 08             	mov    0x8(%ebp),%eax
80101a66:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a69:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a70:	e8 b2 38 00 00       	call   80105327 <release>
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
80101a94:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101a9b:	e8 25 38 00 00       	call   801052c5 <acquire>
    ip->flags = 0;
80101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80101aad:	89 04 24             	mov    %eax,(%esp)
80101ab0:	e8 e9 35 00 00       	call   8010509e <wakeup>
  }
  ip->ref--;
80101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab8:	8b 40 08             	mov    0x8(%eax),%eax
80101abb:	8d 50 ff             	lea    -0x1(%eax),%edx
80101abe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac1:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ac4:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80101acb:	e8 57 38 00 00       	call   80105327 <release>
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
80101beb:	c7 04 24 5a 8b 10 80 	movl   $0x80108b5a,(%esp)
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
80101d8f:	8b 04 c5 20 f8 10 80 	mov    -0x7fef07e0(,%eax,8),%eax
80101d96:	85 c0                	test   %eax,%eax
80101d98:	75 0a                	jne    80101da4 <readi+0x49>
      return -1;
80101d9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d9f:	e9 19 01 00 00       	jmp    80101ebd <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dab:	98                   	cwtl   
80101dac:	8b 04 c5 20 f8 10 80 	mov    -0x7fef07e0(,%eax,8),%eax
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
80101e8c:	e8 57 37 00 00       	call   801055e8 <memmove>
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
80101ef3:	8b 04 c5 24 f8 10 80 	mov    -0x7fef07dc(,%eax,8),%eax
80101efa:	85 c0                	test   %eax,%eax
80101efc:	75 0a                	jne    80101f08 <writei+0x49>
      return -1;
80101efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f03:	e9 44 01 00 00       	jmp    8010204c <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f0f:	98                   	cwtl   
80101f10:	8b 04 c5 24 f8 10 80 	mov    -0x7fef07dc(,%eax,8),%eax
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
80101feb:	e8 f8 35 00 00       	call   801055e8 <memmove>
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
80102069:	e8 1d 36 00 00       	call   8010568b <strncmp>
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
80102083:	c7 04 24 6d 8b 10 80 	movl   $0x80108b6d,(%esp)
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
801020c1:	c7 04 24 7f 8b 10 80 	movl   $0x80108b7f,(%esp)
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
801021a6:	c7 04 24 7f 8b 10 80 	movl   $0x80108b7f,(%esp)
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
801021eb:	e8 f1 34 00 00       	call   801056e1 <strncpy>
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
8010221d:	c7 04 24 8c 8b 10 80 	movl   $0x80108b8c,(%esp)
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
801022a2:	e8 41 33 00 00       	call   801055e8 <memmove>
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
801022bd:	e8 26 33 00 00       	call   801055e8 <memmove>
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
8010250c:	c7 44 24 04 94 8b 10 	movl   $0x80108b94,0x4(%esp)
80102513:	80 
80102514:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010251b:	e8 84 2d 00 00       	call   801052a4 <initlock>
  picenable(IRQ_IDE);
80102520:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102527:	e8 50 15 00 00       	call   80103a7c <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010252c:	a1 20 19 11 80       	mov    0x80111920,%eax
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
8010257d:	c7 05 38 c6 10 80 01 	movl   $0x1,0x8010c638
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
801025b8:	c7 04 24 98 8b 10 80 	movl   $0x80108b98,(%esp)
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
801026d7:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
801026de:	e8 e2 2b 00 00       	call   801052c5 <acquire>
  if((b = idequeue) == 0){
801026e3:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801026e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026ef:	75 11                	jne    80102702 <ideintr+0x31>
    release(&idelock);
801026f1:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
801026f8:	e8 2a 2c 00 00       	call   80105327 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801026fd:	e9 90 00 00 00       	jmp    80102792 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102705:	8b 40 14             	mov    0x14(%eax),%eax
80102708:	a3 34 c6 10 80       	mov    %eax,0x8010c634

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
8010276b:	e8 2e 29 00 00       	call   8010509e <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102770:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102775:	85 c0                	test   %eax,%eax
80102777:	74 0d                	je     80102786 <ideintr+0xb5>
    idestart(idequeue);
80102779:	a1 34 c6 10 80       	mov    0x8010c634,%eax
8010277e:	89 04 24             	mov    %eax,(%esp)
80102781:	e8 26 fe ff ff       	call   801025ac <idestart>

  release(&idelock);
80102786:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010278d:	e8 95 2b 00 00       	call   80105327 <release>
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
801027a6:	c7 04 24 a1 8b 10 80 	movl   $0x80108ba1,(%esp)
801027ad:	e8 88 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027b2:	8b 45 08             	mov    0x8(%ebp),%eax
801027b5:	8b 00                	mov    (%eax),%eax
801027b7:	83 e0 06             	and    $0x6,%eax
801027ba:	83 f8 02             	cmp    $0x2,%eax
801027bd:	75 0c                	jne    801027cb <iderw+0x37>
    panic("iderw: nothing to do");
801027bf:	c7 04 24 b5 8b 10 80 	movl   $0x80108bb5,(%esp)
801027c6:	e8 6f dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027cb:	8b 45 08             	mov    0x8(%ebp),%eax
801027ce:	8b 40 04             	mov    0x4(%eax),%eax
801027d1:	85 c0                	test   %eax,%eax
801027d3:	74 15                	je     801027ea <iderw+0x56>
801027d5:	a1 38 c6 10 80       	mov    0x8010c638,%eax
801027da:	85 c0                	test   %eax,%eax
801027dc:	75 0c                	jne    801027ea <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027de:	c7 04 24 ca 8b 10 80 	movl   $0x80108bca,(%esp)
801027e5:	e8 50 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC: acquire-lock
801027ea:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
801027f1:	e8 cf 2a 00 00       	call   801052c5 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027f6:	8b 45 08             	mov    0x8(%ebp),%eax
801027f9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
80102800:	c7 45 f4 34 c6 10 80 	movl   $0x8010c634,-0xc(%ebp)
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
80102825:	a1 34 c6 10 80       	mov    0x8010c634,%eax
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
8010283e:	c7 44 24 04 00 c6 10 	movl   $0x8010c600,0x4(%esp)
80102845:	80 
80102846:	8b 45 08             	mov    0x8(%ebp),%eax
80102849:	89 04 24             	mov    %eax,(%esp)
8010284c:	e8 03 27 00 00       	call   80104f54 <sleep>
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
8010285e:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102865:	e8 bd 2a 00 00       	call   80105327 <release>
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
8010286f:	a1 54 08 11 80       	mov    0x80110854,%eax
80102874:	8b 55 08             	mov    0x8(%ebp),%edx
80102877:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102879:	a1 54 08 11 80       	mov    0x80110854,%eax
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
80102886:	a1 54 08 11 80       	mov    0x80110854,%eax
8010288b:	8b 55 08             	mov    0x8(%ebp),%edx
8010288e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102890:	a1 54 08 11 80       	mov    0x80110854,%eax
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
801028a3:	a1 24 09 11 80       	mov    0x80110924,%eax
801028a8:	85 c0                	test   %eax,%eax
801028aa:	75 05                	jne    801028b1 <ioapicinit+0x14>
    return;
801028ac:	e9 9d 00 00 00       	jmp    8010294e <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028b1:	c7 05 54 08 11 80 00 	movl   $0xfec00000,0x80110854
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
801028e4:	0f b6 05 20 09 11 80 	movzbl 0x80110920,%eax
801028eb:	0f b6 c0             	movzbl %al,%eax
801028ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028f1:	74 0c                	je     801028ff <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028f3:	c7 04 24 e8 8b 10 80 	movl   $0x80108be8,(%esp)
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
80102956:	a1 24 09 11 80       	mov    0x80110924,%eax
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
801029ad:	c7 44 24 04 1a 8c 10 	movl   $0x80108c1a,0x4(%esp)
801029b4:	80 
801029b5:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
801029bc:	e8 e3 28 00 00       	call   801052a4 <initlock>
  kmem.use_lock = 0;
801029c1:	c7 05 94 08 11 80 00 	movl   $0x0,0x80110894
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
801029f7:	c7 05 94 08 11 80 01 	movl   $0x1,0x80110894
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
80102a4e:	81 7d 08 1c 33 15 80 	cmpl   $0x8015331c,0x8(%ebp)
80102a55:	72 12                	jb     80102a69 <kfree+0x2d>
80102a57:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5a:	89 04 24             	mov    %eax,(%esp)
80102a5d:	e8 38 ff ff ff       	call   8010299a <v2p>
80102a62:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a67:	76 0c                	jbe    80102a75 <kfree+0x39>
    panic("kfree");
80102a69:	c7 04 24 1f 8c 10 80 	movl   $0x80108c1f,(%esp)
80102a70:	e8 c5 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a75:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a7c:	00 
80102a7d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a84:	00 
80102a85:	8b 45 08             	mov    0x8(%ebp),%eax
80102a88:	89 04 24             	mov    %eax,(%esp)
80102a8b:	e8 89 2a 00 00       	call   80105519 <memset>

  if(kmem.use_lock)
80102a90:	a1 94 08 11 80       	mov    0x80110894,%eax
80102a95:	85 c0                	test   %eax,%eax
80102a97:	74 0c                	je     80102aa5 <kfree+0x69>
    acquire(&kmem.lock);
80102a99:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102aa0:	e8 20 28 00 00       	call   801052c5 <acquire>
  r = (struct run*)v;
80102aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102aab:	8b 15 98 08 11 80    	mov    0x80110898,%edx
80102ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab4:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab9:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102abe:	a1 94 08 11 80       	mov    0x80110894,%eax
80102ac3:	85 c0                	test   %eax,%eax
80102ac5:	74 0c                	je     80102ad3 <kfree+0x97>
    release(&kmem.lock);
80102ac7:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102ace:	e8 54 28 00 00       	call   80105327 <release>
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
80102adb:	a1 94 08 11 80       	mov    0x80110894,%eax
80102ae0:	85 c0                	test   %eax,%eax
80102ae2:	74 0c                	je     80102af0 <kalloc+0x1b>
    acquire(&kmem.lock);
80102ae4:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102aeb:	e8 d5 27 00 00       	call   801052c5 <acquire>
  r = kmem.freelist;
80102af0:	a1 98 08 11 80       	mov    0x80110898,%eax
80102af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102af8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102afc:	74 0a                	je     80102b08 <kalloc+0x33>
    kmem.freelist = r->next;
80102afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b01:	8b 00                	mov    (%eax),%eax
80102b03:	a3 98 08 11 80       	mov    %eax,0x80110898
  if(kmem.use_lock)
80102b08:	a1 94 08 11 80       	mov    0x80110894,%eax
80102b0d:	85 c0                	test   %eax,%eax
80102b0f:	74 0c                	je     80102b1d <kalloc+0x48>
    release(&kmem.lock);
80102b11:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80102b18:	e8 0a 28 00 00       	call   80105327 <release>
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
80102b86:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102b8b:	83 c8 40             	or     $0x40,%eax
80102b8e:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
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
80102ba9:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
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
80102bc6:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102bcb:	0f b6 00             	movzbl (%eax),%eax
80102bce:	83 c8 40             	or     $0x40,%eax
80102bd1:	0f b6 c0             	movzbl %al,%eax
80102bd4:	f7 d0                	not    %eax
80102bd6:	89 c2                	mov    %eax,%edx
80102bd8:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102bdd:	21 d0                	and    %edx,%eax
80102bdf:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102be4:	b8 00 00 00 00       	mov    $0x0,%eax
80102be9:	e9 a2 00 00 00       	jmp    80102c90 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102bee:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102bf3:	83 e0 40             	and    $0x40,%eax
80102bf6:	85 c0                	test   %eax,%eax
80102bf8:	74 14                	je     80102c0e <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bfa:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c01:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c06:	83 e0 bf             	and    $0xffffffbf,%eax
80102c09:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  }

  shift |= shiftcode[data];
80102c0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c11:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c16:	0f b6 00             	movzbl (%eax),%eax
80102c19:	0f b6 d0             	movzbl %al,%edx
80102c1c:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c21:	09 d0                	or     %edx,%eax
80102c23:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  shift ^= togglecode[data];
80102c28:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c2b:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c30:	0f b6 00             	movzbl (%eax),%eax
80102c33:	0f b6 d0             	movzbl %al,%edx
80102c36:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c3b:	31 d0                	xor    %edx,%eax
80102c3d:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c42:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c47:	83 e0 03             	and    $0x3,%eax
80102c4a:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c54:	01 d0                	add    %edx,%eax
80102c56:	0f b6 00             	movzbl (%eax),%eax
80102c59:	0f b6 c0             	movzbl %al,%eax
80102c5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c5f:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
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
80102cd7:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102cdc:	8b 55 08             	mov    0x8(%ebp),%edx
80102cdf:	c1 e2 02             	shl    $0x2,%edx
80102ce2:	01 c2                	add    %eax,%edx
80102ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ce7:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ce9:	a1 9c 08 11 80       	mov    0x8011089c,%eax
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
80102cfb:	a1 9c 08 11 80       	mov    0x8011089c,%eax
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
80102d81:	a1 9c 08 11 80       	mov    0x8011089c,%eax
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
80102e23:	a1 9c 08 11 80       	mov    0x8011089c,%eax
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
80102e62:	a1 40 c6 10 80       	mov    0x8010c640,%eax
80102e67:	8d 50 01             	lea    0x1(%eax),%edx
80102e6a:	89 15 40 c6 10 80    	mov    %edx,0x8010c640
80102e70:	85 c0                	test   %eax,%eax
80102e72:	75 13                	jne    80102e87 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e74:	8b 45 04             	mov    0x4(%ebp),%eax
80102e77:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e7b:	c7 04 24 28 8c 10 80 	movl   $0x80108c28,(%esp)
80102e82:	e8 19 d5 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e87:	a1 9c 08 11 80       	mov    0x8011089c,%eax
80102e8c:	85 c0                	test   %eax,%eax
80102e8e:	74 0f                	je     80102e9f <cpunum+0x51>
    return lapic[ID]>>24;
80102e90:	a1 9c 08 11 80       	mov    0x8011089c,%eax
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
80102eac:	a1 9c 08 11 80       	mov    0x8011089c,%eax
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
80102fd0:	c7 44 24 04 54 8c 10 	movl   $0x80108c54,0x4(%esp)
80102fd7:	80 
80102fd8:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80102fdf:	e8 c0 22 00 00       	call   801052a4 <initlock>
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
80103001:	a3 d4 08 11 80       	mov    %eax,0x801108d4
  log.size = sb.nlog;
80103006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103009:	a3 d8 08 11 80       	mov    %eax,0x801108d8
  log.dev = ROOTDEV;
8010300e:	c7 05 e0 08 11 80 01 	movl   $0x1,0x801108e0
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
80103031:	8b 15 d4 08 11 80    	mov    0x801108d4,%edx
80103037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010303a:	01 d0                	add    %edx,%eax
8010303c:	83 c0 01             	add    $0x1,%eax
8010303f:	89 c2                	mov    %eax,%edx
80103041:	a1 e0 08 11 80       	mov    0x801108e0,%eax
80103046:	89 54 24 04          	mov    %edx,0x4(%esp)
8010304a:	89 04 24             	mov    %eax,(%esp)
8010304d:	e8 54 d1 ff ff       	call   801001a6 <bread>
80103052:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103058:	83 c0 10             	add    $0x10,%eax
8010305b:	8b 04 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%eax
80103062:	89 c2                	mov    %eax,%edx
80103064:	a1 e0 08 11 80       	mov    0x801108e0,%eax
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
80103093:	e8 50 25 00 00       	call   801055e8 <memmove>
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
801030bd:	a1 e4 08 11 80       	mov    0x801108e4,%eax
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
801030d3:	a1 d4 08 11 80       	mov    0x801108d4,%eax
801030d8:	89 c2                	mov    %eax,%edx
801030da:	a1 e0 08 11 80       	mov    0x801108e0,%eax
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
801030fc:	a3 e4 08 11 80       	mov    %eax,0x801108e4
  for (i = 0; i < log.lh.n; i++) {
80103101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103108:	eb 1b                	jmp    80103125 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010310a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010310d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103110:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103114:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103117:	83 c2 10             	add    $0x10,%edx
8010311a:	89 04 95 a8 08 11 80 	mov    %eax,-0x7feef758(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103121:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103125:	a1 e4 08 11 80       	mov    0x801108e4,%eax
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
80103142:	a1 d4 08 11 80       	mov    0x801108d4,%eax
80103147:	89 c2                	mov    %eax,%edx
80103149:	a1 e0 08 11 80       	mov    0x801108e0,%eax
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
80103166:	8b 15 e4 08 11 80    	mov    0x801108e4,%edx
8010316c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010316f:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103171:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103178:	eb 1b                	jmp    80103195 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
8010317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010317d:	83 c0 10             	add    $0x10,%eax
80103180:	8b 0c 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%ecx
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
80103195:	a1 e4 08 11 80       	mov    0x801108e4,%eax
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
801031c7:	c7 05 e4 08 11 80 00 	movl   $0x0,0x801108e4
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
801031de:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
801031e5:	e8 db 20 00 00       	call   801052c5 <acquire>
  while (log.busy) {
801031ea:	eb 14                	jmp    80103200 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031ec:	c7 44 24 04 a0 08 11 	movl   $0x801108a0,0x4(%esp)
801031f3:	80 
801031f4:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
801031fb:	e8 54 1d 00 00       	call   80104f54 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103200:	a1 dc 08 11 80       	mov    0x801108dc,%eax
80103205:	85 c0                	test   %eax,%eax
80103207:	75 e3                	jne    801031ec <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103209:	c7 05 dc 08 11 80 01 	movl   $0x1,0x801108dc
80103210:	00 00 00 
  release(&log.lock);
80103213:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
8010321a:	e8 08 21 00 00       	call   80105327 <release>
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
80103227:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010322c:	85 c0                	test   %eax,%eax
8010322e:	7e 19                	jle    80103249 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103230:	e8 07 ff ff ff       	call   8010313c <write_head>
    install_trans(); // Now install writes to home locations
80103235:	e8 e5 fd ff ff       	call   8010301f <install_trans>
    log.lh.n = 0; 
8010323a:	c7 05 e4 08 11 80 00 	movl   $0x0,0x801108e4
80103241:	00 00 00 
    write_head();    // Erase the transaction from the log
80103244:	e8 f3 fe ff ff       	call   8010313c <write_head>
  }
  
  acquire(&log.lock);
80103249:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103250:	e8 70 20 00 00       	call   801052c5 <acquire>
  log.busy = 0;
80103255:	c7 05 dc 08 11 80 00 	movl   $0x0,0x801108dc
8010325c:	00 00 00 
  wakeup(&log);
8010325f:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103266:	e8 33 1e 00 00       	call   8010509e <wakeup>
  release(&log.lock);
8010326b:	c7 04 24 a0 08 11 80 	movl   $0x801108a0,(%esp)
80103272:	e8 b0 20 00 00       	call   80105327 <release>
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
8010327f:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103284:	83 f8 09             	cmp    $0x9,%eax
80103287:	7f 12                	jg     8010329b <log_write+0x22>
80103289:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010328e:	8b 15 d8 08 11 80    	mov    0x801108d8,%edx
80103294:	83 ea 01             	sub    $0x1,%edx
80103297:	39 d0                	cmp    %edx,%eax
80103299:	7c 0c                	jl     801032a7 <log_write+0x2e>
    panic("too big a transaction");
8010329b:	c7 04 24 58 8c 10 80 	movl   $0x80108c58,(%esp)
801032a2:	e8 93 d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032a7:	a1 dc 08 11 80       	mov    0x801108dc,%eax
801032ac:	85 c0                	test   %eax,%eax
801032ae:	75 0c                	jne    801032bc <log_write+0x43>
    panic("write outside of trans");
801032b0:	c7 04 24 6e 8c 10 80 	movl   $0x80108c6e,(%esp)
801032b7:	e8 7e d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801032bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032c3:	eb 1f                	jmp    801032e4 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c8:	83 c0 10             	add    $0x10,%eax
801032cb:	8b 04 85 a8 08 11 80 	mov    -0x7feef758(,%eax,4),%eax
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
801032e4:	a1 e4 08 11 80       	mov    0x801108e4,%eax
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
801032fa:	89 04 95 a8 08 11 80 	mov    %eax,-0x7feef758(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103301:	8b 15 d4 08 11 80    	mov    0x801108d4,%edx
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
80103341:	e8 a2 22 00 00       	call   801055e8 <memmove>
  bwrite(lbuf);
80103346:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103349:	89 04 24             	mov    %eax,(%esp)
8010334c:	e8 8c ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103354:	89 04 24             	mov    %eax,(%esp)
80103357:	e8 bb ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
8010335c:	a1 e4 08 11 80       	mov    0x801108e4,%eax
80103361:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103364:	75 0d                	jne    80103373 <log_write+0xfa>
    log.lh.n++;
80103366:	a1 e4 08 11 80       	mov    0x801108e4,%eax
8010336b:	83 c0 01             	add    $0x1,%eax
8010336e:	a3 e4 08 11 80       	mov    %eax,0x801108e4
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
801033c9:	c7 04 24 1c 33 15 80 	movl   $0x8015331c,(%esp)
801033d0:	e8 d2 f5 ff ff       	call   801029a7 <kinit1>
  kvmalloc();      // kernel page table
801033d5:	e8 d2 4e 00 00       	call   801082ac <kvmalloc>
  mpinit();        // collect info about this machine
801033da:	e8 62 04 00 00       	call   80103841 <mpinit>
  lapicinit(mpbcpu());
801033df:	e8 2b 02 00 00       	call   8010360f <mpbcpu>
801033e4:	89 04 24             	mov    %eax,(%esp)
801033e7:	e8 09 f9 ff ff       	call   80102cf5 <lapicinit>
  seginit();       // set up segments
801033ec:	e8 49 48 00 00       	call   80107c3a <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033f7:	0f b6 00             	movzbl (%eax),%eax
801033fa:	0f b6 c0             	movzbl %al,%eax
801033fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103401:	c7 04 24 85 8c 10 80 	movl   $0x80108c85,(%esp)
80103408:	e8 93 cf ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
8010340d:	e8 98 06 00 00       	call   80103aaa <picinit>
  ioapicinit();    // another interrupt controller
80103412:	e8 86 f4 ff ff       	call   8010289d <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103417:	e8 65 d6 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
8010341c:	e8 68 3b 00 00       	call   80106f89 <uartinit>
  pinit();         // process table
80103421:	e8 82 0d 00 00       	call   801041a8 <pinit>
  tvinit();        // trap vectors
80103426:	e8 c8 36 00 00       	call   80106af3 <tvinit>
  binit();         // buffer cache
8010342b:	e8 04 cc ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103430:	e8 c8 da ff ff       	call   80100efd <fileinit>
  iinit();         // inode cache
80103435:	e8 5d e1 ff ff       	call   80101597 <iinit>
  ideinit();       // disk
8010343a:	e8 c7 f0 ff ff       	call   80102506 <ideinit>
  if(!ismp)
8010343f:	a1 24 09 11 80       	mov    0x80110924,%eax
80103444:	85 c0                	test   %eax,%eax
80103446:	75 05                	jne    8010344d <main+0x95>
    timerinit();   // uniprocessor timer
80103448:	e8 f1 35 00 00       	call   80106a3e <timerinit>
  startothers();   // start other processors
8010344d:	e8 87 00 00 00       	call   801034d9 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103452:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103459:	8e 
8010345a:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103461:	e8 79 f5 ff ff       	call   801029df <kinit2>
  userinit();      // first user process
80103466:	e8 14 0f 00 00       	call   8010437f <userinit>
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
80103476:	e8 48 4e 00 00       	call   801082c3 <switchkvm>
  seginit();
8010347b:	e8 ba 47 00 00       	call   80107c3a <seginit>
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
801034a8:	c7 04 24 9c 8c 10 80 	movl   $0x80108c9c,(%esp)
801034af:	e8 ec ce ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801034b4:	e8 ae 37 00 00       	call   80106c67 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034b9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034bf:	05 a8 00 00 00       	add    $0xa8,%eax
801034c4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034cb:	00 
801034cc:	89 04 24             	mov    %eax,(%esp)
801034cf:	e8 ca fe ff ff       	call   8010339e <xchg>
  scheduler();     // start running processes
801034d4:	e8 d0 16 00 00       	call   80104ba9 <scheduler>

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
801034f8:	c7 44 24 04 0c c5 10 	movl   $0x8010c50c,0x4(%esp)
801034ff:	80 
80103500:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103503:	89 04 24             	mov    %eax,(%esp)
80103506:	e8 dd 20 00 00       	call   801055e8 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010350b:	c7 45 f4 40 09 11 80 	movl   $0x80110940,-0xc(%ebp)
80103512:	e9 8b 00 00 00       	jmp    801035a2 <startothers+0xc9>
    if(c == cpus+cpunum())  // We've started already.
80103517:	e8 32 f9 ff ff       	call   80102e4e <cpunum>
8010351c:	c1 e0 02             	shl    $0x2,%eax
8010351f:	89 c2                	mov    %eax,%edx
80103521:	c1 e2 07             	shl    $0x7,%edx
80103524:	29 c2                	sub    %eax,%edx
80103526:	89 d0                	mov    %edx,%eax
80103528:	05 40 09 11 80       	add    $0x80110940,%eax
8010352d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103530:	75 02                	jne    80103534 <startothers+0x5b>
      continue;
80103532:	eb 67                	jmp    8010359b <startothers+0xc2>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103534:	e8 9c f5 ff ff       	call   80102ad5 <kalloc>
80103539:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010353f:	83 e8 04             	sub    $0x4,%eax
80103542:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103545:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010354b:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103550:	83 e8 08             	sub    $0x8,%eax
80103553:	c7 00 70 34 10 80    	movl   $0x80103470,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103559:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010355c:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010355f:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103566:	e8 19 fe ff ff       	call   80103384 <v2p>
8010356b:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010356d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103570:	89 04 24             	mov    %eax,(%esp)
80103573:	e8 0c fe ff ff       	call   80103384 <v2p>
80103578:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010357b:	0f b6 12             	movzbl (%edx),%edx
8010357e:	0f b6 d2             	movzbl %dl,%edx
80103581:	89 44 24 04          	mov    %eax,0x4(%esp)
80103585:	89 14 24             	mov    %edx,(%esp)
80103588:	e8 43 f9 ff ff       	call   80102ed0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010358d:	90                   	nop
8010358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103591:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	74 f3                	je     8010358e <startothers+0xb5>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010359b:	81 45 f4 fc 01 00 00 	addl   $0x1fc,-0xc(%ebp)
801035a2:	a1 20 19 11 80       	mov    0x80111920,%eax
801035a7:	c1 e0 02             	shl    $0x2,%eax
801035aa:	89 c2                	mov    %eax,%edx
801035ac:	c1 e2 07             	shl    $0x7,%edx
801035af:	29 c2                	sub    %eax,%edx
801035b1:	89 d0                	mov    %edx,%eax
801035b3:	05 40 09 11 80       	add    $0x80110940,%eax
801035b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035bb:	0f 87 56 ff ff ff    	ja     80103517 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035c1:	83 c4 24             	add    $0x24,%esp
801035c4:	5b                   	pop    %ebx
801035c5:	5d                   	pop    %ebp
801035c6:	c3                   	ret    

801035c7 <p2v>:
801035c7:	55                   	push   %ebp
801035c8:	89 e5                	mov    %esp,%ebp
801035ca:	8b 45 08             	mov    0x8(%ebp),%eax
801035cd:	05 00 00 00 80       	add    $0x80000000,%eax
801035d2:	5d                   	pop    %ebp
801035d3:	c3                   	ret    

801035d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035d4:	55                   	push   %ebp
801035d5:	89 e5                	mov    %esp,%ebp
801035d7:	83 ec 14             	sub    $0x14,%esp
801035da:	8b 45 08             	mov    0x8(%ebp),%eax
801035dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801035e5:	89 c2                	mov    %eax,%edx
801035e7:	ec                   	in     (%dx),%al
801035e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801035eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801035ef:	c9                   	leave  
801035f0:	c3                   	ret    

801035f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801035f1:	55                   	push   %ebp
801035f2:	89 e5                	mov    %esp,%ebp
801035f4:	83 ec 08             	sub    $0x8,%esp
801035f7:	8b 55 08             	mov    0x8(%ebp),%edx
801035fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801035fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103601:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103604:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103608:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010360c:	ee                   	out    %al,(%dx)
}
8010360d:	c9                   	leave  
8010360e:	c3                   	ret    

8010360f <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010360f:	55                   	push   %ebp
80103610:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103612:	a1 44 c6 10 80       	mov    0x8010c644,%eax
80103617:	89 c2                	mov    %eax,%edx
80103619:	b8 40 09 11 80       	mov    $0x80110940,%eax
8010361e:	29 c2                	sub    %eax,%edx
80103620:	89 d0                	mov    %edx,%eax
80103622:	c1 f8 02             	sar    $0x2,%eax
80103625:	69 c0 7f bf df ef    	imul   $0xefdfbf7f,%eax,%eax
}
8010362b:	5d                   	pop    %ebp
8010362c:	c3                   	ret    

8010362d <sum>:

static uchar
sum(uchar *addr, int len)
{
8010362d:	55                   	push   %ebp
8010362e:	89 e5                	mov    %esp,%ebp
80103630:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103633:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010363a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103641:	eb 15                	jmp    80103658 <sum+0x2b>
    sum += addr[i];
80103643:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103646:	8b 45 08             	mov    0x8(%ebp),%eax
80103649:	01 d0                	add    %edx,%eax
8010364b:	0f b6 00             	movzbl (%eax),%eax
8010364e:	0f b6 c0             	movzbl %al,%eax
80103651:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103654:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103658:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010365b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010365e:	7c e3                	jl     80103643 <sum+0x16>
    sum += addr[i];
  return sum;
80103660:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103663:	c9                   	leave  
80103664:	c3                   	ret    

80103665 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103665:	55                   	push   %ebp
80103666:	89 e5                	mov    %esp,%ebp
80103668:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010366b:	8b 45 08             	mov    0x8(%ebp),%eax
8010366e:	89 04 24             	mov    %eax,(%esp)
80103671:	e8 51 ff ff ff       	call   801035c7 <p2v>
80103676:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103679:	8b 55 0c             	mov    0xc(%ebp),%edx
8010367c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010367f:	01 d0                	add    %edx,%eax
80103681:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103684:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103687:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010368a:	eb 3f                	jmp    801036cb <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010368c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103693:	00 
80103694:	c7 44 24 04 b0 8c 10 	movl   $0x80108cb0,0x4(%esp)
8010369b:	80 
8010369c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010369f:	89 04 24             	mov    %eax,(%esp)
801036a2:	e8 e9 1e 00 00       	call   80105590 <memcmp>
801036a7:	85 c0                	test   %eax,%eax
801036a9:	75 1c                	jne    801036c7 <mpsearch1+0x62>
801036ab:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036b2:	00 
801036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036b6:	89 04 24             	mov    %eax,(%esp)
801036b9:	e8 6f ff ff ff       	call   8010362d <sum>
801036be:	84 c0                	test   %al,%al
801036c0:	75 05                	jne    801036c7 <mpsearch1+0x62>
      return (struct mp*)p;
801036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036c5:	eb 11                	jmp    801036d8 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801036c7:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801036cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036d1:	72 b9                	jb     8010368c <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801036d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801036d8:	c9                   	leave  
801036d9:	c3                   	ret    

801036da <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801036da:	55                   	push   %ebp
801036db:	89 e5                	mov    %esp,%ebp
801036dd:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036e0:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ea:	83 c0 0f             	add    $0xf,%eax
801036ed:	0f b6 00             	movzbl (%eax),%eax
801036f0:	0f b6 c0             	movzbl %al,%eax
801036f3:	c1 e0 08             	shl    $0x8,%eax
801036f6:	89 c2                	mov    %eax,%edx
801036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036fb:	83 c0 0e             	add    $0xe,%eax
801036fe:	0f b6 00             	movzbl (%eax),%eax
80103701:	0f b6 c0             	movzbl %al,%eax
80103704:	09 d0                	or     %edx,%eax
80103706:	c1 e0 04             	shl    $0x4,%eax
80103709:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010370c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103710:	74 21                	je     80103733 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103712:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103719:	00 
8010371a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010371d:	89 04 24             	mov    %eax,(%esp)
80103720:	e8 40 ff ff ff       	call   80103665 <mpsearch1>
80103725:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103728:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010372c:	74 50                	je     8010377e <mpsearch+0xa4>
      return mp;
8010372e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103731:	eb 5f                	jmp    80103792 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103736:	83 c0 14             	add    $0x14,%eax
80103739:	0f b6 00             	movzbl (%eax),%eax
8010373c:	0f b6 c0             	movzbl %al,%eax
8010373f:	c1 e0 08             	shl    $0x8,%eax
80103742:	89 c2                	mov    %eax,%edx
80103744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103747:	83 c0 13             	add    $0x13,%eax
8010374a:	0f b6 00             	movzbl (%eax),%eax
8010374d:	0f b6 c0             	movzbl %al,%eax
80103750:	09 d0                	or     %edx,%eax
80103752:	c1 e0 0a             	shl    $0xa,%eax
80103755:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103758:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010375b:	2d 00 04 00 00       	sub    $0x400,%eax
80103760:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103767:	00 
80103768:	89 04 24             	mov    %eax,(%esp)
8010376b:	e8 f5 fe ff ff       	call   80103665 <mpsearch1>
80103770:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103773:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103777:	74 05                	je     8010377e <mpsearch+0xa4>
      return mp;
80103779:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010377c:	eb 14                	jmp    80103792 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
8010377e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103785:	00 
80103786:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
8010378d:	e8 d3 fe ff ff       	call   80103665 <mpsearch1>
}
80103792:	c9                   	leave  
80103793:	c3                   	ret    

80103794 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103794:	55                   	push   %ebp
80103795:	89 e5                	mov    %esp,%ebp
80103797:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010379a:	e8 3b ff ff ff       	call   801036da <mpsearch>
8010379f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037a6:	74 0a                	je     801037b2 <mpconfig+0x1e>
801037a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ab:	8b 40 04             	mov    0x4(%eax),%eax
801037ae:	85 c0                	test   %eax,%eax
801037b0:	75 0a                	jne    801037bc <mpconfig+0x28>
    return 0;
801037b2:	b8 00 00 00 00       	mov    $0x0,%eax
801037b7:	e9 83 00 00 00       	jmp    8010383f <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037bf:	8b 40 04             	mov    0x4(%eax),%eax
801037c2:	89 04 24             	mov    %eax,(%esp)
801037c5:	e8 fd fd ff ff       	call   801035c7 <p2v>
801037ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037cd:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801037d4:	00 
801037d5:	c7 44 24 04 b5 8c 10 	movl   $0x80108cb5,0x4(%esp)
801037dc:	80 
801037dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037e0:	89 04 24             	mov    %eax,(%esp)
801037e3:	e8 a8 1d 00 00       	call   80105590 <memcmp>
801037e8:	85 c0                	test   %eax,%eax
801037ea:	74 07                	je     801037f3 <mpconfig+0x5f>
    return 0;
801037ec:	b8 00 00 00 00       	mov    $0x0,%eax
801037f1:	eb 4c                	jmp    8010383f <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
801037f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037f6:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801037fa:	3c 01                	cmp    $0x1,%al
801037fc:	74 12                	je     80103810 <mpconfig+0x7c>
801037fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103801:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103805:	3c 04                	cmp    $0x4,%al
80103807:	74 07                	je     80103810 <mpconfig+0x7c>
    return 0;
80103809:	b8 00 00 00 00       	mov    $0x0,%eax
8010380e:	eb 2f                	jmp    8010383f <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103810:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103813:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103817:	0f b7 c0             	movzwl %ax,%eax
8010381a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010381e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103821:	89 04 24             	mov    %eax,(%esp)
80103824:	e8 04 fe ff ff       	call   8010362d <sum>
80103829:	84 c0                	test   %al,%al
8010382b:	74 07                	je     80103834 <mpconfig+0xa0>
    return 0;
8010382d:	b8 00 00 00 00       	mov    $0x0,%eax
80103832:	eb 0b                	jmp    8010383f <mpconfig+0xab>
  *pmp = mp;
80103834:	8b 45 08             	mov    0x8(%ebp),%eax
80103837:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010383a:	89 10                	mov    %edx,(%eax)
  return conf;
8010383c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010383f:	c9                   	leave  
80103840:	c3                   	ret    

80103841 <mpinit>:

void
mpinit(void)
{
80103841:	55                   	push   %ebp
80103842:	89 e5                	mov    %esp,%ebp
80103844:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103847:	c7 05 44 c6 10 80 40 	movl   $0x80110940,0x8010c644
8010384e:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103851:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103854:	89 04 24             	mov    %eax,(%esp)
80103857:	e8 38 ff ff ff       	call   80103794 <mpconfig>
8010385c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010385f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103863:	75 05                	jne    8010386a <mpinit+0x29>
    return;
80103865:	e9 a7 01 00 00       	jmp    80103a11 <mpinit+0x1d0>
  ismp = 1;
8010386a:	c7 05 24 09 11 80 01 	movl   $0x1,0x80110924
80103871:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103874:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103877:	8b 40 24             	mov    0x24(%eax),%eax
8010387a:	a3 9c 08 11 80       	mov    %eax,0x8011089c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010387f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103882:	83 c0 2c             	add    $0x2c,%eax
80103885:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103888:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010388b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010388f:	0f b7 d0             	movzwl %ax,%edx
80103892:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103895:	01 d0                	add    %edx,%eax
80103897:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010389a:	e9 ff 00 00 00       	jmp    8010399e <mpinit+0x15d>
    switch(*p){
8010389f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038a2:	0f b6 00             	movzbl (%eax),%eax
801038a5:	0f b6 c0             	movzbl %al,%eax
801038a8:	83 f8 04             	cmp    $0x4,%eax
801038ab:	0f 87 ca 00 00 00    	ja     8010397b <mpinit+0x13a>
801038b1:	8b 04 85 f8 8c 10 80 	mov    -0x7fef7308(,%eax,4),%eax
801038b8:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038c3:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038c7:	0f b6 d0             	movzbl %al,%edx
801038ca:	a1 20 19 11 80       	mov    0x80111920,%eax
801038cf:	39 c2                	cmp    %eax,%edx
801038d1:	74 2d                	je     80103900 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038d6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038da:	0f b6 d0             	movzbl %al,%edx
801038dd:	a1 20 19 11 80       	mov    0x80111920,%eax
801038e2:	89 54 24 08          	mov    %edx,0x8(%esp)
801038e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801038ea:	c7 04 24 ba 8c 10 80 	movl   $0x80108cba,(%esp)
801038f1:	e8 aa ca ff ff       	call   801003a0 <cprintf>
        ismp = 0;
801038f6:	c7 05 24 09 11 80 00 	movl   $0x0,0x80110924
801038fd:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103900:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103903:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103907:	0f b6 c0             	movzbl %al,%eax
8010390a:	83 e0 02             	and    $0x2,%eax
8010390d:	85 c0                	test   %eax,%eax
8010390f:	74 1a                	je     8010392b <mpinit+0xea>
        bcpu = &cpus[ncpu];
80103911:	a1 20 19 11 80       	mov    0x80111920,%eax
80103916:	c1 e0 02             	shl    $0x2,%eax
80103919:	89 c2                	mov    %eax,%edx
8010391b:	c1 e2 07             	shl    $0x7,%edx
8010391e:	29 c2                	sub    %eax,%edx
80103920:	8d 82 40 09 11 80    	lea    -0x7feef6c0(%edx),%eax
80103926:	a3 44 c6 10 80       	mov    %eax,0x8010c644
      cpus[ncpu].id = ncpu;
8010392b:	a1 20 19 11 80       	mov    0x80111920,%eax
80103930:	8b 15 20 19 11 80    	mov    0x80111920,%edx
80103936:	89 d1                	mov    %edx,%ecx
80103938:	c1 e0 02             	shl    $0x2,%eax
8010393b:	89 c2                	mov    %eax,%edx
8010393d:	c1 e2 07             	shl    $0x7,%edx
80103940:	29 c2                	sub    %eax,%edx
80103942:	8d 82 40 09 11 80    	lea    -0x7feef6c0(%edx),%eax
80103948:	88 08                	mov    %cl,(%eax)
      ncpu++;
8010394a:	a1 20 19 11 80       	mov    0x80111920,%eax
8010394f:	83 c0 01             	add    $0x1,%eax
80103952:	a3 20 19 11 80       	mov    %eax,0x80111920
      p += sizeof(struct mpproc);
80103957:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010395b:	eb 41                	jmp    8010399e <mpinit+0x15d>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010395d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103960:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103966:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010396a:	a2 20 09 11 80       	mov    %al,0x80110920
      p += sizeof(struct mpioapic);
8010396f:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103973:	eb 29                	jmp    8010399e <mpinit+0x15d>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103975:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103979:	eb 23                	jmp    8010399e <mpinit+0x15d>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010397b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010397e:	0f b6 00             	movzbl (%eax),%eax
80103981:	0f b6 c0             	movzbl %al,%eax
80103984:	89 44 24 04          	mov    %eax,0x4(%esp)
80103988:	c7 04 24 d8 8c 10 80 	movl   $0x80108cd8,(%esp)
8010398f:	e8 0c ca ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103994:	c7 05 24 09 11 80 00 	movl   $0x0,0x80110924
8010399b:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010399e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039a4:	0f 82 f5 fe ff ff    	jb     8010389f <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039aa:	a1 24 09 11 80       	mov    0x80110924,%eax
801039af:	85 c0                	test   %eax,%eax
801039b1:	75 1d                	jne    801039d0 <mpinit+0x18f>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039b3:	c7 05 20 19 11 80 01 	movl   $0x1,0x80111920
801039ba:	00 00 00 
    lapic = 0;
801039bd:	c7 05 9c 08 11 80 00 	movl   $0x0,0x8011089c
801039c4:	00 00 00 
    ioapicid = 0;
801039c7:	c6 05 20 09 11 80 00 	movb   $0x0,0x80110920
    return;
801039ce:	eb 41                	jmp    80103a11 <mpinit+0x1d0>
  }

  if(mp->imcrp){
801039d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039d3:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801039d7:	84 c0                	test   %al,%al
801039d9:	74 36                	je     80103a11 <mpinit+0x1d0>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801039db:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
801039e2:	00 
801039e3:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801039ea:	e8 02 fc ff ff       	call   801035f1 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039ef:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039f6:	e8 d9 fb ff ff       	call   801035d4 <inb>
801039fb:	83 c8 01             	or     $0x1,%eax
801039fe:	0f b6 c0             	movzbl %al,%eax
80103a01:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a05:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a0c:	e8 e0 fb ff ff       	call   801035f1 <outb>
  }
}
80103a11:	c9                   	leave  
80103a12:	c3                   	ret    

80103a13 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a13:	55                   	push   %ebp
80103a14:	89 e5                	mov    %esp,%ebp
80103a16:	83 ec 08             	sub    $0x8,%esp
80103a19:	8b 55 08             	mov    0x8(%ebp),%edx
80103a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a1f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a23:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a26:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a2a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a2e:	ee                   	out    %al,(%dx)
}
80103a2f:	c9                   	leave  
80103a30:	c3                   	ret    

80103a31 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a31:	55                   	push   %ebp
80103a32:	89 e5                	mov    %esp,%ebp
80103a34:	83 ec 0c             	sub    $0xc,%esp
80103a37:	8b 45 08             	mov    0x8(%ebp),%eax
80103a3a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a3e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a42:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103a48:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a4c:	0f b6 c0             	movzbl %al,%eax
80103a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a53:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a5a:	e8 b4 ff ff ff       	call   80103a13 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a5f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a63:	66 c1 e8 08          	shr    $0x8,%ax
80103a67:	0f b6 c0             	movzbl %al,%eax
80103a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a6e:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a75:	e8 99 ff ff ff       	call   80103a13 <outb>
}
80103a7a:	c9                   	leave  
80103a7b:	c3                   	ret    

80103a7c <picenable>:

void
picenable(int irq)
{
80103a7c:	55                   	push   %ebp
80103a7d:	89 e5                	mov    %esp,%ebp
80103a7f:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103a82:	8b 45 08             	mov    0x8(%ebp),%eax
80103a85:	ba 01 00 00 00       	mov    $0x1,%edx
80103a8a:	89 c1                	mov    %eax,%ecx
80103a8c:	d3 e2                	shl    %cl,%edx
80103a8e:	89 d0                	mov    %edx,%eax
80103a90:	f7 d0                	not    %eax
80103a92:	89 c2                	mov    %eax,%edx
80103a94:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103a9b:	21 d0                	and    %edx,%eax
80103a9d:	0f b7 c0             	movzwl %ax,%eax
80103aa0:	89 04 24             	mov    %eax,(%esp)
80103aa3:	e8 89 ff ff ff       	call   80103a31 <picsetmask>
}
80103aa8:	c9                   	leave  
80103aa9:	c3                   	ret    

80103aaa <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103aaa:	55                   	push   %ebp
80103aab:	89 e5                	mov    %esp,%ebp
80103aad:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ab0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ab7:	00 
80103ab8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103abf:	e8 4f ff ff ff       	call   80103a13 <outb>
  outb(IO_PIC2+1, 0xFF);
80103ac4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103acb:	00 
80103acc:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ad3:	e8 3b ff ff ff       	call   80103a13 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ad8:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103adf:	00 
80103ae0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ae7:	e8 27 ff ff ff       	call   80103a13 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103aec:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103af3:	00 
80103af4:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103afb:	e8 13 ff ff ff       	call   80103a13 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b00:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b07:	00 
80103b08:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b0f:	e8 ff fe ff ff       	call   80103a13 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b14:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b1b:	00 
80103b1c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b23:	e8 eb fe ff ff       	call   80103a13 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b28:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b2f:	00 
80103b30:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b37:	e8 d7 fe ff ff       	call   80103a13 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b3c:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b43:	00 
80103b44:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b4b:	e8 c3 fe ff ff       	call   80103a13 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b50:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b57:	00 
80103b58:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b5f:	e8 af fe ff ff       	call   80103a13 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b64:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b6b:	00 
80103b6c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b73:	e8 9b fe ff ff       	call   80103a13 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b78:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b7f:	00 
80103b80:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b87:	e8 87 fe ff ff       	call   80103a13 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103b8c:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103b93:	00 
80103b94:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b9b:	e8 73 fe ff ff       	call   80103a13 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103ba0:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ba7:	00 
80103ba8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103baf:	e8 5f fe ff ff       	call   80103a13 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bb4:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bbb:	00 
80103bbc:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bc3:	e8 4b fe ff ff       	call   80103a13 <outb>

  if(irqmask != 0xFFFF)
80103bc8:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103bcf:	66 83 f8 ff          	cmp    $0xffff,%ax
80103bd3:	74 12                	je     80103be7 <picinit+0x13d>
    picsetmask(irqmask);
80103bd5:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103bdc:	0f b7 c0             	movzwl %ax,%eax
80103bdf:	89 04 24             	mov    %eax,(%esp)
80103be2:	e8 4a fe ff ff       	call   80103a31 <picsetmask>
}
80103be7:	c9                   	leave  
80103be8:	c3                   	ret    

80103be9 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103be9:	55                   	push   %ebp
80103bea:	89 e5                	mov    %esp,%ebp
80103bec:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103bef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103bff:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c02:	8b 10                	mov    (%eax),%edx
80103c04:	8b 45 08             	mov    0x8(%ebp),%eax
80103c07:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c09:	e8 0b d3 ff ff       	call   80100f19 <filealloc>
80103c0e:	8b 55 08             	mov    0x8(%ebp),%edx
80103c11:	89 02                	mov    %eax,(%edx)
80103c13:	8b 45 08             	mov    0x8(%ebp),%eax
80103c16:	8b 00                	mov    (%eax),%eax
80103c18:	85 c0                	test   %eax,%eax
80103c1a:	0f 84 c8 00 00 00    	je     80103ce8 <pipealloc+0xff>
80103c20:	e8 f4 d2 ff ff       	call   80100f19 <filealloc>
80103c25:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c28:	89 02                	mov    %eax,(%edx)
80103c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c2d:	8b 00                	mov    (%eax),%eax
80103c2f:	85 c0                	test   %eax,%eax
80103c31:	0f 84 b1 00 00 00    	je     80103ce8 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c37:	e8 99 ee ff ff       	call   80102ad5 <kalloc>
80103c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c43:	75 05                	jne    80103c4a <pipealloc+0x61>
    goto bad;
80103c45:	e9 9e 00 00 00       	jmp    80103ce8 <pipealloc+0xff>
  p->readopen = 1;
80103c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c4d:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c54:	00 00 00 
  p->writeopen = 1;
80103c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5a:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c61:	00 00 00 
  p->nwrite = 0;
80103c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c67:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c6e:	00 00 00 
  p->nread = 0;
80103c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c74:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c7b:	00 00 00 
  initlock(&p->lock, "pipe");
80103c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c81:	c7 44 24 04 0c 8d 10 	movl   $0x80108d0c,0x4(%esp)
80103c88:	80 
80103c89:	89 04 24             	mov    %eax,(%esp)
80103c8c:	e8 13 16 00 00       	call   801052a4 <initlock>
  (*f0)->type = FD_PIPE;
80103c91:	8b 45 08             	mov    0x8(%ebp),%eax
80103c94:	8b 00                	mov    (%eax),%eax
80103c96:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c9f:	8b 00                	mov    (%eax),%eax
80103ca1:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca8:	8b 00                	mov    (%eax),%eax
80103caa:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cae:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb1:	8b 00                	mov    (%eax),%eax
80103cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cb6:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cbc:	8b 00                	mov    (%eax),%eax
80103cbe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cc7:	8b 00                	mov    (%eax),%eax
80103cc9:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd0:	8b 00                	mov    (%eax),%eax
80103cd2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd9:	8b 00                	mov    (%eax),%eax
80103cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cde:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ce1:	b8 00 00 00 00       	mov    $0x0,%eax
80103ce6:	eb 42                	jmp    80103d2a <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cec:	74 0b                	je     80103cf9 <pipealloc+0x110>
    kfree((char*)p);
80103cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf1:	89 04 24             	mov    %eax,(%esp)
80103cf4:	e8 43 ed ff ff       	call   80102a3c <kfree>
  if(*f0)
80103cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80103cfc:	8b 00                	mov    (%eax),%eax
80103cfe:	85 c0                	test   %eax,%eax
80103d00:	74 0d                	je     80103d0f <pipealloc+0x126>
    fileclose(*f0);
80103d02:	8b 45 08             	mov    0x8(%ebp),%eax
80103d05:	8b 00                	mov    (%eax),%eax
80103d07:	89 04 24             	mov    %eax,(%esp)
80103d0a:	e8 b2 d2 ff ff       	call   80100fc1 <fileclose>
  if(*f1)
80103d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d12:	8b 00                	mov    (%eax),%eax
80103d14:	85 c0                	test   %eax,%eax
80103d16:	74 0d                	je     80103d25 <pipealloc+0x13c>
    fileclose(*f1);
80103d18:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1b:	8b 00                	mov    (%eax),%eax
80103d1d:	89 04 24             	mov    %eax,(%esp)
80103d20:	e8 9c d2 ff ff       	call   80100fc1 <fileclose>
  return -1;
80103d25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d2a:	c9                   	leave  
80103d2b:	c3                   	ret    

80103d2c <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d2c:	55                   	push   %ebp
80103d2d:	89 e5                	mov    %esp,%ebp
80103d2f:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d32:	8b 45 08             	mov    0x8(%ebp),%eax
80103d35:	89 04 24             	mov    %eax,(%esp)
80103d38:	e8 88 15 00 00       	call   801052c5 <acquire>
  if(writable){
80103d3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d41:	74 1f                	je     80103d62 <pipeclose+0x36>
    p->writeopen = 0;
80103d43:	8b 45 08             	mov    0x8(%ebp),%eax
80103d46:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d4d:	00 00 00 
    wakeup(&p->nread);
80103d50:	8b 45 08             	mov    0x8(%ebp),%eax
80103d53:	05 34 02 00 00       	add    $0x234,%eax
80103d58:	89 04 24             	mov    %eax,(%esp)
80103d5b:	e8 3e 13 00 00       	call   8010509e <wakeup>
80103d60:	eb 1d                	jmp    80103d7f <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d62:	8b 45 08             	mov    0x8(%ebp),%eax
80103d65:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d6c:	00 00 00 
    wakeup(&p->nwrite);
80103d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d72:	05 38 02 00 00       	add    $0x238,%eax
80103d77:	89 04 24             	mov    %eax,(%esp)
80103d7a:	e8 1f 13 00 00       	call   8010509e <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d82:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d88:	85 c0                	test   %eax,%eax
80103d8a:	75 25                	jne    80103db1 <pipeclose+0x85>
80103d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103d95:	85 c0                	test   %eax,%eax
80103d97:	75 18                	jne    80103db1 <pipeclose+0x85>
    release(&p->lock);
80103d99:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9c:	89 04 24             	mov    %eax,(%esp)
80103d9f:	e8 83 15 00 00       	call   80105327 <release>
    kfree((char*)p);
80103da4:	8b 45 08             	mov    0x8(%ebp),%eax
80103da7:	89 04 24             	mov    %eax,(%esp)
80103daa:	e8 8d ec ff ff       	call   80102a3c <kfree>
80103daf:	eb 0b                	jmp    80103dbc <pipeclose+0x90>
  } else
    release(&p->lock);
80103db1:	8b 45 08             	mov    0x8(%ebp),%eax
80103db4:	89 04 24             	mov    %eax,(%esp)
80103db7:	e8 6b 15 00 00       	call   80105327 <release>
}
80103dbc:	c9                   	leave  
80103dbd:	c3                   	ret    

80103dbe <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103dbe:	55                   	push   %ebp
80103dbf:	89 e5                	mov    %esp,%ebp
80103dc1:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc7:	89 04 24             	mov    %eax,(%esp)
80103dca:	e8 f6 14 00 00       	call   801052c5 <acquire>
  for(i = 0; i < n; i++){
80103dcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103dd6:	e9 a6 00 00 00       	jmp    80103e81 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ddb:	eb 57                	jmp    80103e34 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103ddd:	8b 45 08             	mov    0x8(%ebp),%eax
80103de0:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103de6:	85 c0                	test   %eax,%eax
80103de8:	74 0d                	je     80103df7 <pipewrite+0x39>
80103dea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103df0:	8b 40 24             	mov    0x24(%eax),%eax
80103df3:	85 c0                	test   %eax,%eax
80103df5:	74 15                	je     80103e0c <pipewrite+0x4e>
        release(&p->lock);
80103df7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfa:	89 04 24             	mov    %eax,(%esp)
80103dfd:	e8 25 15 00 00       	call   80105327 <release>
        return -1;
80103e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e07:	e9 9f 00 00 00       	jmp    80103eab <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0f:	05 34 02 00 00       	add    $0x234,%eax
80103e14:	89 04 24             	mov    %eax,(%esp)
80103e17:	e8 82 12 00 00       	call   8010509e <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e1c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1f:	8b 55 08             	mov    0x8(%ebp),%edx
80103e22:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e28:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e2c:	89 14 24             	mov    %edx,(%esp)
80103e2f:	e8 20 11 00 00       	call   80104f54 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e34:	8b 45 08             	mov    0x8(%ebp),%eax
80103e37:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e40:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e46:	05 00 02 00 00       	add    $0x200,%eax
80103e4b:	39 c2                	cmp    %eax,%edx
80103e4d:	74 8e                	je     80103ddd <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e52:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e58:	8d 48 01             	lea    0x1(%eax),%ecx
80103e5b:	8b 55 08             	mov    0x8(%ebp),%edx
80103e5e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103e64:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e69:	89 c1                	mov    %eax,%ecx
80103e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e71:	01 d0                	add    %edx,%eax
80103e73:	0f b6 10             	movzbl (%eax),%edx
80103e76:	8b 45 08             	mov    0x8(%ebp),%eax
80103e79:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e7d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e84:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e87:	0f 8c 4e ff ff ff    	jl     80103ddb <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e8d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e90:	05 34 02 00 00       	add    $0x234,%eax
80103e95:	89 04 24             	mov    %eax,(%esp)
80103e98:	e8 01 12 00 00       	call   8010509e <wakeup>
  release(&p->lock);
80103e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea0:	89 04 24             	mov    %eax,(%esp)
80103ea3:	e8 7f 14 00 00       	call   80105327 <release>
  return n;
80103ea8:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103eab:	c9                   	leave  
80103eac:	c3                   	ret    

80103ead <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ead:	55                   	push   %ebp
80103eae:	89 e5                	mov    %esp,%ebp
80103eb0:	53                   	push   %ebx
80103eb1:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb7:	89 04 24             	mov    %eax,(%esp)
80103eba:	e8 06 14 00 00       	call   801052c5 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ebf:	eb 3a                	jmp    80103efb <piperead+0x4e>
    if(proc->killed){
80103ec1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ec7:	8b 40 24             	mov    0x24(%eax),%eax
80103eca:	85 c0                	test   %eax,%eax
80103ecc:	74 15                	je     80103ee3 <piperead+0x36>
      release(&p->lock);
80103ece:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed1:	89 04 24             	mov    %eax,(%esp)
80103ed4:	e8 4e 14 00 00       	call   80105327 <release>
      return -1;
80103ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ede:	e9 b5 00 00 00       	jmp    80103f98 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee6:	8b 55 08             	mov    0x8(%ebp),%edx
80103ee9:	81 c2 34 02 00 00    	add    $0x234,%edx
80103eef:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ef3:	89 14 24             	mov    %edx,(%esp)
80103ef6:	e8 59 10 00 00       	call   80104f54 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103efb:	8b 45 08             	mov    0x8(%ebp),%eax
80103efe:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f04:	8b 45 08             	mov    0x8(%ebp),%eax
80103f07:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f0d:	39 c2                	cmp    %eax,%edx
80103f0f:	75 0d                	jne    80103f1e <piperead+0x71>
80103f11:	8b 45 08             	mov    0x8(%ebp),%eax
80103f14:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	75 a3                	jne    80103ec1 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f25:	eb 4b                	jmp    80103f72 <piperead+0xc5>
    if(p->nread == p->nwrite)
80103f27:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f30:	8b 45 08             	mov    0x8(%ebp),%eax
80103f33:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f39:	39 c2                	cmp    %eax,%edx
80103f3b:	75 02                	jne    80103f3f <piperead+0x92>
      break;
80103f3d:	eb 3b                	jmp    80103f7a <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f42:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f45:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103f48:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f51:	8d 48 01             	lea    0x1(%eax),%ecx
80103f54:	8b 55 08             	mov    0x8(%ebp),%edx
80103f57:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103f5d:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f62:	89 c2                	mov    %eax,%edx
80103f64:	8b 45 08             	mov    0x8(%ebp),%eax
80103f67:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80103f6c:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f75:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f78:	7c ad                	jl     80103f27 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7d:	05 38 02 00 00       	add    $0x238,%eax
80103f82:	89 04 24             	mov    %eax,(%esp)
80103f85:	e8 14 11 00 00       	call   8010509e <wakeup>
  release(&p->lock);
80103f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8d:	89 04 24             	mov    %eax,(%esp)
80103f90:	e8 92 13 00 00       	call   80105327 <release>
  return i;
80103f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103f98:	83 c4 24             	add    $0x24,%esp
80103f9b:	5b                   	pop    %ebx
80103f9c:	5d                   	pop    %ebp
80103f9d:	c3                   	ret    

80103f9e <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103f9e:	55                   	push   %ebp
80103f9f:	89 e5                	mov    %esp,%ebp
80103fa1:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fa4:	9c                   	pushf  
80103fa5:	58                   	pop    %eax
80103fa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103fac:	c9                   	leave  
80103fad:	c3                   	ret    

80103fae <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103fae:	55                   	push   %ebp
80103faf:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103fb1:	fb                   	sti    
}
80103fb2:	5d                   	pop    %ebp
80103fb3:	c3                   	ret    

80103fb4 <queuePush>:
int lastInQ[3] = { 0 };

//Priority 0 = High
//Priority 1 = Medium
//Priority 2 = Low
void queuePush(struct proc *p, int pr) {
80103fb4:	55                   	push   %ebp
80103fb5:	89 e5                	mov    %esp,%ebp
	procQueue[pr][lastInQ[pr]] = p;
80103fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fba:	8b 04 85 54 c6 10 80 	mov    -0x7fef39ac(,%eax,4),%eax
80103fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fc4:	c1 e2 06             	shl    $0x6,%edx
80103fc7:	01 c2                	add    %eax,%edx
80103fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcc:	89 04 95 80 27 15 80 	mov    %eax,-0x7fead880(,%edx,4)
	lastInQ[pr] = (lastInQ[pr] + 1) % NPROC;
80103fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd6:	8b 04 85 54 c6 10 80 	mov    -0x7fef39ac(,%eax,4),%eax
80103fdd:	8d 50 01             	lea    0x1(%eax),%edx
80103fe0:	89 d0                	mov    %edx,%eax
80103fe2:	c1 f8 1f             	sar    $0x1f,%eax
80103fe5:	c1 e8 1a             	shr    $0x1a,%eax
80103fe8:	01 c2                	add    %eax,%edx
80103fea:	83 e2 3f             	and    $0x3f,%edx
80103fed:	29 c2                	sub    %eax,%edx
80103fef:	89 d0                	mov    %edx,%eax
80103ff1:	89 c2                	mov    %eax,%edx
80103ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff6:	89 14 85 54 c6 10 80 	mov    %edx,-0x7fef39ac(,%eax,4)
}
80103ffd:	5d                   	pop    %ebp
80103ffe:	c3                   	ret    

80103fff <queuePop>:

struct proc* queuePop(int pr) {
80103fff:	55                   	push   %ebp
80104000:	89 e5                	mov    %esp,%ebp
80104002:	83 ec 10             	sub    $0x10,%esp
	struct proc *res;
	res = procQueue[pr][firstInQ[pr]];
80104005:	8b 45 08             	mov    0x8(%ebp),%eax
80104008:	8b 04 85 48 c6 10 80 	mov    -0x7fef39b8(,%eax,4),%eax
8010400f:	8b 55 08             	mov    0x8(%ebp),%edx
80104012:	c1 e2 06             	shl    $0x6,%edx
80104015:	01 d0                	add    %edx,%eax
80104017:	8b 04 85 80 27 15 80 	mov    -0x7fead880(,%eax,4),%eax
8010401e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	firstInQ[pr] = (firstInQ[pr] + 1) % NPROC;
80104021:	8b 45 08             	mov    0x8(%ebp),%eax
80104024:	8b 04 85 48 c6 10 80 	mov    -0x7fef39b8(,%eax,4),%eax
8010402b:	8d 50 01             	lea    0x1(%eax),%edx
8010402e:	89 d0                	mov    %edx,%eax
80104030:	c1 f8 1f             	sar    $0x1f,%eax
80104033:	c1 e8 1a             	shr    $0x1a,%eax
80104036:	01 c2                	add    %eax,%edx
80104038:	83 e2 3f             	and    $0x3f,%edx
8010403b:	29 c2                	sub    %eax,%edx
8010403d:	89 d0                	mov    %edx,%eax
8010403f:	89 c2                	mov    %eax,%edx
80104041:	8b 45 08             	mov    0x8(%ebp),%eax
80104044:	89 14 85 48 c6 10 80 	mov    %edx,-0x7fef39b8(,%eax,4)
	return res;
8010404b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010404e:	c9                   	leave  
8010404f:	c3                   	ret    

80104050 <cpuQueuePush>:

void cpuQueuePush(struct proc *p, struct cpu *minCpu) {
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	83 ec 18             	sub    $0x18,%esp
	acquire(&(minCpu->lock));
80104056:	8b 45 0c             	mov    0xc(%ebp),%eax
80104059:	05 c8 01 00 00       	add    $0x1c8,%eax
8010405e:	89 04 24             	mov    %eax,(%esp)
80104061:	e8 5f 12 00 00       	call   801052c5 <acquire>
	if (minCpu->numOfProcs != NPROC) {
80104066:	8b 45 0c             	mov    0xc(%ebp),%eax
80104069:	8b 80 c4 01 00 00    	mov    0x1c4(%eax),%eax
8010406f:	83 f8 40             	cmp    $0x40,%eax
80104072:	74 53                	je     801040c7 <cpuQueuePush+0x77>
		minCpu->procQ[minCpu->lastInQ] = p;
80104074:	8b 45 0c             	mov    0xc(%ebp),%eax
80104077:	8b 90 c0 01 00 00    	mov    0x1c0(%eax),%edx
8010407d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104080:	8d 4a 2c             	lea    0x2c(%edx),%ecx
80104083:	8b 55 08             	mov    0x8(%ebp),%edx
80104086:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
		minCpu->lastInQ = (minCpu->lastInQ + 1) % NPROC;
8010408a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010408d:	8b 80 c0 01 00 00    	mov    0x1c0(%eax),%eax
80104093:	8d 50 01             	lea    0x1(%eax),%edx
80104096:	89 d0                	mov    %edx,%eax
80104098:	c1 f8 1f             	sar    $0x1f,%eax
8010409b:	c1 e8 1a             	shr    $0x1a,%eax
8010409e:	01 c2                	add    %eax,%edx
801040a0:	83 e2 3f             	and    $0x3f,%edx
801040a3:	29 c2                	sub    %eax,%edx
801040a5:	89 d0                	mov    %edx,%eax
801040a7:	89 c2                	mov    %eax,%edx
801040a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ac:	89 90 c0 01 00 00    	mov    %edx,0x1c0(%eax)
		minCpu->numOfProcs++;
801040b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b5:	8b 80 c4 01 00 00    	mov    0x1c4(%eax),%eax
801040bb:	8d 50 01             	lea    0x1(%eax),%edx
801040be:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c1:	89 90 c4 01 00 00    	mov    %edx,0x1c4(%eax)
	}
	release(&(minCpu->lock));
801040c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ca:	05 c8 01 00 00       	add    $0x1c8,%eax
801040cf:	89 04 24             	mov    %eax,(%esp)
801040d2:	e8 50 12 00 00       	call   80105327 <release>
}
801040d7:	c9                   	leave  
801040d8:	c3                   	ret    

801040d9 <cpuQueuePop>:

struct proc* cpuQueuePop(struct cpu *c) {
801040d9:	55                   	push   %ebp
801040da:	89 e5                	mov    %esp,%ebp
801040dc:	83 ec 10             	sub    $0x10,%esp
	if (c->numOfProcs != 0) {
801040df:	8b 45 08             	mov    0x8(%ebp),%eax
801040e2:	8b 80 c4 01 00 00    	mov    0x1c4(%eax),%eax
801040e8:	85 c0                	test   %eax,%eax
801040ea:	74 58                	je     80104144 <cpuQueuePop+0x6b>
		struct proc *retProc;
		retProc = c->procQ[c->firstInQ];
801040ec:	8b 45 08             	mov    0x8(%ebp),%eax
801040ef:	8b 90 bc 01 00 00    	mov    0x1bc(%eax),%edx
801040f5:	8b 45 08             	mov    0x8(%ebp),%eax
801040f8:	83 c2 2c             	add    $0x2c,%edx
801040fb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801040ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
		c->firstInQ = (c->firstInQ + 1) % NPROC;
80104102:	8b 45 08             	mov    0x8(%ebp),%eax
80104105:	8b 80 bc 01 00 00    	mov    0x1bc(%eax),%eax
8010410b:	8d 50 01             	lea    0x1(%eax),%edx
8010410e:	89 d0                	mov    %edx,%eax
80104110:	c1 f8 1f             	sar    $0x1f,%eax
80104113:	c1 e8 1a             	shr    $0x1a,%eax
80104116:	01 c2                	add    %eax,%edx
80104118:	83 e2 3f             	and    $0x3f,%edx
8010411b:	29 c2                	sub    %eax,%edx
8010411d:	89 d0                	mov    %edx,%eax
8010411f:	89 c2                	mov    %eax,%edx
80104121:	8b 45 08             	mov    0x8(%ebp),%eax
80104124:	89 90 bc 01 00 00    	mov    %edx,0x1bc(%eax)
		c->numOfProcs--;
8010412a:	8b 45 08             	mov    0x8(%ebp),%eax
8010412d:	8b 80 c4 01 00 00    	mov    0x1c4(%eax),%eax
80104133:	8d 50 ff             	lea    -0x1(%eax),%edx
80104136:	8b 45 08             	mov    0x8(%ebp),%eax
80104139:	89 90 c4 01 00 00    	mov    %edx,0x1c4(%eax)
		return retProc;
8010413f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104142:	eb 05                	jmp    80104149 <cpuQueuePop+0x70>
	} else {
		return 0;
80104144:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
80104149:	c9                   	leave  
8010414a:	c3                   	ret    

8010414b <minProcCpuGet>:

struct cpu* minProcCpuGet(void) {
8010414b:	55                   	push   %ebp
8010414c:	89 e5                	mov    %esp,%ebp
8010414e:	83 ec 10             	sub    $0x10,%esp
	int minProcCpu = NPROC;
80104151:	c7 45 fc 40 00 00 00 	movl   $0x40,-0x4(%ebp)
	struct cpu *c, *minCpu;

	for (c = cpus; c < cpus + ncpu; c++) {
80104158:	c7 45 f8 40 09 11 80 	movl   $0x80110940,-0x8(%ebp)
8010415f:	eb 27                	jmp    80104188 <minProcCpuGet+0x3d>
		if (c->numOfProcs < minProcCpu) {
80104161:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104164:	8b 80 c4 01 00 00    	mov    0x1c4(%eax),%eax
8010416a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010416d:	7d 12                	jge    80104181 <minProcCpuGet+0x36>
			minProcCpu = c->numOfProcs;
8010416f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104172:	8b 80 c4 01 00 00    	mov    0x1c4(%eax),%eax
80104178:	89 45 fc             	mov    %eax,-0x4(%ebp)
			minCpu = c;
8010417b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010417e:	89 45 f4             	mov    %eax,-0xc(%ebp)

struct cpu* minProcCpuGet(void) {
	int minProcCpu = NPROC;
	struct cpu *c, *minCpu;

	for (c = cpus; c < cpus + ncpu; c++) {
80104181:	81 45 f8 fc 01 00 00 	addl   $0x1fc,-0x8(%ebp)
80104188:	a1 20 19 11 80       	mov    0x80111920,%eax
8010418d:	c1 e0 02             	shl    $0x2,%eax
80104190:	89 c2                	mov    %eax,%edx
80104192:	c1 e2 07             	shl    $0x7,%edx
80104195:	29 c2                	sub    %eax,%edx
80104197:	89 d0                	mov    %edx,%eax
80104199:	05 40 09 11 80       	add    $0x80110940,%eax
8010419e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801041a1:	77 be                	ja     80104161 <minProcCpuGet+0x16>
		if (c->numOfProcs < minProcCpu) {
			minProcCpu = c->numOfProcs;
			minCpu = c;
		}
	}
	return minCpu;
801041a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801041a6:	c9                   	leave  
801041a7:	c3                   	ret    

801041a8 <pinit>:
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void) {
801041a8:	55                   	push   %ebp
801041a9:	89 e5                	mov    %esp,%ebp
801041ab:	83 ec 18             	sub    $0x18,%esp
	initlock(&ptable.lock, "ptable");
801041ae:	c7 44 24 04 11 8d 10 	movl   $0x80108d11,0x4(%esp)
801041b5:	80 
801041b6:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
801041bd:	e8 e2 10 00 00       	call   801052a4 <initlock>
}
801041c2:	c9                   	leave  
801041c3:	c3                   	ret    

801041c4 <updateProc>:

void updateProc() {
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	83 ec 10             	sub    $0x10,%esp
	struct proc *p;
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041ca:	c7 45 fc 74 19 11 80 	movl   $0x80111974,-0x4(%ebp)
801041d1:	eb 47                	jmp    8010421a <updateProc+0x56>
		if (p->state == SLEEPING) {
801041d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041d6:	8b 40 0c             	mov    0xc(%eax),%eax
801041d9:	83 f8 02             	cmp    $0x2,%eax
801041dc:	75 15                	jne    801041f3 <updateProc+0x2f>
			p->wtime++;
801041de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041e1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801041e7:	8d 50 01             	lea    0x1(%eax),%edx
801041ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041ed:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
		}
		if (p->state == RUNNING) {
801041f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041f6:	8b 40 0c             	mov    0xc(%eax),%eax
801041f9:	83 f8 04             	cmp    $0x4,%eax
801041fc:	75 15                	jne    80104213 <updateProc+0x4f>
			p->rtime++;
801041fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104201:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104207:	8d 50 01             	lea    0x1(%eax),%edx
8010420a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010420d:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
	initlock(&ptable.lock, "ptable");
}

void updateProc() {
	struct proc *p;
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104213:	81 45 fc 38 10 00 00 	addl   $0x1038,-0x4(%ebp)
8010421a:	81 7d fc 74 27 15 80 	cmpl   $0x80152774,-0x4(%ebp)
80104221:	72 b0                	jb     801041d3 <updateProc+0xf>
		}
		if (p->state == RUNNING) {
			p->rtime++;
		}
	}
}
80104223:	c9                   	leave  
80104224:	c3                   	ret    

80104225 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
80104225:	55                   	push   %ebp
80104226:	89 e5                	mov    %esp,%ebp
80104228:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	char *sp;

	acquire(&ptable.lock);
8010422b:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104232:	e8 8e 10 00 00       	call   801052c5 <acquire>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104237:	c7 45 f4 74 19 11 80 	movl   $0x80111974,-0xc(%ebp)
8010423e:	e9 a4 00 00 00       	jmp    801042e7 <allocproc+0xc2>
		if (p->state == UNUSED)
80104243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104246:	8b 40 0c             	mov    0xc(%eax),%eax
80104249:	85 c0                	test   %eax,%eax
8010424b:	0f 85 8f 00 00 00    	jne    801042e0 <allocproc+0xbb>
			goto found;
80104251:	90                   	nop
	release(&ptable.lock);
	return 0;

	found: p->state = EMBRYO;
80104252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104255:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
	p->pid = nextpid++;
8010425c:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104261:	8d 50 01             	lea    0x1(%eax),%edx
80104264:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010426a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010426d:	89 42 10             	mov    %eax,0x10(%edx)
	p->quanta = 0;
80104270:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104273:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010427a:	00 00 00 
	p->ctime = ticks;
8010427d:	8b 15 c0 32 15 80    	mov    0x801532c0,%edx
80104283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104286:	89 50 7c             	mov    %edx,0x7c(%eax)
	p->rtime = 0;
80104289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428c:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104293:	00 00 00 
	p->wtime = 0;
80104296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104299:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801042a0:	00 00 00 
	p->priority = 2;
801042a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a6:	c7 80 90 00 00 00 02 	movl   $0x2,0x90(%eax)
801042ad:	00 00 00 
	//memset(p->schedulingInfo, 0, 10000);
	p->timesScheduled = 0;
801042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b3:	c7 80 34 10 00 00 00 	movl   $0x0,0x1034(%eax)
801042ba:	00 00 00 

	release(&ptable.lock);
801042bd:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
801042c4:	e8 5e 10 00 00       	call   80105327 <release>

	// Allocate kernel stack.
	if ((p->kstack = kalloc()) == 0) {
801042c9:	e8 07 e8 ff ff       	call   80102ad5 <kalloc>
801042ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042d1:	89 42 08             	mov    %eax,0x8(%edx)
801042d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d7:	8b 40 08             	mov    0x8(%eax),%eax
801042da:	85 c0                	test   %eax,%eax
801042dc:	75 3a                	jne    80104318 <allocproc+0xf3>
801042de:	eb 27                	jmp    80104307 <allocproc+0xe2>
allocproc(void) {
	struct proc *p;
	char *sp;

	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e0:	81 45 f4 38 10 00 00 	addl   $0x1038,-0xc(%ebp)
801042e7:	81 7d f4 74 27 15 80 	cmpl   $0x80152774,-0xc(%ebp)
801042ee:	0f 82 4f ff ff ff    	jb     80104243 <allocproc+0x1e>
		if (p->state == UNUSED)
			goto found;
	release(&ptable.lock);
801042f4:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
801042fb:	e8 27 10 00 00       	call   80105327 <release>
	return 0;
80104300:	b8 00 00 00 00       	mov    $0x0,%eax
80104305:	eb 76                	jmp    8010437d <allocproc+0x158>

	release(&ptable.lock);

	// Allocate kernel stack.
	if ((p->kstack = kalloc()) == 0) {
		p->state = UNUSED;
80104307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		return 0;
80104311:	b8 00 00 00 00       	mov    $0x0,%eax
80104316:	eb 65                	jmp    8010437d <allocproc+0x158>
	}
	sp = p->kstack + KSTACKSIZE;
80104318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010431b:	8b 40 08             	mov    0x8(%eax),%eax
8010431e:	05 00 10 00 00       	add    $0x1000,%eax
80104323:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// Leave room for trap frame.
	sp -= sizeof *p->tf;
80104326:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
	p->tf = (struct trapframe*) sp;
8010432a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104330:	89 50 18             	mov    %edx,0x18(%eax)

	// Set up new context to start executing at forkret,
	// which returns to trapret.
	sp -= 4;
80104333:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
	*(uint*) sp = (uint) trapret;
80104337:	ba ae 6a 10 80       	mov    $0x80106aae,%edx
8010433c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010433f:	89 10                	mov    %edx,(%eax)

	sp -= sizeof *p->context;
80104341:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
	p->context = (struct context*) sp;
80104345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104348:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010434b:	89 50 1c             	mov    %edx,0x1c(%eax)
	memset(p->context, 0, sizeof *p->context);
8010434e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104351:	8b 40 1c             	mov    0x1c(%eax),%eax
80104354:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010435b:	00 
8010435c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104363:	00 
80104364:	89 04 24             	mov    %eax,(%esp)
80104367:	e8 ad 11 00 00       	call   80105519 <memset>
	p->context->eip = (uint) forkret;
8010436c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104372:	ba 21 4f 10 80       	mov    $0x80104f21,%edx
80104377:	89 50 10             	mov    %edx,0x10(%eax)

	return p;
8010437a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010437d:	c9                   	leave  
8010437e:	c3                   	ret    

8010437f <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void userinit(void) {
8010437f:	55                   	push   %ebp
80104380:	89 e5                	mov    %esp,%ebp
80104382:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	extern char _binary_initcode_start[], _binary_initcode_size[];

	p = allocproc();
80104385:	e8 9b fe ff ff       	call   80104225 <allocproc>
8010438a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	initproc = p;
8010438d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104390:	a3 60 c6 10 80       	mov    %eax,0x8010c660
	if ((p->pgdir = setupkvm(kalloc)) == 0)
80104395:	c7 04 24 d5 2a 10 80 	movl   $0x80102ad5,(%esp)
8010439c:	e8 4e 3e 00 00       	call   801081ef <setupkvm>
801043a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a4:	89 42 04             	mov    %eax,0x4(%edx)
801043a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043aa:	8b 40 04             	mov    0x4(%eax),%eax
801043ad:	85 c0                	test   %eax,%eax
801043af:	75 0c                	jne    801043bd <userinit+0x3e>
		panic("userinit: out of memory?");
801043b1:	c7 04 24 18 8d 10 80 	movl   $0x80108d18,(%esp)
801043b8:	e8 7d c1 ff ff       	call   8010053a <panic>
	inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
801043bd:	ba 2c 00 00 00       	mov    $0x2c,%edx
801043c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c5:	8b 40 04             	mov    0x4(%eax),%eax
801043c8:	89 54 24 08          	mov    %edx,0x8(%esp)
801043cc:	c7 44 24 04 e0 c4 10 	movl   $0x8010c4e0,0x4(%esp)
801043d3:	80 
801043d4:	89 04 24             	mov    %eax,(%esp)
801043d7:	e8 6b 40 00 00       	call   80108447 <inituvm>
	p->sz = PGSIZE;
801043dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043df:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
	memset(p->tf, 0, sizeof(*p->tf));
801043e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e8:	8b 40 18             	mov    0x18(%eax),%eax
801043eb:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801043f2:	00 
801043f3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801043fa:	00 
801043fb:	89 04 24             	mov    %eax,(%esp)
801043fe:	e8 16 11 00 00       	call   80105519 <memset>
	p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104406:	8b 40 18             	mov    0x18(%eax),%eax
80104409:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
	p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010440f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104412:	8b 40 18             	mov    0x18(%eax),%eax
80104415:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
	p->tf->es = p->tf->ds;
8010441b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441e:	8b 40 18             	mov    0x18(%eax),%eax
80104421:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104424:	8b 52 18             	mov    0x18(%edx),%edx
80104427:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010442b:	66 89 50 28          	mov    %dx,0x28(%eax)
	p->tf->ss = p->tf->ds;
8010442f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104432:	8b 40 18             	mov    0x18(%eax),%eax
80104435:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104438:	8b 52 18             	mov    0x18(%edx),%edx
8010443b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010443f:	66 89 50 48          	mov    %dx,0x48(%eax)
	p->tf->eflags = FL_IF;
80104443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104446:	8b 40 18             	mov    0x18(%eax),%eax
80104449:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	p->tf->esp = PGSIZE;
80104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104453:	8b 40 18             	mov    0x18(%eax),%eax
80104456:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
	p->tf->eip = 0; // beginning of initcode.S
8010445d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104460:	8b 40 18             	mov    0x18(%eax),%eax
80104463:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

	safestrcpy(p->name, "initcode", sizeof(p->name));
8010446a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446d:	83 c0 6c             	add    $0x6c,%eax
80104470:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104477:	00 
80104478:	c7 44 24 04 31 8d 10 	movl   $0x80108d31,0x4(%esp)
8010447f:	80 
80104480:	89 04 24             	mov    %eax,(%esp)
80104483:	e8 b1 12 00 00       	call   80105739 <safestrcpy>
	p->cwd = namei("/");
80104488:	c7 04 24 3a 8d 10 80 	movl   $0x80108d3a,(%esp)
8010448f:	e8 65 df ff ff       	call   801023f9 <namei>
80104494:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104497:	89 42 68             	mov    %eax,0x68(%edx)

	p->state = RUNNABLE;
8010449a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
#elif FCFS
	queuePush(p, 2);
#elif MLQ
	queuePush(p, 1);
#elif MC_FRR
	cpuQueuePush(p, minProcCpuGet());
801044a4:	e8 a2 fc ff ff       	call   8010414b <minProcCpuGet>
801044a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801044ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b0:	89 04 24             	mov    %eax,(%esp)
801044b3:	e8 98 fb ff ff       	call   80104050 <cpuQueuePush>
#endif
}
801044b8:	c9                   	leave  
801044b9:	c3                   	ret    

801044ba <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n) {
801044ba:	55                   	push   %ebp
801044bb:	89 e5                	mov    %esp,%ebp
801044bd:	83 ec 28             	sub    $0x28,%esp
	uint sz;

	sz = proc->sz;
801044c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c6:	8b 00                	mov    (%eax),%eax
801044c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (n > 0) {
801044cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801044cf:	7e 34                	jle    80104505 <growproc+0x4b>
		if ((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801044d1:	8b 55 08             	mov    0x8(%ebp),%edx
801044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d7:	01 c2                	add    %eax,%edx
801044d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044df:	8b 40 04             	mov    0x4(%eax),%eax
801044e2:	89 54 24 08          	mov    %edx,0x8(%esp)
801044e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044e9:	89 54 24 04          	mov    %edx,0x4(%esp)
801044ed:	89 04 24             	mov    %eax,(%esp)
801044f0:	e8 c8 40 00 00       	call   801085bd <allocuvm>
801044f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801044f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801044fc:	75 41                	jne    8010453f <growproc+0x85>
			return -1;
801044fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104503:	eb 58                	jmp    8010455d <growproc+0xa3>
	} else if (n < 0) {
80104505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104509:	79 34                	jns    8010453f <growproc+0x85>
		if ((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010450b:	8b 55 08             	mov    0x8(%ebp),%edx
8010450e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104511:	01 c2                	add    %eax,%edx
80104513:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104519:	8b 40 04             	mov    0x4(%eax),%eax
8010451c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104520:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104523:	89 54 24 04          	mov    %edx,0x4(%esp)
80104527:	89 04 24             	mov    %eax,(%esp)
8010452a:	e8 68 41 00 00       	call   80108697 <deallocuvm>
8010452f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104536:	75 07                	jne    8010453f <growproc+0x85>
			return -1;
80104538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453d:	eb 1e                	jmp    8010455d <growproc+0xa3>
	}
	proc->sz = sz;
8010453f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104545:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104548:	89 10                	mov    %edx,(%eax)
	switchuvm(proc);
8010454a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104550:	89 04 24             	mov    %eax,(%esp)
80104553:	e8 88 3d 00 00       	call   801082e0 <switchuvm>
	return 0;
80104558:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010455d:	c9                   	leave  
8010455e:	c3                   	ret    

8010455f <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void) {
8010455f:	55                   	push   %ebp
80104560:	89 e5                	mov    %esp,%ebp
80104562:	57                   	push   %edi
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	83 ec 2c             	sub    $0x2c,%esp
	int i, pid;
	struct proc *np;

	// Allocate process.
	if ((np = allocproc()) == 0)
80104568:	e8 b8 fc ff ff       	call   80104225 <allocproc>
8010456d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104570:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104574:	75 0a                	jne    80104580 <fork+0x21>
		return -1;
80104576:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010457b:	e9 4e 01 00 00       	jmp    801046ce <fork+0x16f>

	// Copy process state from p.
	if ((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0) {
80104580:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104586:	8b 10                	mov    (%eax),%edx
80104588:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010458e:	8b 40 04             	mov    0x4(%eax),%eax
80104591:	89 54 24 04          	mov    %edx,0x4(%esp)
80104595:	89 04 24             	mov    %eax,(%esp)
80104598:	e8 96 42 00 00       	call   80108833 <copyuvm>
8010459d:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045a0:	89 42 04             	mov    %eax,0x4(%edx)
801045a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045a6:	8b 40 04             	mov    0x4(%eax),%eax
801045a9:	85 c0                	test   %eax,%eax
801045ab:	75 2c                	jne    801045d9 <fork+0x7a>
		kfree(np->kstack);
801045ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045b0:	8b 40 08             	mov    0x8(%eax),%eax
801045b3:	89 04 24             	mov    %eax,(%esp)
801045b6:	e8 81 e4 ff ff       	call   80102a3c <kfree>
		np->kstack = 0;
801045bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		np->state = UNUSED;
801045c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		return -1;
801045cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045d4:	e9 f5 00 00 00       	jmp    801046ce <fork+0x16f>
	}
	np->sz = proc->sz;
801045d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045df:	8b 10                	mov    (%eax),%edx
801045e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045e4:	89 10                	mov    %edx,(%eax)
	np->parent = proc;
801045e6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801045ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045f0:	89 50 14             	mov    %edx,0x14(%eax)
	*np->tf = *proc->tf;
801045f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045f6:	8b 50 18             	mov    0x18(%eax),%edx
801045f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ff:	8b 40 18             	mov    0x18(%eax),%eax
80104602:	89 c3                	mov    %eax,%ebx
80104604:	b8 13 00 00 00       	mov    $0x13,%eax
80104609:	89 d7                	mov    %edx,%edi
8010460b:	89 de                	mov    %ebx,%esi
8010460d:	89 c1                	mov    %eax,%ecx
8010460f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	// Clear %eax so that fork returns 0 in the child.
	np->tf->eax = 0;
80104611:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104614:	8b 40 18             	mov    0x18(%eax),%eax
80104617:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	for (i = 0; i < NOFILE; i++)
8010461e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104625:	eb 3d                	jmp    80104664 <fork+0x105>
		if (proc->ofile[i])
80104627:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010462d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104630:	83 c2 08             	add    $0x8,%edx
80104633:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104637:	85 c0                	test   %eax,%eax
80104639:	74 25                	je     80104660 <fork+0x101>
			np->ofile[i] = filedup(proc->ofile[i]);
8010463b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104641:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104644:	83 c2 08             	add    $0x8,%edx
80104647:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010464b:	89 04 24             	mov    %eax,(%esp)
8010464e:	e8 26 c9 ff ff       	call   80100f79 <filedup>
80104653:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104656:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104659:	83 c1 08             	add    $0x8,%ecx
8010465c:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
	*np->tf = *proc->tf;

	// Clear %eax so that fork returns 0 in the child.
	np->tf->eax = 0;

	for (i = 0; i < NOFILE; i++)
80104660:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104664:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104668:	7e bd                	jle    80104627 <fork+0xc8>
		if (proc->ofile[i])
			np->ofile[i] = filedup(proc->ofile[i]);
	np->cwd = idup(proc->cwd);
8010466a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104670:	8b 40 68             	mov    0x68(%eax),%eax
80104673:	89 04 24             	mov    %eax,(%esp)
80104676:	e8 a1 d1 ff ff       	call   8010181c <idup>
8010467b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010467e:	89 42 68             	mov    %eax,0x68(%edx)

	pid = np->pid;
80104681:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104684:	8b 40 10             	mov    0x10(%eax),%eax
80104687:	89 45 dc             	mov    %eax,-0x24(%ebp)
	np->state = RUNNABLE;
8010468a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010468d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	queuePush(np, 2);
#elif MLQ
	np->priority = 1;
	queuePush(np, np->priority);
#elif MC_FRR
	cpuQueuePush(np, minProcCpuGet());
80104694:	e8 b2 fa ff ff       	call   8010414b <minProcCpuGet>
80104699:	89 44 24 04          	mov    %eax,0x4(%esp)
8010469d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046a0:	89 04 24             	mov    %eax,(%esp)
801046a3:	e8 a8 f9 ff ff       	call   80104050 <cpuQueuePush>
#endif

	safestrcpy(np->name, proc->name, sizeof(proc->name));
801046a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ae:	8d 50 6c             	lea    0x6c(%eax),%edx
801046b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046b4:	83 c0 6c             	add    $0x6c,%eax
801046b7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801046be:	00 
801046bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801046c3:	89 04 24             	mov    %eax,(%esp)
801046c6:	e8 6e 10 00 00       	call   80105739 <safestrcpy>
	return pid;
801046cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801046ce:	83 c4 2c             	add    $0x2c,%esp
801046d1:	5b                   	pop    %ebx
801046d2:	5e                   	pop    %esi
801046d3:	5f                   	pop    %edi
801046d4:	5d                   	pop    %ebp
801046d5:	c3                   	ret    

801046d6 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void) {
801046d6:	55                   	push   %ebp
801046d7:	89 e5                	mov    %esp,%ebp
801046d9:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	int fd;

	if (proc == initproc)
801046dc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046e3:	a1 60 c6 10 80       	mov    0x8010c660,%eax
801046e8:	39 c2                	cmp    %eax,%edx
801046ea:	75 0c                	jne    801046f8 <exit+0x22>
		panic("init exiting");
801046ec:	c7 04 24 3c 8d 10 80 	movl   $0x80108d3c,(%esp)
801046f3:	e8 42 be ff ff       	call   8010053a <panic>

	// Close all open files.
	for (fd = 0; fd < NOFILE; fd++) {
801046f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801046ff:	eb 44                	jmp    80104745 <exit+0x6f>
		if (proc->ofile[fd]) {
80104701:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104707:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010470a:	83 c2 08             	add    $0x8,%edx
8010470d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104711:	85 c0                	test   %eax,%eax
80104713:	74 2c                	je     80104741 <exit+0x6b>
			fileclose(proc->ofile[fd]);
80104715:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010471b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010471e:	83 c2 08             	add    $0x8,%edx
80104721:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104725:	89 04 24             	mov    %eax,(%esp)
80104728:	e8 94 c8 ff ff       	call   80100fc1 <fileclose>
			proc->ofile[fd] = 0;
8010472d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104733:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104736:	83 c2 08             	add    $0x8,%edx
80104739:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104740:	00 

	if (proc == initproc)
		panic("init exiting");

	// Close all open files.
	for (fd = 0; fd < NOFILE; fd++) {
80104741:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104745:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104749:	7e b6                	jle    80104701 <exit+0x2b>
			fileclose(proc->ofile[fd]);
			proc->ofile[fd] = 0;
		}
	}

	iput(proc->cwd);
8010474b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104751:	8b 40 68             	mov    0x68(%eax),%eax
80104754:	89 04 24             	mov    %eax,(%esp)
80104757:	e8 a5 d2 ff ff       	call   80101a01 <iput>
	proc->cwd = 0;
8010475c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104762:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

	proc->etime = ticks;
80104769:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010476f:	8b 15 c0 32 15 80    	mov    0x801532c0,%edx
80104775:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
	acquire(&ptable.lock);
8010477b:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104782:	e8 3e 0b 00 00       	call   801052c5 <acquire>

	// Parent might be sleeping in wait().
	wakeup1(proc->parent);
80104787:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478d:	8b 40 14             	mov    0x14(%eax),%eax
80104790:	89 04 24             	mov    %eax,(%esp)
80104793:	e8 a4 08 00 00       	call   8010503c <wakeup1>

	// Pass abandoned children to init.
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104798:	c7 45 f4 74 19 11 80 	movl   $0x80111974,-0xc(%ebp)
8010479f:	eb 3b                	jmp    801047dc <exit+0x106>
		if (p->parent == proc) {
801047a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a4:	8b 50 14             	mov    0x14(%eax),%edx
801047a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ad:	39 c2                	cmp    %eax,%edx
801047af:	75 24                	jne    801047d5 <exit+0xff>
			p->parent = initproc;
801047b1:	8b 15 60 c6 10 80    	mov    0x8010c660,%edx
801047b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ba:	89 50 14             	mov    %edx,0x14(%eax)
			if (p->state == ZOMBIE)
801047bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c0:	8b 40 0c             	mov    0xc(%eax),%eax
801047c3:	83 f8 05             	cmp    $0x5,%eax
801047c6:	75 0d                	jne    801047d5 <exit+0xff>
				wakeup1(initproc);
801047c8:	a1 60 c6 10 80       	mov    0x8010c660,%eax
801047cd:	89 04 24             	mov    %eax,(%esp)
801047d0:	e8 67 08 00 00       	call   8010503c <wakeup1>

	// Parent might be sleeping in wait().
	wakeup1(proc->parent);

	// Pass abandoned children to init.
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801047d5:	81 45 f4 38 10 00 00 	addl   $0x1038,-0xc(%ebp)
801047dc:	81 7d f4 74 27 15 80 	cmpl   $0x80152774,-0xc(%ebp)
801047e3:	72 bc                	jb     801047a1 <exit+0xcb>
				wakeup1(initproc);
		}
	}

	// Jump into the scheduler, never to return.
	proc->state = ZOMBIE;
801047e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047eb:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
#ifdef MC_FRR
	release(&ptable.lock);
801047f2:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
801047f9:	e8 29 0b 00 00       	call   80105327 <release>
	acquire(&cpu->lock);
801047fe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104804:	05 c8 01 00 00       	add    $0x1c8,%eax
80104809:	89 04 24             	mov    %eax,(%esp)
8010480c:	e8 b4 0a 00 00       	call   801052c5 <acquire>
#endif
	sched();
80104811:	e8 f9 05 00 00       	call   80104e0f <sched>
	panic("zombie exit");
80104816:	c7 04 24 49 8d 10 80 	movl   $0x80108d49,(%esp)
8010481d:	e8 18 bd ff ff       	call   8010053a <panic>

80104822 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void) {
80104822:	55                   	push   %ebp
80104823:	89 e5                	mov    %esp,%ebp
80104825:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	int havekids, pid;

	acquire(&ptable.lock);
80104828:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
8010482f:	e8 91 0a 00 00       	call   801052c5 <acquire>
	for (;;) {
		// Scan through table looking for zombie children.
		havekids = 0;
80104834:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010483b:	c7 45 f4 74 19 11 80 	movl   $0x80111974,-0xc(%ebp)
80104842:	e9 9d 00 00 00       	jmp    801048e4 <wait+0xc2>
			if (p->parent != proc)
80104847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484a:	8b 50 14             	mov    0x14(%eax),%edx
8010484d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104853:	39 c2                	cmp    %eax,%edx
80104855:	74 05                	je     8010485c <wait+0x3a>
				continue;
80104857:	e9 81 00 00 00       	jmp    801048dd <wait+0xbb>
			havekids = 1;
8010485c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
			if (p->state == ZOMBIE) {
80104863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104866:	8b 40 0c             	mov    0xc(%eax),%eax
80104869:	83 f8 05             	cmp    $0x5,%eax
8010486c:	75 6f                	jne    801048dd <wait+0xbb>
				// Found one.
				pid = p->pid;
8010486e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104871:	8b 40 10             	mov    0x10(%eax),%eax
80104874:	89 45 ec             	mov    %eax,-0x14(%ebp)
				kfree(p->kstack);
80104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487a:	8b 40 08             	mov    0x8(%eax),%eax
8010487d:	89 04 24             	mov    %eax,(%esp)
80104880:	e8 b7 e1 ff ff       	call   80102a3c <kfree>
				p->kstack = 0;
80104885:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104888:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				freevm(p->pgdir);
8010488f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104892:	8b 40 04             	mov    0x4(%eax),%eax
80104895:	89 04 24             	mov    %eax,(%esp)
80104898:	e8 b6 3e 00 00       	call   80108753 <freevm>
				p->state = UNUSED;
8010489d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				p->pid = 0;
801048a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048aa:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
				p->parent = 0;
801048b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
				p->name[0] = 0;
801048bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048be:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
				p->killed = 0;
801048c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c5:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
				release(&ptable.lock);
801048cc:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
801048d3:	e8 4f 0a 00 00       	call   80105327 <release>
				return pid;
801048d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048db:	eb 55                	jmp    80104932 <wait+0x110>

	acquire(&ptable.lock);
	for (;;) {
		// Scan through table looking for zombie children.
		havekids = 0;
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048dd:	81 45 f4 38 10 00 00 	addl   $0x1038,-0xc(%ebp)
801048e4:	81 7d f4 74 27 15 80 	cmpl   $0x80152774,-0xc(%ebp)
801048eb:	0f 82 56 ff ff ff    	jb     80104847 <wait+0x25>
				return pid;
			}
		}

		// No point waiting if we don't have any children.
		if (!havekids || proc->killed) {
801048f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801048f5:	74 0d                	je     80104904 <wait+0xe2>
801048f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fd:	8b 40 24             	mov    0x24(%eax),%eax
80104900:	85 c0                	test   %eax,%eax
80104902:	74 13                	je     80104917 <wait+0xf5>
			release(&ptable.lock);
80104904:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
8010490b:	e8 17 0a 00 00       	call   80105327 <release>
			return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104915:	eb 1b                	jmp    80104932 <wait+0x110>
		}

		// Wait for children to exit.  (See wakeup1 call in proc_exit.)
		sleep(proc, &ptable.lock); //DOC: wait-sleep
80104917:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491d:	c7 44 24 04 40 19 11 	movl   $0x80111940,0x4(%esp)
80104924:	80 
80104925:	89 04 24             	mov    %eax,(%esp)
80104928:	e8 27 06 00 00       	call   80104f54 <sleep>
	}
8010492d:	e9 02 ff ff ff       	jmp    80104834 <wait+0x12>
}
80104932:	c9                   	leave  
80104933:	c3                   	ret    

80104934 <wait2>:

int wait2(int* wtime, int* rtime, int* iotime) {
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	83 ec 28             	sub    $0x28,%esp
	//cprintf("wait2");
	struct proc *p;
	int havekids, pid;

	acquire(&ptable.lock);
8010493a:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104941:	e8 7f 09 00 00       	call   801052c5 <acquire>
	for (;;) {
		// Scan through table looking for zombie children.
		havekids = 0;
80104946:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010494d:	c7 45 f4 74 19 11 80 	movl   $0x80111974,-0xc(%ebp)
80104954:	e9 ef 00 00 00       	jmp    80104a48 <wait2+0x114>
			if (p->parent != proc)
80104959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495c:	8b 50 14             	mov    0x14(%eax),%edx
8010495f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104965:	39 c2                	cmp    %eax,%edx
80104967:	74 05                	je     8010496e <wait2+0x3a>
				continue;
80104969:	e9 d3 00 00 00       	jmp    80104a41 <wait2+0x10d>
			havekids = 1;
8010496e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
			if (p->state == ZOMBIE) {
80104975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104978:	8b 40 0c             	mov    0xc(%eax),%eax
8010497b:	83 f8 05             	cmp    $0x5,%eax
8010497e:	0f 85 bd 00 00 00    	jne    80104a41 <wait2+0x10d>
				// Found one.
				pid = p->pid;
80104984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104987:	8b 40 10             	mov    0x10(%eax),%eax
8010498a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				kfree(p->kstack);
8010498d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104990:	8b 40 08             	mov    0x8(%eax),%eax
80104993:	89 04 24             	mov    %eax,(%esp)
80104996:	e8 a1 e0 ff ff       	call   80102a3c <kfree>
				p->kstack = 0;
8010499b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010499e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				freevm(p->pgdir);
801049a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a8:	8b 40 04             	mov    0x4(%eax),%eax
801049ab:	89 04 24             	mov    %eax,(%esp)
801049ae:	e8 a0 3d 00 00       	call   80108753 <freevm>
				p->state = UNUSED;
801049b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				p->pid = 0;
801049bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
				p->parent = 0;
801049c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ca:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
				p->name[0] = 0;
801049d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d4:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
				p->killed = 0;
801049d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049db:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)

				*wtime = (p->etime - p->ctime) - (p->rtime + p->wtime);
801049e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e5:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801049eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ee:	8b 40 7c             	mov    0x7c(%eax),%eax
801049f1:	89 d1                	mov    %edx,%ecx
801049f3:	29 c1                	sub    %eax,%ecx
801049f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f8:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801049fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a01:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104a07:	01 d0                	add    %edx,%eax
80104a09:	29 c1                	sub    %eax,%ecx
80104a0b:	89 c8                	mov    %ecx,%eax
80104a0d:	89 c2                	mov    %eax,%edx
80104a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80104a12:	89 10                	mov    %edx,(%eax)
				*rtime = p->rtime;
80104a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a17:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a20:	89 10                	mov    %edx,(%eax)
				*iotime = p->wtime;
80104a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a25:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104a2b:	8b 45 10             	mov    0x10(%ebp),%eax
80104a2e:	89 10                	mov    %edx,(%eax)
				release(&ptable.lock);
80104a30:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104a37:	e8 eb 08 00 00       	call   80105327 <release>
				return pid;
80104a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a3f:	eb 55                	jmp    80104a96 <wait2+0x162>

	acquire(&ptable.lock);
	for (;;) {
		// Scan through table looking for zombie children.
		havekids = 0;
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a41:	81 45 f4 38 10 00 00 	addl   $0x1038,-0xc(%ebp)
80104a48:	81 7d f4 74 27 15 80 	cmpl   $0x80152774,-0xc(%ebp)
80104a4f:	0f 82 04 ff ff ff    	jb     80104959 <wait2+0x25>
				return pid;
			}
		}

		// No point waiting if we don't have any children.
		if (!havekids || proc->killed) {
80104a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a59:	74 0d                	je     80104a68 <wait2+0x134>
80104a5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a61:	8b 40 24             	mov    0x24(%eax),%eax
80104a64:	85 c0                	test   %eax,%eax
80104a66:	74 13                	je     80104a7b <wait2+0x147>
			release(&ptable.lock);
80104a68:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104a6f:	e8 b3 08 00 00       	call   80105327 <release>
			return -1;
80104a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a79:	eb 1b                	jmp    80104a96 <wait2+0x162>
		}

		// Wait for children to exit.  (See wakeup1 call in proc_exit.)
		sleep(proc, &ptable.lock); //DOC: wait-sleep
80104a7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a81:	c7 44 24 04 40 19 11 	movl   $0x80111940,0x4(%esp)
80104a88:	80 
80104a89:	89 04 24             	mov    %eax,(%esp)
80104a8c:	e8 c3 04 00 00       	call   80104f54 <sleep>
	}
80104a91:	e9 b0 fe ff ff       	jmp    80104946 <wait2+0x12>
}
80104a96:	c9                   	leave  
80104a97:	c3                   	ret    

80104a98 <get_sched_record>:

int get_sched_record(int *s_tick, int *e_tick, int *cpu) {
80104a98:	55                   	push   %ebp
80104a99:	89 e5                	mov    %esp,%ebp
	return 0;
80104a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104aa0:	5d                   	pop    %ebp
80104aa1:	c3                   	ret    

80104aa2 <getPriority>:

int getPriority(int* pid) {
80104aa2:	55                   	push   %ebp
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	acquire(&ptable.lock);
80104aa8:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104aaf:	e8 11 08 00 00       	call   801052c5 <acquire>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) { //scan table for pid
80104ab4:	c7 45 f4 74 19 11 80 	movl   $0x80111974,-0xc(%ebp)
80104abb:	eb 2d                	jmp    80104aea <getPriority+0x48>
		if (*pid == p->pid) {
80104abd:	8b 45 08             	mov    0x8(%ebp),%eax
80104ac0:	8b 10                	mov    (%eax),%edx
80104ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac5:	8b 40 10             	mov    0x10(%eax),%eax
80104ac8:	39 c2                	cmp    %eax,%edx
80104aca:	75 17                	jne    80104ae3 <getPriority+0x41>
			release(&ptable.lock);
80104acc:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104ad3:	e8 4f 08 00 00       	call   80105327 <release>
			return p->priority;
80104ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104adb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104ae1:	eb 21                	jmp    80104b04 <getPriority+0x62>
}

int getPriority(int* pid) {
	struct proc *p;
	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) { //scan table for pid
80104ae3:	81 45 f4 38 10 00 00 	addl   $0x1038,-0xc(%ebp)
80104aea:	81 7d f4 74 27 15 80 	cmpl   $0x80152774,-0xc(%ebp)
80104af1:	72 ca                	jb     80104abd <getPriority+0x1b>
		if (*pid == p->pid) {
			release(&ptable.lock);
			return p->priority;
		}
	}
	release(&ptable.lock);
80104af3:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104afa:	e8 28 08 00 00       	call   80105327 <release>
	return 0;
80104aff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b04:	c9                   	leave  
80104b05:	c3                   	ret    

80104b06 <register_handler>:

void register_handler(sighandler_t sighandler) {
80104b06:	55                   	push   %ebp
80104b07:	89 e5                	mov    %esp,%ebp
80104b09:	83 ec 28             	sub    $0x28,%esp
	char* addr = uva2ka(proc->pgdir, (char*) proc->tf->esp);
80104b0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b12:	8b 40 18             	mov    0x18(%eax),%eax
80104b15:	8b 40 44             	mov    0x44(%eax),%eax
80104b18:	89 c2                	mov    %eax,%edx
80104b1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b20:	8b 40 04             	mov    0x4(%eax),%eax
80104b23:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b27:	89 04 24             	mov    %eax,(%esp)
80104b2a:	e8 15 3e 00 00       	call   80108944 <uva2ka>
80104b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((proc->tf->esp & 0xFFF) == 0)
80104b32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b38:	8b 40 18             	mov    0x18(%eax),%eax
80104b3b:	8b 40 44             	mov    0x44(%eax),%eax
80104b3e:	25 ff 0f 00 00       	and    $0xfff,%eax
80104b43:	85 c0                	test   %eax,%eax
80104b45:	75 0c                	jne    80104b53 <register_handler+0x4d>
		panic("esp_offset == 0");
80104b47:	c7 04 24 55 8d 10 80 	movl   $0x80108d55,(%esp)
80104b4e:	e8 e7 b9 ff ff       	call   8010053a <panic>

	/* open a new frame */
	*(int*) (addr + ((proc->tf->esp - 4) & 0xFFF)) = proc->tf->eip;
80104b53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b59:	8b 40 18             	mov    0x18(%eax),%eax
80104b5c:	8b 40 44             	mov    0x44(%eax),%eax
80104b5f:	83 e8 04             	sub    $0x4,%eax
80104b62:	25 ff 0f 00 00       	and    $0xfff,%eax
80104b67:	89 c2                	mov    %eax,%edx
80104b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6c:	01 c2                	add    %eax,%edx
80104b6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b74:	8b 40 18             	mov    0x18(%eax),%eax
80104b77:	8b 40 38             	mov    0x38(%eax),%eax
80104b7a:	89 02                	mov    %eax,(%edx)
	proc->tf->esp -= 4;
80104b7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b82:	8b 40 18             	mov    0x18(%eax),%eax
80104b85:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b8c:	8b 52 18             	mov    0x18(%edx),%edx
80104b8f:	8b 52 44             	mov    0x44(%edx),%edx
80104b92:	83 ea 04             	sub    $0x4,%edx
80104b95:	89 50 44             	mov    %edx,0x44(%eax)

	/* update eip */
	proc->tf->eip = (uint) sighandler;
80104b98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b9e:	8b 40 18             	mov    0x18(%eax),%eax
80104ba1:	8b 55 08             	mov    0x8(%ebp),%edx
80104ba4:	89 50 38             	mov    %edx,0x38(%eax)
}
80104ba7:	c9                   	leave  
80104ba8:	c3                   	ret    

80104ba9 <scheduler>:
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void scheduler(void) {
80104ba9:	55                   	push   %ebp
80104baa:	89 e5                	mov    %esp,%ebp
80104bac:	83 ec 38             	sub    $0x38,%esp
	struct proc *p;

	for (;;) {
		// Enable interrupts on this processor.
		sti();
80104baf:	e8 fa f3 ff ff       	call   80103fae <sti>

		// Loop over process table looking for process to run.
		acquire(&ptable.lock);
80104bb4:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104bbb:	e8 05 07 00 00       	call   801052c5 <acquire>

		// Process is done running for now.
		// It should have changed its p->state before coming back.
		proc = 0;
#endif
		release(&ptable.lock);
80104bc0:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104bc7:	e8 5b 07 00 00       	call   80105327 <release>

#ifdef MC_FRR
		acquire(&(cpu->lock));
80104bcc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bd2:	05 c8 01 00 00       	add    $0x1c8,%eax
80104bd7:	89 04 24             	mov    %eax,(%esp)
80104bda:	e8 e6 06 00 00       	call   801052c5 <acquire>
		p = cpuQueuePop(cpu);
80104bdf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104be5:	89 04 24             	mov    %eax,(%esp)
80104be8:	e8 ec f4 ff ff       	call   801040d9 <cpuQueuePop>
80104bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		release(&(cpu->lock));
80104bf0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bf6:	05 c8 01 00 00       	add    $0x1c8,%eax
80104bfb:	89 04 24             	mov    %eax,(%esp)
80104bfe:	e8 24 07 00 00       	call   80105327 <release>
		if(p != 0) {
80104c03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c07:	0f 84 d1 00 00 00    	je     80104cde <scheduler+0x135>
			if(p->state == RUNNABLE) {
80104c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c10:	8b 40 0c             	mov    0xc(%eax),%eax
80104c13:	83 f8 03             	cmp    $0x3,%eax
80104c16:	0f 85 ee 01 00 00    	jne    80104e0a <scheduler+0x261>
				acquire(&(cpu->lock));
80104c1c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c22:	05 c8 01 00 00       	add    $0x1c8,%eax
80104c27:	89 04 24             	mov    %eax,(%esp)
80104c2a:	e8 96 06 00 00       	call   801052c5 <acquire>
				proc = p;
80104c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c32:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
				switchuvm(p);
80104c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c3b:	89 04 24             	mov    %eax,(%esp)
80104c3e:	e8 9d 36 00 00       	call   801082e0 <switchuvm>
				p->state = RUNNING;
80104c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c46:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
				struct cpuProc info = {ticks,0,cpu->id};
80104c4d:	a1 c0 32 15 80       	mov    0x801532c0,%eax
80104c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104c55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104c5c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c62:	0f b6 00             	movzbl (%eax),%eax
80104c65:	88 45 ec             	mov    %al,-0x14(%ebp)
				p->schedulingInfo[p->timesScheduled++] = &info;
80104c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c6b:	8b 80 34 10 00 00    	mov    0x1034(%eax),%eax
80104c71:	8d 48 01             	lea    0x1(%eax),%ecx
80104c74:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c77:	89 8a 34 10 00 00    	mov    %ecx,0x1034(%edx)
80104c7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c80:	8d 48 24             	lea    0x24(%eax),%ecx
80104c83:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104c86:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
				p->quanta = 0;
80104c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c8d:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104c94:	00 00 00 
				swtch(&cpu->scheduler, proc->context);
80104c97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c9d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ca0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ca7:	83 c2 04             	add    $0x4,%edx
80104caa:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cae:	89 14 24             	mov    %edx,(%esp)
80104cb1:	e8 f4 0a 00 00       	call   801057aa <swtch>
				switchkvm();
80104cb6:	e8 08 36 00 00       	call   801082c3 <switchkvm>

				// Process is done running for now.
				// It should have changed its p->state before coming back.
				proc = 0;
80104cbb:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104cc2:	00 00 00 00 
				release(&(cpu->lock));
80104cc6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ccc:	05 c8 01 00 00       	add    $0x1c8,%eax
80104cd1:	89 04 24             	mov    %eax,(%esp)
80104cd4:	e8 4e 06 00 00       	call   80105327 <release>
					release(&(cpu->lock));
				}
			}
		}
#endif
	}
80104cd9:	e9 d1 fe ff ff       	jmp    80104baf <scheduler+0x6>
				proc = 0;
				release(&(cpu->lock));
			}
		} else {
			struct cpu * newCpu;
			for(newCpu = cpus; newCpu < &cpus[NCPU]; newCpu++) {
80104cde:	c7 45 f4 40 09 11 80 	movl   $0x80110940,-0xc(%ebp)
80104ce5:	eb 16                	jmp    80104cfd <scheduler+0x154>
				if(newCpu->numOfProcs > 0) {
80104ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cea:	8b 80 c4 01 00 00    	mov    0x1c4(%eax),%eax
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	7e 02                	jle    80104cf6 <scheduler+0x14d>
					break;
80104cf4:	eb 10                	jmp    80104d06 <scheduler+0x15d>
				proc = 0;
				release(&(cpu->lock));
			}
		} else {
			struct cpu * newCpu;
			for(newCpu = cpus; newCpu < &cpus[NCPU]; newCpu++) {
80104cf6:	81 45 f4 fc 01 00 00 	addl   $0x1fc,-0xc(%ebp)
80104cfd:	81 7d f4 20 19 11 80 	cmpl   $0x80111920,-0xc(%ebp)
80104d04:	72 e1                	jb     80104ce7 <scheduler+0x13e>
				if(newCpu->numOfProcs > 0) {
					break;
				}
			}
			if(newCpu != '\0') {
80104d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d0a:	0f 84 fa 00 00 00    	je     80104e0a <scheduler+0x261>
				acquire(&(newCpu->lock));
80104d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d13:	05 c8 01 00 00       	add    $0x1c8,%eax
80104d18:	89 04 24             	mov    %eax,(%esp)
80104d1b:	e8 a5 05 00 00       	call   801052c5 <acquire>
				p = cpuQueuePop(newCpu);
80104d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d23:	89 04 24             	mov    %eax,(%esp)
80104d26:	e8 ae f3 ff ff       	call   801040d9 <cpuQueuePop>
80104d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				release(&(newCpu->lock));
80104d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d31:	05 c8 01 00 00       	add    $0x1c8,%eax
80104d36:	89 04 24             	mov    %eax,(%esp)
80104d39:	e8 e9 05 00 00       	call   80105327 <release>
				if(p != '\0') {
80104d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104d42:	0f 84 c2 00 00 00    	je     80104e0a <scheduler+0x261>
					acquire(&(cpu->lock));
80104d48:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d4e:	05 c8 01 00 00       	add    $0x1c8,%eax
80104d53:	89 04 24             	mov    %eax,(%esp)
80104d56:	e8 6a 05 00 00       	call   801052c5 <acquire>
					proc = p;
80104d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d5e:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
					switchuvm(p);
80104d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d67:	89 04 24             	mov    %eax,(%esp)
80104d6a:	e8 71 35 00 00       	call   801082e0 <switchuvm>
					p->state = RUNNING;
80104d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d72:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
					struct cpuProc info = {ticks,0,cpu->id};
80104d79:	a1 c0 32 15 80       	mov    0x801532c0,%eax
80104d7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104d81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104d88:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d8e:	0f b6 00             	movzbl (%eax),%eax
80104d91:	88 45 e0             	mov    %al,-0x20(%ebp)
					p->schedulingInfo[p->timesScheduled++] = &info;
80104d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d97:	8b 80 34 10 00 00    	mov    0x1034(%eax),%eax
80104d9d:	8d 48 01             	lea    0x1(%eax),%ecx
80104da0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104da3:	89 8a 34 10 00 00    	mov    %ecx,0x1034(%edx)
80104da9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104dac:	8d 48 24             	lea    0x24(%eax),%ecx
80104daf:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104db2:	89 44 8a 04          	mov    %eax,0x4(%edx,%ecx,4)
					p->quanta = 0;
80104db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104db9:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104dc0:	00 00 00 
					swtch(&cpu->scheduler, proc->context);
80104dc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc9:	8b 40 1c             	mov    0x1c(%eax),%eax
80104dcc:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104dd3:	83 c2 04             	add    $0x4,%edx
80104dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dda:	89 14 24             	mov    %edx,(%esp)
80104ddd:	e8 c8 09 00 00       	call   801057aa <swtch>
					switchkvm();
80104de2:	e8 dc 34 00 00       	call   801082c3 <switchkvm>

					// Process is done running for now.
					// It should have changed its p->state before coming back.
					proc = 0;
80104de7:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104dee:	00 00 00 00 
					release(&(cpu->lock));
80104df2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104df8:	05 c8 01 00 00       	add    $0x1c8,%eax
80104dfd:	89 04 24             	mov    %eax,(%esp)
80104e00:	e8 22 05 00 00       	call   80105327 <release>
				}
			}
		}
#endif
	}
80104e05:	e9 a5 fd ff ff       	jmp    80104baf <scheduler+0x6>
80104e0a:	e9 a0 fd ff ff       	jmp    80104baf <scheduler+0x6>

80104e0f <sched>:
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void sched(void) {
80104e0f:	55                   	push   %ebp
80104e10:	89 e5                	mov    %esp,%ebp
80104e12:	83 ec 28             	sub    $0x28,%esp
#ifndef MC_FRR
	if (!holding(&ptable.lock))
		panic("sched ptable.lock");
#else
	if(!holding(&(cpu->lock)))
80104e15:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e1b:	05 c8 01 00 00       	add    $0x1c8,%eax
80104e20:	89 04 24             	mov    %eax,(%esp)
80104e23:	e8 c7 05 00 00       	call   801053ef <holding>
80104e28:	85 c0                	test   %eax,%eax
80104e2a:	75 0c                	jne    80104e38 <sched+0x29>
	panic("sched cpu->lock");
80104e2c:	c7 04 24 65 8d 10 80 	movl   $0x80108d65,(%esp)
80104e33:	e8 02 b7 ff ff       	call   8010053a <panic>
#endif

	int intena;

	if (cpu->ncli != 1)
80104e38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e3e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e44:	83 f8 01             	cmp    $0x1,%eax
80104e47:	74 0c                	je     80104e55 <sched+0x46>
		panic("sched locks");
80104e49:	c7 04 24 75 8d 10 80 	movl   $0x80108d75,(%esp)
80104e50:	e8 e5 b6 ff ff       	call   8010053a <panic>
	if (proc->state == RUNNING)
80104e55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5b:	8b 40 0c             	mov    0xc(%eax),%eax
80104e5e:	83 f8 04             	cmp    $0x4,%eax
80104e61:	75 0c                	jne    80104e6f <sched+0x60>
		panic("sched running");
80104e63:	c7 04 24 81 8d 10 80 	movl   $0x80108d81,(%esp)
80104e6a:	e8 cb b6 ff ff       	call   8010053a <panic>
	if (readeflags() & FL_IF)
80104e6f:	e8 2a f1 ff ff       	call   80103f9e <readeflags>
80104e74:	25 00 02 00 00       	and    $0x200,%eax
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	74 0c                	je     80104e89 <sched+0x7a>
		panic("sched interruptible");
80104e7d:	c7 04 24 8f 8d 10 80 	movl   $0x80108d8f,(%esp)
80104e84:	e8 b1 b6 ff ff       	call   8010053a <panic>
	intena = cpu->intena;
80104e89:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e8f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	swtch(&proc->context, cpu->scheduler);
80104e98:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e9e:	8b 40 04             	mov    0x4(%eax),%eax
80104ea1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ea8:	83 c2 1c             	add    $0x1c,%edx
80104eab:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eaf:	89 14 24             	mov    %edx,(%esp)
80104eb2:	e8 f3 08 00 00       	call   801057aa <swtch>
	cpu->intena = intena;
80104eb7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ec0:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104ec6:	c9                   	leave  
80104ec7:	c3                   	ret    

80104ec8 <yield>:

// Give up the CPU for one scheduling round.
void yield(void) {
80104ec8:	55                   	push   %ebp
80104ec9:	89 e5                	mov    %esp,%ebp
80104ecb:	83 ec 18             	sub    $0x18,%esp
#ifndef MC_FRR
	acquire(&ptable.lock); //DOC: yieldlock
#endif
	proc->state = RUNNABLE;
80104ece:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ed4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	if( (proc->quanta % QUANTA == 0) && (proc-> priority != 2)) {
		proc->priority++;
	}
	queuePush(proc, proc->priority);
#elif MC_FRR
	cpuQueuePush(proc, cpu);
80104edb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ee2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ee8:	89 54 24 04          	mov    %edx,0x4(%esp)
80104eec:	89 04 24             	mov    %eax,(%esp)
80104eef:	e8 5c f1 ff ff       	call   80104050 <cpuQueuePush>
	acquire(&(cpu->lock));
80104ef4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104efa:	05 c8 01 00 00       	add    $0x1c8,%eax
80104eff:	89 04 24             	mov    %eax,(%esp)
80104f02:	e8 be 03 00 00       	call   801052c5 <acquire>
#endif
	sched();
80104f07:	e8 03 ff ff ff       	call   80104e0f <sched>
#ifndef MC_FRR
	release(&ptable.lock);
#else
	release(&(cpu->lock));
80104f0c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f12:	05 c8 01 00 00       	add    $0x1c8,%eax
80104f17:	89 04 24             	mov    %eax,(%esp)
80104f1a:	e8 08 04 00 00       	call   80105327 <release>
#endif
}
80104f1f:	c9                   	leave  
80104f20:	c3                   	ret    

80104f21 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
80104f21:	55                   	push   %ebp
80104f22:	89 e5                	mov    %esp,%ebp
80104f24:	83 ec 18             	sub    $0x18,%esp
#ifndef MC_FRR
	// Still holding ptable.lock from scheduler.
	release(&ptable.lock);
#else
	// Still holding cpu->lock from scheduler.
	release(&(cpu->lock));
80104f27:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f2d:	05 c8 01 00 00       	add    $0x1c8,%eax
80104f32:	89 04 24             	mov    %eax,(%esp)
80104f35:	e8 ed 03 00 00       	call   80105327 <release>
#endif

	if (first) {
80104f3a:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104f3f:	85 c0                	test   %eax,%eax
80104f41:	74 0f                	je     80104f52 <forkret+0x31>
		// Some initialization functions must be run in the context
		// of a regular process (e.g., they call sleep), and thus cannot
		// be run from main().
		first = 0;
80104f43:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104f4a:	00 00 00 
		initlog();
80104f4d:	e8 78 e0 ff ff       	call   80102fca <initlog>
	}

	// Return to "caller", actually trapret (see allocproc).
}
80104f52:	c9                   	leave  
80104f53:	c3                   	ret    

80104f54 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	83 ec 18             	sub    $0x18,%esp
	if (proc == 0)
80104f5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f60:	85 c0                	test   %eax,%eax
80104f62:	75 0c                	jne    80104f70 <sleep+0x1c>
		panic("sleep");
80104f64:	c7 04 24 a3 8d 10 80 	movl   $0x80108da3,(%esp)
80104f6b:	e8 ca b5 ff ff       	call   8010053a <panic>

	if (lk == 0)
80104f70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f74:	75 0c                	jne    80104f82 <sleep+0x2e>
		panic("sleep without lk");
80104f76:	c7 04 24 a9 8d 10 80 	movl   $0x80108da9,(%esp)
80104f7d:	e8 b8 b5 ff ff       	call   8010053a <panic>
	// change p->state and then call sched.
	// Once we hold ptable.lock, we can be
	// guaranteed that we won't miss any wakeup
	// (wakeup runs with ptable.lock locked),
	// so it's okay to release lk.
	if (lk != &ptable.lock) { //DOC: sleeplock0
80104f82:	81 7d 0c 40 19 11 80 	cmpl   $0x80111940,0xc(%ebp)
80104f89:	74 17                	je     80104fa2 <sleep+0x4e>
		acquire(&ptable.lock); //DOC: sleeplock1
80104f8b:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104f92:	e8 2e 03 00 00       	call   801052c5 <acquire>
		release(lk);
80104f97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f9a:	89 04 24             	mov    %eax,(%esp)
80104f9d:	e8 85 03 00 00       	call   80105327 <release>
	}

	// Go to sleep.
	proc->chan = chan;
80104fa2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa8:	8b 55 08             	mov    0x8(%ebp),%edx
80104fab:	89 50 20             	mov    %edx,0x20(%eax)
	proc->state = SLEEPING;
80104fae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fb4:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	proc->quanta = 0;
80104fbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fc1:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104fc8:	00 00 00 

#ifdef MC_FRR
	if(lk != &cpu->lock) {
80104fcb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fd1:	05 c8 01 00 00       	add    $0x1c8,%eax
80104fd6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80104fd9:	74 1f                	je     80104ffa <sleep+0xa6>
		acquire(&cpu->lock);
80104fdb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fe1:	05 c8 01 00 00       	add    $0x1c8,%eax
80104fe6:	89 04 24             	mov    %eax,(%esp)
80104fe9:	e8 d7 02 00 00       	call   801052c5 <acquire>
		release(&ptable.lock);
80104fee:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80104ff5:	e8 2d 03 00 00       	call   80105327 <release>
	}
#endif

	sched();
80104ffa:	e8 10 fe ff ff       	call   80104e0f <sched>

	// Tidy up.
	proc->chan = 0;
80104fff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105005:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

#ifdef MC_FRR
	// Reacquire original lock.
	if(lk != &cpu->lock) { //DOC: sleeplock2
8010500c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105012:	05 c8 01 00 00       	add    $0x1c8,%eax
80105017:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010501a:	74 1e                	je     8010503a <sleep+0xe6>
		release(&cpu->lock);
8010501c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105022:	05 c8 01 00 00       	add    $0x1c8,%eax
80105027:	89 04 24             	mov    %eax,(%esp)
8010502a:	e8 f8 02 00 00       	call   80105327 <release>
		acquire(lk);
8010502f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105032:	89 04 24             	mov    %eax,(%esp)
80105035:	e8 8b 02 00 00       	call   801052c5 <acquire>
	if (lk != &ptable.lock) { //DOC: sleeplock2
		release(&ptable.lock);
		acquire(lk);
	}
#endif
}
8010503a:	c9                   	leave  
8010503b:	c3                   	ret    

8010503c <wakeup1>:

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
8010503c:	55                   	push   %ebp
8010503d:	89 e5                	mov    %esp,%ebp
8010503f:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105042:	c7 45 f4 74 19 11 80 	movl   $0x80111974,-0xc(%ebp)
80105049:	eb 48                	jmp    80105093 <wakeup1+0x57>
		if (p->state == SLEEPING && p->chan == chan) {
8010504b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504e:	8b 40 0c             	mov    0xc(%eax),%eax
80105051:	83 f8 02             	cmp    $0x2,%eax
80105054:	75 36                	jne    8010508c <wakeup1+0x50>
80105056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105059:	8b 40 20             	mov    0x20(%eax),%eax
8010505c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010505f:	75 2b                	jne    8010508c <wakeup1+0x50>
			p->state = RUNNABLE;
80105061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105064:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
			p->quanta = 0;
8010506b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506e:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80105075:	00 00 00 
#elif MLQ
			if(p->priority != 0)
			p->priority--;
			queuePush(p, p->priority);
#elif MC_FRR
			cpuQueuePush(p, minProcCpuGet());
80105078:	e8 ce f0 ff ff       	call   8010414b <minProcCpuGet>
8010507d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105084:	89 04 24             	mov    %eax,(%esp)
80105087:	e8 c4 ef ff ff       	call   80104050 <cpuQueuePush>
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
	struct proc *p;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010508c:	81 45 f4 38 10 00 00 	addl   $0x1038,-0xc(%ebp)
80105093:	81 7d f4 74 27 15 80 	cmpl   $0x80152774,-0xc(%ebp)
8010509a:	72 af                	jb     8010504b <wakeup1+0xf>
#elif MC_FRR
			cpuQueuePush(p, minProcCpuGet());
#endif
		}
	}
}
8010509c:	c9                   	leave  
8010509d:	c3                   	ret    

8010509e <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
8010509e:	55                   	push   %ebp
8010509f:	89 e5                	mov    %esp,%ebp
801050a1:	83 ec 18             	sub    $0x18,%esp
	acquire(&ptable.lock);
801050a4:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
801050ab:	e8 15 02 00 00       	call   801052c5 <acquire>
	wakeup1(chan);
801050b0:	8b 45 08             	mov    0x8(%ebp),%eax
801050b3:	89 04 24             	mov    %eax,(%esp)
801050b6:	e8 81 ff ff ff       	call   8010503c <wakeup1>
	release(&ptable.lock);
801050bb:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
801050c2:	e8 60 02 00 00       	call   80105327 <release>
}
801050c7:	c9                   	leave  
801050c8:	c3                   	ret    

801050c9 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
801050c9:	55                   	push   %ebp
801050ca:	89 e5                	mov    %esp,%ebp
801050cc:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;

	acquire(&ptable.lock);
801050cf:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
801050d6:	e8 ea 01 00 00       	call   801052c5 <acquire>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801050db:	c7 45 f4 74 19 11 80 	movl   $0x80111974,-0xc(%ebp)
801050e2:	eb 74                	jmp    80105158 <kill+0x8f>
		if (p->pid == pid) {
801050e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e7:	8b 40 10             	mov    0x10(%eax),%eax
801050ea:	3b 45 08             	cmp    0x8(%ebp),%eax
801050ed:	75 62                	jne    80105151 <kill+0x88>
			p->killed = 1;
801050ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
			p->etime = ticks;
801050f9:	8b 15 c0 32 15 80    	mov    0x801532c0,%edx
801050ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105102:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
			p->quanta = 0;
80105108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010510b:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80105112:	00 00 00 
			// Wake process from sleep if necessary.
			if (p->state == SLEEPING) {
80105115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105118:	8b 40 0c             	mov    0xc(%eax),%eax
8010511b:	83 f8 02             	cmp    $0x2,%eax
8010511e:	75 1e                	jne    8010513e <kill+0x75>
				p->state = RUNNABLE;
80105120:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105123:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
#elif MLQ
				if(p->priority != 0)
				p->priority--;
				queuePush(p, p->priority);
#elif MC_FRR
				cpuQueuePush(p, minProcCpuGet());
8010512a:	e8 1c f0 ff ff       	call   8010414b <minProcCpuGet>
8010512f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105136:	89 04 24             	mov    %eax,(%esp)
80105139:	e8 12 ef ff ff       	call   80104050 <cpuQueuePush>
#endif
			}

			release(&ptable.lock);
8010513e:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80105145:	e8 dd 01 00 00       	call   80105327 <release>
			return 0;
8010514a:	b8 00 00 00 00       	mov    $0x0,%eax
8010514f:	eb 21                	jmp    80105172 <kill+0xa9>
// to user space (see trap in trap.c).
int kill(int pid) {
	struct proc *p;

	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105151:	81 45 f4 38 10 00 00 	addl   $0x1038,-0xc(%ebp)
80105158:	81 7d f4 74 27 15 80 	cmpl   $0x80152774,-0xc(%ebp)
8010515f:	72 83                	jb     801050e4 <kill+0x1b>

			release(&ptable.lock);
			return 0;
		}
	}
	release(&ptable.lock);
80105161:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80105168:	e8 ba 01 00 00       	call   80105327 <release>
	return -1;
8010516d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105172:	c9                   	leave  
80105173:	c3                   	ret    

80105174 <procdump>:

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	83 ec 58             	sub    $0x58,%esp
	int i;
	struct proc *p;
	char *state;
	uint pc[10];

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010517a:	c7 45 f0 74 19 11 80 	movl   $0x80111974,-0x10(%ebp)
80105181:	e9 d9 00 00 00       	jmp    8010525f <procdump+0xeb>
		if (p->state == UNUSED)
80105186:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105189:	8b 40 0c             	mov    0xc(%eax),%eax
8010518c:	85 c0                	test   %eax,%eax
8010518e:	75 05                	jne    80105195 <procdump+0x21>
			continue;
80105190:	e9 c3 00 00 00       	jmp    80105258 <procdump+0xe4>
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105195:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105198:	8b 40 0c             	mov    0xc(%eax),%eax
8010519b:	83 f8 05             	cmp    $0x5,%eax
8010519e:	77 23                	ja     801051c3 <procdump+0x4f>
801051a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a3:	8b 40 0c             	mov    0xc(%eax),%eax
801051a6:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801051ad:	85 c0                	test   %eax,%eax
801051af:	74 12                	je     801051c3 <procdump+0x4f>
			state = states[p->state];
801051b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051b4:	8b 40 0c             	mov    0xc(%eax),%eax
801051b7:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801051be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801051c1:	eb 07                	jmp    801051ca <procdump+0x56>
		else
			state = "???";
801051c3:	c7 45 ec ba 8d 10 80 	movl   $0x80108dba,-0x14(%ebp)
		cprintf("%d %s %s", p->pid, state, p->name);
801051ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051cd:	8d 50 6c             	lea    0x6c(%eax),%edx
801051d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051d3:	8b 40 10             	mov    0x10(%eax),%eax
801051d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
801051da:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051dd:	89 54 24 08          	mov    %edx,0x8(%esp)
801051e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e5:	c7 04 24 be 8d 10 80 	movl   $0x80108dbe,(%esp)
801051ec:	e8 af b1 ff ff       	call   801003a0 <cprintf>
		if (p->state == SLEEPING) {
801051f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051f4:	8b 40 0c             	mov    0xc(%eax),%eax
801051f7:	83 f8 02             	cmp    $0x2,%eax
801051fa:	75 50                	jne    8010524c <procdump+0xd8>
			getcallerpcs((uint*) p->context->ebp + 2, pc);
801051fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ff:	8b 40 1c             	mov    0x1c(%eax),%eax
80105202:	8b 40 0c             	mov    0xc(%eax),%eax
80105205:	83 c0 08             	add    $0x8,%eax
80105208:	8d 55 c4             	lea    -0x3c(%ebp),%edx
8010520b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010520f:	89 04 24             	mov    %eax,(%esp)
80105212:	e8 5f 01 00 00       	call   80105376 <getcallerpcs>
			for (i = 0; i < 10 && pc[i] != 0; i++)
80105217:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010521e:	eb 1b                	jmp    8010523b <procdump+0xc7>
				cprintf(" %p", pc[i]);
80105220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105223:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105227:	89 44 24 04          	mov    %eax,0x4(%esp)
8010522b:	c7 04 24 c7 8d 10 80 	movl   $0x80108dc7,(%esp)
80105232:	e8 69 b1 ff ff       	call   801003a0 <cprintf>
		else
			state = "???";
		cprintf("%d %s %s", p->pid, state, p->name);
		if (p->state == SLEEPING) {
			getcallerpcs((uint*) p->context->ebp + 2, pc);
			for (i = 0; i < 10 && pc[i] != 0; i++)
80105237:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010523b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010523f:	7f 0b                	jg     8010524c <procdump+0xd8>
80105241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105244:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105248:	85 c0                	test   %eax,%eax
8010524a:	75 d4                	jne    80105220 <procdump+0xac>
				cprintf(" %p", pc[i]);
		}
		cprintf("\n");
8010524c:	c7 04 24 cb 8d 10 80 	movl   $0x80108dcb,(%esp)
80105253:	e8 48 b1 ff ff       	call   801003a0 <cprintf>
	int i;
	struct proc *p;
	char *state;
	uint pc[10];

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105258:	81 45 f0 38 10 00 00 	addl   $0x1038,-0x10(%ebp)
8010525f:	81 7d f0 74 27 15 80 	cmpl   $0x80152774,-0x10(%ebp)
80105266:	0f 82 1a ff ff ff    	jb     80105186 <procdump+0x12>
			for (i = 0; i < 10 && pc[i] != 0; i++)
				cprintf(" %p", pc[i]);
		}
		cprintf("\n");
	}
}
8010526c:	c9                   	leave  
8010526d:	c3                   	ret    

8010526e <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010526e:	55                   	push   %ebp
8010526f:	89 e5                	mov    %esp,%ebp
80105271:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105274:	9c                   	pushf  
80105275:	58                   	pop    %eax
80105276:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105279:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010527c:	c9                   	leave  
8010527d:	c3                   	ret    

8010527e <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010527e:	55                   	push   %ebp
8010527f:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105281:	fa                   	cli    
}
80105282:	5d                   	pop    %ebp
80105283:	c3                   	ret    

80105284 <sti>:

static inline void
sti(void)
{
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105287:	fb                   	sti    
}
80105288:	5d                   	pop    %ebp
80105289:	c3                   	ret    

8010528a <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010528a:	55                   	push   %ebp
8010528b:	89 e5                	mov    %esp,%ebp
8010528d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105290:	8b 55 08             	mov    0x8(%ebp),%edx
80105293:	8b 45 0c             	mov    0xc(%ebp),%eax
80105296:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105299:	f0 87 02             	lock xchg %eax,(%edx)
8010529c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010529f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052a2:	c9                   	leave  
801052a3:	c3                   	ret    

801052a4 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801052a4:	55                   	push   %ebp
801052a5:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801052a7:	8b 45 08             	mov    0x8(%ebp),%eax
801052aa:	8b 55 0c             	mov    0xc(%ebp),%edx
801052ad:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801052b0:	8b 45 08             	mov    0x8(%ebp),%eax
801052b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801052b9:	8b 45 08             	mov    0x8(%ebp),%eax
801052bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052c3:	5d                   	pop    %ebp
801052c4:	c3                   	ret    

801052c5 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801052c5:	55                   	push   %ebp
801052c6:	89 e5                	mov    %esp,%ebp
801052c8:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801052cb:	e8 49 01 00 00       	call   80105419 <pushcli>
  if(holding(lk))
801052d0:	8b 45 08             	mov    0x8(%ebp),%eax
801052d3:	89 04 24             	mov    %eax,(%esp)
801052d6:	e8 14 01 00 00       	call   801053ef <holding>
801052db:	85 c0                	test   %eax,%eax
801052dd:	74 0c                	je     801052eb <acquire+0x26>
    panic("acquire");
801052df:	c7 04 24 f7 8d 10 80 	movl   $0x80108df7,(%esp)
801052e6:	e8 4f b2 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801052eb:	90                   	nop
801052ec:	8b 45 08             	mov    0x8(%ebp),%eax
801052ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801052f6:	00 
801052f7:	89 04 24             	mov    %eax,(%esp)
801052fa:	e8 8b ff ff ff       	call   8010528a <xchg>
801052ff:	85 c0                	test   %eax,%eax
80105301:	75 e9                	jne    801052ec <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105303:	8b 45 08             	mov    0x8(%ebp),%eax
80105306:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010530d:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105310:	8b 45 08             	mov    0x8(%ebp),%eax
80105313:	83 c0 0c             	add    $0xc,%eax
80105316:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531a:	8d 45 08             	lea    0x8(%ebp),%eax
8010531d:	89 04 24             	mov    %eax,(%esp)
80105320:	e8 51 00 00 00       	call   80105376 <getcallerpcs>
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    

80105327 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105327:	55                   	push   %ebp
80105328:	89 e5                	mov    %esp,%ebp
8010532a:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
8010532d:	8b 45 08             	mov    0x8(%ebp),%eax
80105330:	89 04 24             	mov    %eax,(%esp)
80105333:	e8 b7 00 00 00       	call   801053ef <holding>
80105338:	85 c0                	test   %eax,%eax
8010533a:	75 0c                	jne    80105348 <release+0x21>
    panic("release");
8010533c:	c7 04 24 ff 8d 10 80 	movl   $0x80108dff,(%esp)
80105343:	e8 f2 b1 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80105348:	8b 45 08             	mov    0x8(%ebp),%eax
8010534b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105352:	8b 45 08             	mov    0x8(%ebp),%eax
80105355:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010535c:	8b 45 08             	mov    0x8(%ebp),%eax
8010535f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105366:	00 
80105367:	89 04 24             	mov    %eax,(%esp)
8010536a:	e8 1b ff ff ff       	call   8010528a <xchg>

  popcli();
8010536f:	e8 e9 00 00 00       	call   8010545d <popcli>
}
80105374:	c9                   	leave  
80105375:	c3                   	ret    

80105376 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105376:	55                   	push   %ebp
80105377:	89 e5                	mov    %esp,%ebp
80105379:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010537c:	8b 45 08             	mov    0x8(%ebp),%eax
8010537f:	83 e8 08             	sub    $0x8,%eax
80105382:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105385:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010538c:	eb 38                	jmp    801053c6 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010538e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105392:	74 38                	je     801053cc <getcallerpcs+0x56>
80105394:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010539b:	76 2f                	jbe    801053cc <getcallerpcs+0x56>
8010539d:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801053a1:	74 29                	je     801053cc <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801053a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801053b0:	01 c2                	add    %eax,%edx
801053b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053b5:	8b 40 04             	mov    0x4(%eax),%eax
801053b8:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801053ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053bd:	8b 00                	mov    (%eax),%eax
801053bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801053c2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053c6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053ca:	7e c2                	jle    8010538e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053cc:	eb 19                	jmp    801053e7 <getcallerpcs+0x71>
    pcs[i] = 0;
801053ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801053db:	01 d0                	add    %edx,%eax
801053dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053e3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053e7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053eb:	7e e1                	jle    801053ce <getcallerpcs+0x58>
    pcs[i] = 0;
}
801053ed:	c9                   	leave  
801053ee:	c3                   	ret    

801053ef <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801053ef:	55                   	push   %ebp
801053f0:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801053f2:	8b 45 08             	mov    0x8(%ebp),%eax
801053f5:	8b 00                	mov    (%eax),%eax
801053f7:	85 c0                	test   %eax,%eax
801053f9:	74 17                	je     80105412 <holding+0x23>
801053fb:	8b 45 08             	mov    0x8(%ebp),%eax
801053fe:	8b 50 08             	mov    0x8(%eax),%edx
80105401:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105407:	39 c2                	cmp    %eax,%edx
80105409:	75 07                	jne    80105412 <holding+0x23>
8010540b:	b8 01 00 00 00       	mov    $0x1,%eax
80105410:	eb 05                	jmp    80105417 <holding+0x28>
80105412:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105417:	5d                   	pop    %ebp
80105418:	c3                   	ret    

80105419 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105419:	55                   	push   %ebp
8010541a:	89 e5                	mov    %esp,%ebp
8010541c:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010541f:	e8 4a fe ff ff       	call   8010526e <readeflags>
80105424:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105427:	e8 52 fe ff ff       	call   8010527e <cli>
  if(cpu->ncli++ == 0)
8010542c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105433:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105439:	8d 48 01             	lea    0x1(%eax),%ecx
8010543c:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105442:	85 c0                	test   %eax,%eax
80105444:	75 15                	jne    8010545b <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105446:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010544c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010544f:	81 e2 00 02 00 00    	and    $0x200,%edx
80105455:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010545b:	c9                   	leave  
8010545c:	c3                   	ret    

8010545d <popcli>:

void
popcli(void)
{
8010545d:	55                   	push   %ebp
8010545e:	89 e5                	mov    %esp,%ebp
80105460:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105463:	e8 06 fe ff ff       	call   8010526e <readeflags>
80105468:	25 00 02 00 00       	and    $0x200,%eax
8010546d:	85 c0                	test   %eax,%eax
8010546f:	74 0c                	je     8010547d <popcli+0x20>
    panic("popcli - interruptible");
80105471:	c7 04 24 07 8e 10 80 	movl   $0x80108e07,(%esp)
80105478:	e8 bd b0 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
8010547d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105483:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105489:	83 ea 01             	sub    $0x1,%edx
8010548c:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105492:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105498:	85 c0                	test   %eax,%eax
8010549a:	79 0c                	jns    801054a8 <popcli+0x4b>
    panic("popcli");
8010549c:	c7 04 24 1e 8e 10 80 	movl   $0x80108e1e,(%esp)
801054a3:	e8 92 b0 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
801054a8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054ae:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054b4:	85 c0                	test   %eax,%eax
801054b6:	75 15                	jne    801054cd <popcli+0x70>
801054b8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054be:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801054c4:	85 c0                	test   %eax,%eax
801054c6:	74 05                	je     801054cd <popcli+0x70>
    sti();
801054c8:	e8 b7 fd ff ff       	call   80105284 <sti>
}
801054cd:	c9                   	leave  
801054ce:	c3                   	ret    

801054cf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801054cf:	55                   	push   %ebp
801054d0:	89 e5                	mov    %esp,%ebp
801054d2:	57                   	push   %edi
801054d3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801054d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054d7:	8b 55 10             	mov    0x10(%ebp),%edx
801054da:	8b 45 0c             	mov    0xc(%ebp),%eax
801054dd:	89 cb                	mov    %ecx,%ebx
801054df:	89 df                	mov    %ebx,%edi
801054e1:	89 d1                	mov    %edx,%ecx
801054e3:	fc                   	cld    
801054e4:	f3 aa                	rep stos %al,%es:(%edi)
801054e6:	89 ca                	mov    %ecx,%edx
801054e8:	89 fb                	mov    %edi,%ebx
801054ea:	89 5d 08             	mov    %ebx,0x8(%ebp)
801054ed:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801054f0:	5b                   	pop    %ebx
801054f1:	5f                   	pop    %edi
801054f2:	5d                   	pop    %ebp
801054f3:	c3                   	ret    

801054f4 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
801054f7:	57                   	push   %edi
801054f8:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801054f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054fc:	8b 55 10             	mov    0x10(%ebp),%edx
801054ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105502:	89 cb                	mov    %ecx,%ebx
80105504:	89 df                	mov    %ebx,%edi
80105506:	89 d1                	mov    %edx,%ecx
80105508:	fc                   	cld    
80105509:	f3 ab                	rep stos %eax,%es:(%edi)
8010550b:	89 ca                	mov    %ecx,%edx
8010550d:	89 fb                	mov    %edi,%ebx
8010550f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105512:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105515:	5b                   	pop    %ebx
80105516:	5f                   	pop    %edi
80105517:	5d                   	pop    %ebp
80105518:	c3                   	ret    

80105519 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105519:	55                   	push   %ebp
8010551a:	89 e5                	mov    %esp,%ebp
8010551c:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
8010551f:	8b 45 08             	mov    0x8(%ebp),%eax
80105522:	83 e0 03             	and    $0x3,%eax
80105525:	85 c0                	test   %eax,%eax
80105527:	75 49                	jne    80105572 <memset+0x59>
80105529:	8b 45 10             	mov    0x10(%ebp),%eax
8010552c:	83 e0 03             	and    $0x3,%eax
8010552f:	85 c0                	test   %eax,%eax
80105531:	75 3f                	jne    80105572 <memset+0x59>
    c &= 0xFF;
80105533:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010553a:	8b 45 10             	mov    0x10(%ebp),%eax
8010553d:	c1 e8 02             	shr    $0x2,%eax
80105540:	89 c2                	mov    %eax,%edx
80105542:	8b 45 0c             	mov    0xc(%ebp),%eax
80105545:	c1 e0 18             	shl    $0x18,%eax
80105548:	89 c1                	mov    %eax,%ecx
8010554a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010554d:	c1 e0 10             	shl    $0x10,%eax
80105550:	09 c1                	or     %eax,%ecx
80105552:	8b 45 0c             	mov    0xc(%ebp),%eax
80105555:	c1 e0 08             	shl    $0x8,%eax
80105558:	09 c8                	or     %ecx,%eax
8010555a:	0b 45 0c             	or     0xc(%ebp),%eax
8010555d:	89 54 24 08          	mov    %edx,0x8(%esp)
80105561:	89 44 24 04          	mov    %eax,0x4(%esp)
80105565:	8b 45 08             	mov    0x8(%ebp),%eax
80105568:	89 04 24             	mov    %eax,(%esp)
8010556b:	e8 84 ff ff ff       	call   801054f4 <stosl>
80105570:	eb 19                	jmp    8010558b <memset+0x72>
  } else
    stosb(dst, c, n);
80105572:	8b 45 10             	mov    0x10(%ebp),%eax
80105575:	89 44 24 08          	mov    %eax,0x8(%esp)
80105579:	8b 45 0c             	mov    0xc(%ebp),%eax
8010557c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105580:	8b 45 08             	mov    0x8(%ebp),%eax
80105583:	89 04 24             	mov    %eax,(%esp)
80105586:	e8 44 ff ff ff       	call   801054cf <stosb>
  return dst;
8010558b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010558e:	c9                   	leave  
8010558f:	c3                   	ret    

80105590 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105596:	8b 45 08             	mov    0x8(%ebp),%eax
80105599:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010559c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801055a2:	eb 30                	jmp    801055d4 <memcmp+0x44>
    if(*s1 != *s2)
801055a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055a7:	0f b6 10             	movzbl (%eax),%edx
801055aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055ad:	0f b6 00             	movzbl (%eax),%eax
801055b0:	38 c2                	cmp    %al,%dl
801055b2:	74 18                	je     801055cc <memcmp+0x3c>
      return *s1 - *s2;
801055b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b7:	0f b6 00             	movzbl (%eax),%eax
801055ba:	0f b6 d0             	movzbl %al,%edx
801055bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055c0:	0f b6 00             	movzbl (%eax),%eax
801055c3:	0f b6 c0             	movzbl %al,%eax
801055c6:	29 c2                	sub    %eax,%edx
801055c8:	89 d0                	mov    %edx,%eax
801055ca:	eb 1a                	jmp    801055e6 <memcmp+0x56>
    s1++, s2++;
801055cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055d0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801055d4:	8b 45 10             	mov    0x10(%ebp),%eax
801055d7:	8d 50 ff             	lea    -0x1(%eax),%edx
801055da:	89 55 10             	mov    %edx,0x10(%ebp)
801055dd:	85 c0                	test   %eax,%eax
801055df:	75 c3                	jne    801055a4 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801055e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055e6:	c9                   	leave  
801055e7:	c3                   	ret    

801055e8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801055e8:	55                   	push   %ebp
801055e9:	89 e5                	mov    %esp,%ebp
801055eb:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801055ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801055f4:	8b 45 08             	mov    0x8(%ebp),%eax
801055f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801055fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105600:	73 3d                	jae    8010563f <memmove+0x57>
80105602:	8b 45 10             	mov    0x10(%ebp),%eax
80105605:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105608:	01 d0                	add    %edx,%eax
8010560a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010560d:	76 30                	jbe    8010563f <memmove+0x57>
    s += n;
8010560f:	8b 45 10             	mov    0x10(%ebp),%eax
80105612:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105615:	8b 45 10             	mov    0x10(%ebp),%eax
80105618:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010561b:	eb 13                	jmp    80105630 <memmove+0x48>
      *--d = *--s;
8010561d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105621:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105625:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105628:	0f b6 10             	movzbl (%eax),%edx
8010562b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010562e:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105630:	8b 45 10             	mov    0x10(%ebp),%eax
80105633:	8d 50 ff             	lea    -0x1(%eax),%edx
80105636:	89 55 10             	mov    %edx,0x10(%ebp)
80105639:	85 c0                	test   %eax,%eax
8010563b:	75 e0                	jne    8010561d <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010563d:	eb 26                	jmp    80105665 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010563f:	eb 17                	jmp    80105658 <memmove+0x70>
      *d++ = *s++;
80105641:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105644:	8d 50 01             	lea    0x1(%eax),%edx
80105647:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010564a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010564d:	8d 4a 01             	lea    0x1(%edx),%ecx
80105650:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105653:	0f b6 12             	movzbl (%edx),%edx
80105656:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105658:	8b 45 10             	mov    0x10(%ebp),%eax
8010565b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010565e:	89 55 10             	mov    %edx,0x10(%ebp)
80105661:	85 c0                	test   %eax,%eax
80105663:	75 dc                	jne    80105641 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105665:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105668:	c9                   	leave  
80105669:	c3                   	ret    

8010566a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010566a:	55                   	push   %ebp
8010566b:	89 e5                	mov    %esp,%ebp
8010566d:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105670:	8b 45 10             	mov    0x10(%ebp),%eax
80105673:	89 44 24 08          	mov    %eax,0x8(%esp)
80105677:	8b 45 0c             	mov    0xc(%ebp),%eax
8010567a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010567e:	8b 45 08             	mov    0x8(%ebp),%eax
80105681:	89 04 24             	mov    %eax,(%esp)
80105684:	e8 5f ff ff ff       	call   801055e8 <memmove>
}
80105689:	c9                   	leave  
8010568a:	c3                   	ret    

8010568b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010568b:	55                   	push   %ebp
8010568c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010568e:	eb 0c                	jmp    8010569c <strncmp+0x11>
    n--, p++, q++;
80105690:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105694:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105698:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010569c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056a0:	74 1a                	je     801056bc <strncmp+0x31>
801056a2:	8b 45 08             	mov    0x8(%ebp),%eax
801056a5:	0f b6 00             	movzbl (%eax),%eax
801056a8:	84 c0                	test   %al,%al
801056aa:	74 10                	je     801056bc <strncmp+0x31>
801056ac:	8b 45 08             	mov    0x8(%ebp),%eax
801056af:	0f b6 10             	movzbl (%eax),%edx
801056b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b5:	0f b6 00             	movzbl (%eax),%eax
801056b8:	38 c2                	cmp    %al,%dl
801056ba:	74 d4                	je     80105690 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801056bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056c0:	75 07                	jne    801056c9 <strncmp+0x3e>
    return 0;
801056c2:	b8 00 00 00 00       	mov    $0x0,%eax
801056c7:	eb 16                	jmp    801056df <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801056c9:	8b 45 08             	mov    0x8(%ebp),%eax
801056cc:	0f b6 00             	movzbl (%eax),%eax
801056cf:	0f b6 d0             	movzbl %al,%edx
801056d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056d5:	0f b6 00             	movzbl (%eax),%eax
801056d8:	0f b6 c0             	movzbl %al,%eax
801056db:	29 c2                	sub    %eax,%edx
801056dd:	89 d0                	mov    %edx,%eax
}
801056df:	5d                   	pop    %ebp
801056e0:	c3                   	ret    

801056e1 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801056e1:	55                   	push   %ebp
801056e2:	89 e5                	mov    %esp,%ebp
801056e4:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801056e7:	8b 45 08             	mov    0x8(%ebp),%eax
801056ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801056ed:	90                   	nop
801056ee:	8b 45 10             	mov    0x10(%ebp),%eax
801056f1:	8d 50 ff             	lea    -0x1(%eax),%edx
801056f4:	89 55 10             	mov    %edx,0x10(%ebp)
801056f7:	85 c0                	test   %eax,%eax
801056f9:	7e 1e                	jle    80105719 <strncpy+0x38>
801056fb:	8b 45 08             	mov    0x8(%ebp),%eax
801056fe:	8d 50 01             	lea    0x1(%eax),%edx
80105701:	89 55 08             	mov    %edx,0x8(%ebp)
80105704:	8b 55 0c             	mov    0xc(%ebp),%edx
80105707:	8d 4a 01             	lea    0x1(%edx),%ecx
8010570a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010570d:	0f b6 12             	movzbl (%edx),%edx
80105710:	88 10                	mov    %dl,(%eax)
80105712:	0f b6 00             	movzbl (%eax),%eax
80105715:	84 c0                	test   %al,%al
80105717:	75 d5                	jne    801056ee <strncpy+0xd>
    ;
  while(n-- > 0)
80105719:	eb 0c                	jmp    80105727 <strncpy+0x46>
    *s++ = 0;
8010571b:	8b 45 08             	mov    0x8(%ebp),%eax
8010571e:	8d 50 01             	lea    0x1(%eax),%edx
80105721:	89 55 08             	mov    %edx,0x8(%ebp)
80105724:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105727:	8b 45 10             	mov    0x10(%ebp),%eax
8010572a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010572d:	89 55 10             	mov    %edx,0x10(%ebp)
80105730:	85 c0                	test   %eax,%eax
80105732:	7f e7                	jg     8010571b <strncpy+0x3a>
    *s++ = 0;
  return os;
80105734:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105737:	c9                   	leave  
80105738:	c3                   	ret    

80105739 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105739:	55                   	push   %ebp
8010573a:	89 e5                	mov    %esp,%ebp
8010573c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010573f:	8b 45 08             	mov    0x8(%ebp),%eax
80105742:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105745:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105749:	7f 05                	jg     80105750 <safestrcpy+0x17>
    return os;
8010574b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010574e:	eb 31                	jmp    80105781 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105750:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105754:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105758:	7e 1e                	jle    80105778 <safestrcpy+0x3f>
8010575a:	8b 45 08             	mov    0x8(%ebp),%eax
8010575d:	8d 50 01             	lea    0x1(%eax),%edx
80105760:	89 55 08             	mov    %edx,0x8(%ebp)
80105763:	8b 55 0c             	mov    0xc(%ebp),%edx
80105766:	8d 4a 01             	lea    0x1(%edx),%ecx
80105769:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010576c:	0f b6 12             	movzbl (%edx),%edx
8010576f:	88 10                	mov    %dl,(%eax)
80105771:	0f b6 00             	movzbl (%eax),%eax
80105774:	84 c0                	test   %al,%al
80105776:	75 d8                	jne    80105750 <safestrcpy+0x17>
    ;
  *s = 0;
80105778:	8b 45 08             	mov    0x8(%ebp),%eax
8010577b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010577e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105781:	c9                   	leave  
80105782:	c3                   	ret    

80105783 <strlen>:

int
strlen(const char *s)
{
80105783:	55                   	push   %ebp
80105784:	89 e5                	mov    %esp,%ebp
80105786:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105789:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105790:	eb 04                	jmp    80105796 <strlen+0x13>
80105792:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105796:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105799:	8b 45 08             	mov    0x8(%ebp),%eax
8010579c:	01 d0                	add    %edx,%eax
8010579e:	0f b6 00             	movzbl (%eax),%eax
801057a1:	84 c0                	test   %al,%al
801057a3:	75 ed                	jne    80105792 <strlen+0xf>
    ;
  return n;
801057a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057a8:	c9                   	leave  
801057a9:	c3                   	ret    

801057aa <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801057aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057ae:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801057b2:	55                   	push   %ebp
  pushl %ebx
801057b3:	53                   	push   %ebx
  pushl %esi
801057b4:	56                   	push   %esi
  pushl %edi
801057b5:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057b6:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057b8:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801057ba:	5f                   	pop    %edi
  popl %esi
801057bb:	5e                   	pop    %esi
  popl %ebx
801057bc:	5b                   	pop    %ebx
  popl %ebp
801057bd:	5d                   	pop    %ebp
  ret
801057be:	c3                   	ret    

801057bf <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
801057bf:	55                   	push   %ebp
801057c0:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
801057c2:	8b 45 08             	mov    0x8(%ebp),%eax
801057c5:	8b 00                	mov    (%eax),%eax
801057c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801057ca:	76 0f                	jbe    801057db <fetchint+0x1c>
801057cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801057cf:	8d 50 04             	lea    0x4(%eax),%edx
801057d2:	8b 45 08             	mov    0x8(%ebp),%eax
801057d5:	8b 00                	mov    (%eax),%eax
801057d7:	39 c2                	cmp    %eax,%edx
801057d9:	76 07                	jbe    801057e2 <fetchint+0x23>
    return -1;
801057db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e0:	eb 0f                	jmp    801057f1 <fetchint+0x32>
  *ip = *(int*)(addr);
801057e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801057e5:	8b 10                	mov    (%eax),%edx
801057e7:	8b 45 10             	mov    0x10(%ebp),%eax
801057ea:	89 10                	mov    %edx,(%eax)
  return 0;
801057ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057f1:	5d                   	pop    %ebp
801057f2:	c3                   	ret    

801057f3 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
801057f3:	55                   	push   %ebp
801057f4:	89 e5                	mov    %esp,%ebp
801057f6:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
801057f9:	8b 45 08             	mov    0x8(%ebp),%eax
801057fc:	8b 00                	mov    (%eax),%eax
801057fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105801:	77 07                	ja     8010580a <fetchstr+0x17>
    return -1;
80105803:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105808:	eb 43                	jmp    8010584d <fetchstr+0x5a>
  *pp = (char*)addr;
8010580a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010580d:	8b 45 10             	mov    0x10(%ebp),%eax
80105810:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
80105812:	8b 45 08             	mov    0x8(%ebp),%eax
80105815:	8b 00                	mov    (%eax),%eax
80105817:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010581a:	8b 45 10             	mov    0x10(%ebp),%eax
8010581d:	8b 00                	mov    (%eax),%eax
8010581f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105822:	eb 1c                	jmp    80105840 <fetchstr+0x4d>
    if(*s == 0)
80105824:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105827:	0f b6 00             	movzbl (%eax),%eax
8010582a:	84 c0                	test   %al,%al
8010582c:	75 0e                	jne    8010583c <fetchstr+0x49>
      return s - *pp;
8010582e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105831:	8b 45 10             	mov    0x10(%ebp),%eax
80105834:	8b 00                	mov    (%eax),%eax
80105836:	29 c2                	sub    %eax,%edx
80105838:	89 d0                	mov    %edx,%eax
8010583a:	eb 11                	jmp    8010584d <fetchstr+0x5a>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
8010583c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105840:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105843:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105846:	72 dc                	jb     80105824 <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
80105848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    

8010584f <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010584f:	55                   	push   %ebp
80105850:	89 e5                	mov    %esp,%ebp
80105852:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
80105855:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010585b:	8b 40 18             	mov    0x18(%eax),%eax
8010585e:	8b 50 44             	mov    0x44(%eax),%edx
80105861:	8b 45 08             	mov    0x8(%ebp),%eax
80105864:	c1 e0 02             	shl    $0x2,%eax
80105867:	01 d0                	add    %edx,%eax
80105869:	8d 48 04             	lea    0x4(%eax),%ecx
8010586c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105872:	8b 55 0c             	mov    0xc(%ebp),%edx
80105875:	89 54 24 08          	mov    %edx,0x8(%esp)
80105879:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010587d:	89 04 24             	mov    %eax,(%esp)
80105880:	e8 3a ff ff ff       	call   801057bf <fetchint>
}
80105885:	c9                   	leave  
80105886:	c3                   	ret    

80105887 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105887:	55                   	push   %ebp
80105888:	89 e5                	mov    %esp,%ebp
8010588a:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010588d:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105890:	89 44 24 04          	mov    %eax,0x4(%esp)
80105894:	8b 45 08             	mov    0x8(%ebp),%eax
80105897:	89 04 24             	mov    %eax,(%esp)
8010589a:	e8 b0 ff ff ff       	call   8010584f <argint>
8010589f:	85 c0                	test   %eax,%eax
801058a1:	79 07                	jns    801058aa <argptr+0x23>
    return -1;
801058a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a8:	eb 3d                	jmp    801058e7 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801058aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ad:	89 c2                	mov    %eax,%edx
801058af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058b5:	8b 00                	mov    (%eax),%eax
801058b7:	39 c2                	cmp    %eax,%edx
801058b9:	73 16                	jae    801058d1 <argptr+0x4a>
801058bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058be:	89 c2                	mov    %eax,%edx
801058c0:	8b 45 10             	mov    0x10(%ebp),%eax
801058c3:	01 c2                	add    %eax,%edx
801058c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058cb:	8b 00                	mov    (%eax),%eax
801058cd:	39 c2                	cmp    %eax,%edx
801058cf:	76 07                	jbe    801058d8 <argptr+0x51>
    return -1;
801058d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d6:	eb 0f                	jmp    801058e7 <argptr+0x60>
  *pp = (char*)i;
801058d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058db:	89 c2                	mov    %eax,%edx
801058dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801058e0:	89 10                	mov    %edx,(%eax)
  return 0;
801058e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058e7:	c9                   	leave  
801058e8:	c3                   	ret    

801058e9 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801058e9:	55                   	push   %ebp
801058ea:	89 e5                	mov    %esp,%ebp
801058ec:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
801058ef:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801058f6:	8b 45 08             	mov    0x8(%ebp),%eax
801058f9:	89 04 24             	mov    %eax,(%esp)
801058fc:	e8 4e ff ff ff       	call   8010584f <argint>
80105901:	85 c0                	test   %eax,%eax
80105903:	79 07                	jns    8010590c <argstr+0x23>
    return -1;
80105905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590a:	eb 1e                	jmp    8010592a <argstr+0x41>
  return fetchstr(proc, addr, pp);
8010590c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010590f:	89 c2                	mov    %eax,%edx
80105911:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010591a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010591e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105922:	89 04 24             	mov    %eax,(%esp)
80105925:	e8 c9 fe ff ff       	call   801057f3 <fetchstr>
}
8010592a:	c9                   	leave  
8010592b:	c3                   	ret    

8010592c <syscall>:
[SYS_getPriority] sys_getPriority,
};

void
syscall(void)
{
8010592c:	55                   	push   %ebp
8010592d:	89 e5                	mov    %esp,%ebp
8010592f:	53                   	push   %ebx
80105930:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105933:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105939:	8b 40 18             	mov    0x18(%eax),%eax
8010593c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010593f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
80105942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105946:	78 2e                	js     80105976 <syscall+0x4a>
80105948:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
8010594c:	7f 28                	jg     80105976 <syscall+0x4a>
8010594e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105951:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105958:	85 c0                	test   %eax,%eax
8010595a:	74 1a                	je     80105976 <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
8010595c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105962:	8b 58 18             	mov    0x18(%eax),%ebx
80105965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105968:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010596f:	ff d0                	call   *%eax
80105971:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105974:	eb 73                	jmp    801059e9 <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
80105976:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
8010597a:	7e 30                	jle    801059ac <syscall+0x80>
8010597c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597f:	83 f8 17             	cmp    $0x17,%eax
80105982:	77 28                	ja     801059ac <syscall+0x80>
80105984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105987:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010598e:	85 c0                	test   %eax,%eax
80105990:	74 1a                	je     801059ac <syscall+0x80>
    proc->tf->eax = syscalls[num]();
80105992:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105998:	8b 58 18             	mov    0x18(%eax),%ebx
8010599b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599e:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801059a5:	ff d0                	call   *%eax
801059a7:	89 43 1c             	mov    %eax,0x1c(%ebx)
801059aa:	eb 3d                	jmp    801059e9 <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801059ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059b2:	8d 48 6c             	lea    0x6c(%eax),%ecx
801059b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801059bb:	8b 40 10             	mov    0x10(%eax),%eax
801059be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
801059c5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801059c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801059cd:	c7 04 24 25 8e 10 80 	movl   $0x80108e25,(%esp)
801059d4:	e8 c7 a9 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801059d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059df:	8b 40 18             	mov    0x18(%eax),%eax
801059e2:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801059e9:	83 c4 24             	add    $0x24,%esp
801059ec:	5b                   	pop    %ebx
801059ed:	5d                   	pop    %ebp
801059ee:	c3                   	ret    

801059ef <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801059ef:	55                   	push   %ebp
801059f0:	89 e5                	mov    %esp,%ebp
801059f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801059f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801059fc:	8b 45 08             	mov    0x8(%ebp),%eax
801059ff:	89 04 24             	mov    %eax,(%esp)
80105a02:	e8 48 fe ff ff       	call   8010584f <argint>
80105a07:	85 c0                	test   %eax,%eax
80105a09:	79 07                	jns    80105a12 <argfd+0x23>
    return -1;
80105a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a10:	eb 50                	jmp    80105a62 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a15:	85 c0                	test   %eax,%eax
80105a17:	78 21                	js     80105a3a <argfd+0x4b>
80105a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1c:	83 f8 0f             	cmp    $0xf,%eax
80105a1f:	7f 19                	jg     80105a3a <argfd+0x4b>
80105a21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a27:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a2a:	83 c2 08             	add    $0x8,%edx
80105a2d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a38:	75 07                	jne    80105a41 <argfd+0x52>
    return -1;
80105a3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3f:	eb 21                	jmp    80105a62 <argfd+0x73>
  if(pfd)
80105a41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105a45:	74 08                	je     80105a4f <argfd+0x60>
    *pfd = fd;
80105a47:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a4d:	89 10                	mov    %edx,(%eax)
  if(pf)
80105a4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a53:	74 08                	je     80105a5d <argfd+0x6e>
    *pf = f;
80105a55:	8b 45 10             	mov    0x10(%ebp),%eax
80105a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a5b:	89 10                	mov    %edx,(%eax)
  return 0;
80105a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a62:	c9                   	leave  
80105a63:	c3                   	ret    

80105a64 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105a64:	55                   	push   %ebp
80105a65:	89 e5                	mov    %esp,%ebp
80105a67:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a71:	eb 30                	jmp    80105aa3 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105a73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a79:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a7c:	83 c2 08             	add    $0x8,%edx
80105a7f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a83:	85 c0                	test   %eax,%eax
80105a85:	75 18                	jne    80105a9f <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105a87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a90:	8d 4a 08             	lea    0x8(%edx),%ecx
80105a93:	8b 55 08             	mov    0x8(%ebp),%edx
80105a96:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a9d:	eb 0f                	jmp    80105aae <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a9f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105aa3:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105aa7:	7e ca                	jle    80105a73 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105aa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aae:	c9                   	leave  
80105aaf:	c3                   	ret    

80105ab0 <sys_dup>:

int
sys_dup(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105ab6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ab9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105abd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ac4:	00 
80105ac5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105acc:	e8 1e ff ff ff       	call   801059ef <argfd>
80105ad1:	85 c0                	test   %eax,%eax
80105ad3:	79 07                	jns    80105adc <sys_dup+0x2c>
    return -1;
80105ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ada:	eb 29                	jmp    80105b05 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105adf:	89 04 24             	mov    %eax,(%esp)
80105ae2:	e8 7d ff ff ff       	call   80105a64 <fdalloc>
80105ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aee:	79 07                	jns    80105af7 <sys_dup+0x47>
    return -1;
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af5:	eb 0e                	jmp    80105b05 <sys_dup+0x55>
  filedup(f);
80105af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afa:	89 04 24             	mov    %eax,(%esp)
80105afd:	e8 77 b4 ff ff       	call   80100f79 <filedup>
  return fd;
80105b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    

80105b07 <sys_read>:

int
sys_read(void)
{
80105b07:	55                   	push   %ebp
80105b08:	89 e5                	mov    %esp,%ebp
80105b0a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b10:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b1b:	00 
80105b1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b23:	e8 c7 fe ff ff       	call   801059ef <argfd>
80105b28:	85 c0                	test   %eax,%eax
80105b2a:	78 35                	js     80105b61 <sys_read+0x5a>
80105b2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b33:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105b3a:	e8 10 fd ff ff       	call   8010584f <argint>
80105b3f:	85 c0                	test   %eax,%eax
80105b41:	78 1e                	js     80105b61 <sys_read+0x5a>
80105b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b46:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b4a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b58:	e8 2a fd ff ff       	call   80105887 <argptr>
80105b5d:	85 c0                	test   %eax,%eax
80105b5f:	79 07                	jns    80105b68 <sys_read+0x61>
    return -1;
80105b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b66:	eb 19                	jmp    80105b81 <sys_read+0x7a>
  return fileread(f, p, n);
80105b68:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b71:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105b75:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b79:	89 04 24             	mov    %eax,(%esp)
80105b7c:	e8 65 b5 ff ff       	call   801010e6 <fileread>
}
80105b81:	c9                   	leave  
80105b82:	c3                   	ret    

80105b83 <sys_write>:

int
sys_write(void)
{
80105b83:	55                   	push   %ebp
80105b84:	89 e5                	mov    %esp,%ebp
80105b86:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b97:	00 
80105b98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b9f:	e8 4b fe ff ff       	call   801059ef <argfd>
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	78 35                	js     80105bdd <sys_write+0x5a>
80105ba8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bab:	89 44 24 04          	mov    %eax,0x4(%esp)
80105baf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105bb6:	e8 94 fc ff ff       	call   8010584f <argint>
80105bbb:	85 c0                	test   %eax,%eax
80105bbd:	78 1e                	js     80105bdd <sys_write+0x5a>
80105bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bc6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bcd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105bd4:	e8 ae fc ff ff       	call   80105887 <argptr>
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	79 07                	jns    80105be4 <sys_write+0x61>
    return -1;
80105bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be2:	eb 19                	jmp    80105bfd <sys_write+0x7a>
  return filewrite(f, p, n);
80105be4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105be7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105bf1:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bf5:	89 04 24             	mov    %eax,(%esp)
80105bf8:	e8 a5 b5 ff ff       	call   801011a2 <filewrite>
}
80105bfd:	c9                   	leave  
80105bfe:	c3                   	ret    

80105bff <sys_close>:

int
sys_close(void)
{
80105bff:	55                   	push   %ebp
80105c00:	89 e5                	mov    %esp,%ebp
80105c02:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105c05:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c08:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c1a:	e8 d0 fd ff ff       	call   801059ef <argfd>
80105c1f:	85 c0                	test   %eax,%eax
80105c21:	79 07                	jns    80105c2a <sys_close+0x2b>
    return -1;
80105c23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c28:	eb 24                	jmp    80105c4e <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105c2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c33:	83 c2 08             	add    $0x8,%edx
80105c36:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105c3d:	00 
  fileclose(f);
80105c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c41:	89 04 24             	mov    %eax,(%esp)
80105c44:	e8 78 b3 ff ff       	call   80100fc1 <fileclose>
  return 0;
80105c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c4e:	c9                   	leave  
80105c4f:	c3                   	ret    

80105c50 <sys_fstat>:

int
sys_fstat(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c59:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c64:	00 
80105c65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c6c:	e8 7e fd ff ff       	call   801059ef <argfd>
80105c71:	85 c0                	test   %eax,%eax
80105c73:	78 1f                	js     80105c94 <sys_fstat+0x44>
80105c75:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105c7c:	00 
80105c7d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c80:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c8b:	e8 f7 fb ff ff       	call   80105887 <argptr>
80105c90:	85 c0                	test   %eax,%eax
80105c92:	79 07                	jns    80105c9b <sys_fstat+0x4b>
    return -1;
80105c94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c99:	eb 12                	jmp    80105cad <sys_fstat+0x5d>
  return filestat(f, st);
80105c9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca1:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ca5:	89 04 24             	mov    %eax,(%esp)
80105ca8:	e8 ea b3 ff ff       	call   80101097 <filestat>
}
80105cad:	c9                   	leave  
80105cae:	c3                   	ret    

80105caf <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105caf:	55                   	push   %ebp
80105cb0:	89 e5                	mov    %esp,%ebp
80105cb2:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105cb5:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cbc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cc3:	e8 21 fc ff ff       	call   801058e9 <argstr>
80105cc8:	85 c0                	test   %eax,%eax
80105cca:	78 17                	js     80105ce3 <sys_link+0x34>
80105ccc:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105cda:	e8 0a fc ff ff       	call   801058e9 <argstr>
80105cdf:	85 c0                	test   %eax,%eax
80105ce1:	79 0a                	jns    80105ced <sys_link+0x3e>
    return -1;
80105ce3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce8:	e9 3d 01 00 00       	jmp    80105e2a <sys_link+0x17b>
  if((ip = namei(old)) == 0)
80105ced:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105cf0:	89 04 24             	mov    %eax,(%esp)
80105cf3:	e8 01 c7 ff ff       	call   801023f9 <namei>
80105cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cff:	75 0a                	jne    80105d0b <sys_link+0x5c>
    return -1;
80105d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d06:	e9 1f 01 00 00       	jmp    80105e2a <sys_link+0x17b>

  begin_trans();
80105d0b:	e8 c8 d4 ff ff       	call   801031d8 <begin_trans>

  ilock(ip);
80105d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d13:	89 04 24             	mov    %eax,(%esp)
80105d16:	e8 33 bb ff ff       	call   8010184e <ilock>
  if(ip->type == T_DIR){
80105d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d22:	66 83 f8 01          	cmp    $0x1,%ax
80105d26:	75 1a                	jne    80105d42 <sys_link+0x93>
    iunlockput(ip);
80105d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2b:	89 04 24             	mov    %eax,(%esp)
80105d2e:	e8 9f bd ff ff       	call   80101ad2 <iunlockput>
    commit_trans();
80105d33:	e8 e9 d4 ff ff       	call   80103221 <commit_trans>
    return -1;
80105d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3d:	e9 e8 00 00 00       	jmp    80105e2a <sys_link+0x17b>
  }

  ip->nlink++;
80105d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d45:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d49:	8d 50 01             	lea    0x1(%eax),%edx
80105d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d56:	89 04 24             	mov    %eax,(%esp)
80105d59:	e8 34 b9 ff ff       	call   80101692 <iupdate>
  iunlock(ip);
80105d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d61:	89 04 24             	mov    %eax,(%esp)
80105d64:	e8 33 bc ff ff       	call   8010199c <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105d69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d6c:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105d6f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d73:	89 04 24             	mov    %eax,(%esp)
80105d76:	e8 a0 c6 ff ff       	call   8010241b <nameiparent>
80105d7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d82:	75 02                	jne    80105d86 <sys_link+0xd7>
    goto bad;
80105d84:	eb 68                	jmp    80105dee <sys_link+0x13f>
  ilock(dp);
80105d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d89:	89 04 24             	mov    %eax,(%esp)
80105d8c:	e8 bd ba ff ff       	call   8010184e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d94:	8b 10                	mov    (%eax),%edx
80105d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d99:	8b 00                	mov    (%eax),%eax
80105d9b:	39 c2                	cmp    %eax,%edx
80105d9d:	75 20                	jne    80105dbf <sys_link+0x110>
80105d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da2:	8b 40 04             	mov    0x4(%eax),%eax
80105da5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105da9:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105dac:	89 44 24 04          	mov    %eax,0x4(%esp)
80105db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db3:	89 04 24             	mov    %eax,(%esp)
80105db6:	e8 7e c3 ff ff       	call   80102139 <dirlink>
80105dbb:	85 c0                	test   %eax,%eax
80105dbd:	79 0d                	jns    80105dcc <sys_link+0x11d>
    iunlockput(dp);
80105dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc2:	89 04 24             	mov    %eax,(%esp)
80105dc5:	e8 08 bd ff ff       	call   80101ad2 <iunlockput>
    goto bad;
80105dca:	eb 22                	jmp    80105dee <sys_link+0x13f>
  }
  iunlockput(dp);
80105dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcf:	89 04 24             	mov    %eax,(%esp)
80105dd2:	e8 fb bc ff ff       	call   80101ad2 <iunlockput>
  iput(ip);
80105dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dda:	89 04 24             	mov    %eax,(%esp)
80105ddd:	e8 1f bc ff ff       	call   80101a01 <iput>

  commit_trans();
80105de2:	e8 3a d4 ff ff       	call   80103221 <commit_trans>

  return 0;
80105de7:	b8 00 00 00 00       	mov    $0x0,%eax
80105dec:	eb 3c                	jmp    80105e2a <sys_link+0x17b>

bad:
  ilock(ip);
80105dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df1:	89 04 24             	mov    %eax,(%esp)
80105df4:	e8 55 ba ff ff       	call   8010184e <ilock>
  ip->nlink--;
80105df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e00:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e06:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0d:	89 04 24             	mov    %eax,(%esp)
80105e10:	e8 7d b8 ff ff       	call   80101692 <iupdate>
  iunlockput(ip);
80105e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e18:	89 04 24             	mov    %eax,(%esp)
80105e1b:	e8 b2 bc ff ff       	call   80101ad2 <iunlockput>
  commit_trans();
80105e20:	e8 fc d3 ff ff       	call   80103221 <commit_trans>
  return -1;
80105e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e2a:	c9                   	leave  
80105e2b:	c3                   	ret    

80105e2c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105e2c:	55                   	push   %ebp
80105e2d:	89 e5                	mov    %esp,%ebp
80105e2f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e32:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105e39:	eb 4b                	jmp    80105e86 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105e45:	00 
80105e46:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e51:	8b 45 08             	mov    0x8(%ebp),%eax
80105e54:	89 04 24             	mov    %eax,(%esp)
80105e57:	e8 ff be ff ff       	call   80101d5b <readi>
80105e5c:	83 f8 10             	cmp    $0x10,%eax
80105e5f:	74 0c                	je     80105e6d <isdirempty+0x41>
      panic("isdirempty: readi");
80105e61:	c7 04 24 41 8e 10 80 	movl   $0x80108e41,(%esp)
80105e68:	e8 cd a6 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105e6d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105e71:	66 85 c0             	test   %ax,%ax
80105e74:	74 07                	je     80105e7d <isdirempty+0x51>
      return 0;
80105e76:	b8 00 00 00 00       	mov    $0x0,%eax
80105e7b:	eb 1b                	jmp    80105e98 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e80:	83 c0 10             	add    $0x10,%eax
80105e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e86:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e89:	8b 45 08             	mov    0x8(%ebp),%eax
80105e8c:	8b 40 18             	mov    0x18(%eax),%eax
80105e8f:	39 c2                	cmp    %eax,%edx
80105e91:	72 a8                	jb     80105e3b <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105e93:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e98:	c9                   	leave  
80105e99:	c3                   	ret    

80105e9a <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105e9a:	55                   	push   %ebp
80105e9b:	89 e5                	mov    %esp,%ebp
80105e9d:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ea0:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ea7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105eae:	e8 36 fa ff ff       	call   801058e9 <argstr>
80105eb3:	85 c0                	test   %eax,%eax
80105eb5:	79 0a                	jns    80105ec1 <sys_unlink+0x27>
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	e9 aa 01 00 00       	jmp    8010606b <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105ec1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105ec4:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105ec7:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ecb:	89 04 24             	mov    %eax,(%esp)
80105ece:	e8 48 c5 ff ff       	call   8010241b <nameiparent>
80105ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eda:	75 0a                	jne    80105ee6 <sys_unlink+0x4c>
    return -1;
80105edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee1:	e9 85 01 00 00       	jmp    8010606b <sys_unlink+0x1d1>

  begin_trans();
80105ee6:	e8 ed d2 ff ff       	call   801031d8 <begin_trans>

  ilock(dp);
80105eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eee:	89 04 24             	mov    %eax,(%esp)
80105ef1:	e8 58 b9 ff ff       	call   8010184e <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105ef6:	c7 44 24 04 53 8e 10 	movl   $0x80108e53,0x4(%esp)
80105efd:	80 
80105efe:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f01:	89 04 24             	mov    %eax,(%esp)
80105f04:	e8 45 c1 ff ff       	call   8010204e <namecmp>
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	0f 84 45 01 00 00    	je     80106056 <sys_unlink+0x1bc>
80105f11:	c7 44 24 04 55 8e 10 	movl   $0x80108e55,0x4(%esp)
80105f18:	80 
80105f19:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f1c:	89 04 24             	mov    %eax,(%esp)
80105f1f:	e8 2a c1 ff ff       	call   8010204e <namecmp>
80105f24:	85 c0                	test   %eax,%eax
80105f26:	0f 84 2a 01 00 00    	je     80106056 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105f2c:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105f2f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f33:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f36:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3d:	89 04 24             	mov    %eax,(%esp)
80105f40:	e8 2b c1 ff ff       	call   80102070 <dirlookup>
80105f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f4c:	75 05                	jne    80105f53 <sys_unlink+0xb9>
    goto bad;
80105f4e:	e9 03 01 00 00       	jmp    80106056 <sys_unlink+0x1bc>
  ilock(ip);
80105f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f56:	89 04 24             	mov    %eax,(%esp)
80105f59:	e8 f0 b8 ff ff       	call   8010184e <ilock>

  if(ip->nlink < 1)
80105f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f61:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f65:	66 85 c0             	test   %ax,%ax
80105f68:	7f 0c                	jg     80105f76 <sys_unlink+0xdc>
    panic("unlink: nlink < 1");
80105f6a:	c7 04 24 58 8e 10 80 	movl   $0x80108e58,(%esp)
80105f71:	e8 c4 a5 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f79:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f7d:	66 83 f8 01          	cmp    $0x1,%ax
80105f81:	75 1f                	jne    80105fa2 <sys_unlink+0x108>
80105f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f86:	89 04 24             	mov    %eax,(%esp)
80105f89:	e8 9e fe ff ff       	call   80105e2c <isdirempty>
80105f8e:	85 c0                	test   %eax,%eax
80105f90:	75 10                	jne    80105fa2 <sys_unlink+0x108>
    iunlockput(ip);
80105f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f95:	89 04 24             	mov    %eax,(%esp)
80105f98:	e8 35 bb ff ff       	call   80101ad2 <iunlockput>
    goto bad;
80105f9d:	e9 b4 00 00 00       	jmp    80106056 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105fa2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105fa9:	00 
80105faa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105fb1:	00 
80105fb2:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fb5:	89 04 24             	mov    %eax,(%esp)
80105fb8:	e8 5c f5 ff ff       	call   80105519 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105fc0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105fc7:	00 
80105fc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fcc:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd6:	89 04 24             	mov    %eax,(%esp)
80105fd9:	e8 e1 be ff ff       	call   80101ebf <writei>
80105fde:	83 f8 10             	cmp    $0x10,%eax
80105fe1:	74 0c                	je     80105fef <sys_unlink+0x155>
    panic("unlink: writei");
80105fe3:	c7 04 24 6a 8e 10 80 	movl   $0x80108e6a,(%esp)
80105fea:	e8 4b a5 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ff6:	66 83 f8 01          	cmp    $0x1,%ax
80105ffa:	75 1c                	jne    80106018 <sys_unlink+0x17e>
    dp->nlink--;
80105ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fff:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106003:	8d 50 ff             	lea    -0x1(%eax),%edx
80106006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106009:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010600d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106010:	89 04 24             	mov    %eax,(%esp)
80106013:	e8 7a b6 ff ff       	call   80101692 <iupdate>
  }
  iunlockput(dp);
80106018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601b:	89 04 24             	mov    %eax,(%esp)
8010601e:	e8 af ba ff ff       	call   80101ad2 <iunlockput>

  ip->nlink--;
80106023:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106026:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010602a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010602d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106030:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106034:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106037:	89 04 24             	mov    %eax,(%esp)
8010603a:	e8 53 b6 ff ff       	call   80101692 <iupdate>
  iunlockput(ip);
8010603f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106042:	89 04 24             	mov    %eax,(%esp)
80106045:	e8 88 ba ff ff       	call   80101ad2 <iunlockput>

  commit_trans();
8010604a:	e8 d2 d1 ff ff       	call   80103221 <commit_trans>

  return 0;
8010604f:	b8 00 00 00 00       	mov    $0x0,%eax
80106054:	eb 15                	jmp    8010606b <sys_unlink+0x1d1>

bad:
  iunlockput(dp);
80106056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106059:	89 04 24             	mov    %eax,(%esp)
8010605c:	e8 71 ba ff ff       	call   80101ad2 <iunlockput>
  commit_trans();
80106061:	e8 bb d1 ff ff       	call   80103221 <commit_trans>
  return -1;
80106066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010606b:	c9                   	leave  
8010606c:	c3                   	ret    

8010606d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010606d:	55                   	push   %ebp
8010606e:	89 e5                	mov    %esp,%ebp
80106070:	83 ec 48             	sub    $0x48,%esp
80106073:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106076:	8b 55 10             	mov    0x10(%ebp),%edx
80106079:	8b 45 14             	mov    0x14(%ebp),%eax
8010607c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106080:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106084:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106088:	8d 45 de             	lea    -0x22(%ebp),%eax
8010608b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010608f:	8b 45 08             	mov    0x8(%ebp),%eax
80106092:	89 04 24             	mov    %eax,(%esp)
80106095:	e8 81 c3 ff ff       	call   8010241b <nameiparent>
8010609a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010609d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060a1:	75 0a                	jne    801060ad <create+0x40>
    return 0;
801060a3:	b8 00 00 00 00       	mov    $0x0,%eax
801060a8:	e9 7e 01 00 00       	jmp    8010622b <create+0x1be>
  ilock(dp);
801060ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b0:	89 04 24             	mov    %eax,(%esp)
801060b3:	e8 96 b7 ff ff       	call   8010184e <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801060b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060bb:	89 44 24 08          	mov    %eax,0x8(%esp)
801060bf:	8d 45 de             	lea    -0x22(%ebp),%eax
801060c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801060c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c9:	89 04 24             	mov    %eax,(%esp)
801060cc:	e8 9f bf ff ff       	call   80102070 <dirlookup>
801060d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060d8:	74 47                	je     80106121 <create+0xb4>
    iunlockput(dp);
801060da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060dd:	89 04 24             	mov    %eax,(%esp)
801060e0:	e8 ed b9 ff ff       	call   80101ad2 <iunlockput>
    ilock(ip);
801060e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e8:	89 04 24             	mov    %eax,(%esp)
801060eb:	e8 5e b7 ff ff       	call   8010184e <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801060f0:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801060f5:	75 15                	jne    8010610c <create+0x9f>
801060f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060fa:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060fe:	66 83 f8 02          	cmp    $0x2,%ax
80106102:	75 08                	jne    8010610c <create+0x9f>
      return ip;
80106104:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106107:	e9 1f 01 00 00       	jmp    8010622b <create+0x1be>
    iunlockput(ip);
8010610c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610f:	89 04 24             	mov    %eax,(%esp)
80106112:	e8 bb b9 ff ff       	call   80101ad2 <iunlockput>
    return 0;
80106117:	b8 00 00 00 00       	mov    $0x0,%eax
8010611c:	e9 0a 01 00 00       	jmp    8010622b <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106121:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106125:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106128:	8b 00                	mov    (%eax),%eax
8010612a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010612e:	89 04 24             	mov    %eax,(%esp)
80106131:	e8 7d b4 ff ff       	call   801015b3 <ialloc>
80106136:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106139:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010613d:	75 0c                	jne    8010614b <create+0xde>
    panic("create: ialloc");
8010613f:	c7 04 24 79 8e 10 80 	movl   $0x80108e79,(%esp)
80106146:	e8 ef a3 ff ff       	call   8010053a <panic>

  ilock(ip);
8010614b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614e:	89 04 24             	mov    %eax,(%esp)
80106151:	e8 f8 b6 ff ff       	call   8010184e <ilock>
  ip->major = major;
80106156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106159:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010615d:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106161:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106164:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106168:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010616c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010616f:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106175:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106178:	89 04 24             	mov    %eax,(%esp)
8010617b:	e8 12 b5 ff ff       	call   80101692 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106180:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106185:	75 6a                	jne    801061f1 <create+0x184>
    dp->nlink++;  // for ".."
80106187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010618a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010618e:	8d 50 01             	lea    0x1(%eax),%edx
80106191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106194:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619b:	89 04 24             	mov    %eax,(%esp)
8010619e:	e8 ef b4 ff ff       	call   80101692 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801061a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061a6:	8b 40 04             	mov    0x4(%eax),%eax
801061a9:	89 44 24 08          	mov    %eax,0x8(%esp)
801061ad:	c7 44 24 04 53 8e 10 	movl   $0x80108e53,0x4(%esp)
801061b4:	80 
801061b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061b8:	89 04 24             	mov    %eax,(%esp)
801061bb:	e8 79 bf ff ff       	call   80102139 <dirlink>
801061c0:	85 c0                	test   %eax,%eax
801061c2:	78 21                	js     801061e5 <create+0x178>
801061c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c7:	8b 40 04             	mov    0x4(%eax),%eax
801061ca:	89 44 24 08          	mov    %eax,0x8(%esp)
801061ce:	c7 44 24 04 55 8e 10 	movl   $0x80108e55,0x4(%esp)
801061d5:	80 
801061d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d9:	89 04 24             	mov    %eax,(%esp)
801061dc:	e8 58 bf ff ff       	call   80102139 <dirlink>
801061e1:	85 c0                	test   %eax,%eax
801061e3:	79 0c                	jns    801061f1 <create+0x184>
      panic("create dots");
801061e5:	c7 04 24 88 8e 10 80 	movl   $0x80108e88,(%esp)
801061ec:	e8 49 a3 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801061f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f4:	8b 40 04             	mov    0x4(%eax),%eax
801061f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801061fb:	8d 45 de             	lea    -0x22(%ebp),%eax
801061fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106205:	89 04 24             	mov    %eax,(%esp)
80106208:	e8 2c bf ff ff       	call   80102139 <dirlink>
8010620d:	85 c0                	test   %eax,%eax
8010620f:	79 0c                	jns    8010621d <create+0x1b0>
    panic("create: dirlink");
80106211:	c7 04 24 94 8e 10 80 	movl   $0x80108e94,(%esp)
80106218:	e8 1d a3 ff ff       	call   8010053a <panic>

  iunlockput(dp);
8010621d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106220:	89 04 24             	mov    %eax,(%esp)
80106223:	e8 aa b8 ff ff       	call   80101ad2 <iunlockput>

  return ip;
80106228:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010622b:	c9                   	leave  
8010622c:	c3                   	ret    

8010622d <sys_open>:

int
sys_open(void)
{
8010622d:	55                   	push   %ebp
8010622e:	89 e5                	mov    %esp,%ebp
80106230:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106233:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106236:	89 44 24 04          	mov    %eax,0x4(%esp)
8010623a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106241:	e8 a3 f6 ff ff       	call   801058e9 <argstr>
80106246:	85 c0                	test   %eax,%eax
80106248:	78 17                	js     80106261 <sys_open+0x34>
8010624a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010624d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106251:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106258:	e8 f2 f5 ff ff       	call   8010584f <argint>
8010625d:	85 c0                	test   %eax,%eax
8010625f:	79 0a                	jns    8010626b <sys_open+0x3e>
    return -1;
80106261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106266:	e9 48 01 00 00       	jmp    801063b3 <sys_open+0x186>
  if(omode & O_CREATE){
8010626b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010626e:	25 00 02 00 00       	and    $0x200,%eax
80106273:	85 c0                	test   %eax,%eax
80106275:	74 40                	je     801062b7 <sys_open+0x8a>
    begin_trans();
80106277:	e8 5c cf ff ff       	call   801031d8 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
8010627c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010627f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106286:	00 
80106287:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010628e:	00 
8010628f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106296:	00 
80106297:	89 04 24             	mov    %eax,(%esp)
8010629a:	e8 ce fd ff ff       	call   8010606d <create>
8010629f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
801062a2:	e8 7a cf ff ff       	call   80103221 <commit_trans>
    if(ip == 0)
801062a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062ab:	75 5c                	jne    80106309 <sys_open+0xdc>
      return -1;
801062ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b2:	e9 fc 00 00 00       	jmp    801063b3 <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
801062b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062ba:	89 04 24             	mov    %eax,(%esp)
801062bd:	e8 37 c1 ff ff       	call   801023f9 <namei>
801062c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062c9:	75 0a                	jne    801062d5 <sys_open+0xa8>
      return -1;
801062cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d0:	e9 de 00 00 00       	jmp    801063b3 <sys_open+0x186>
    ilock(ip);
801062d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d8:	89 04 24             	mov    %eax,(%esp)
801062db:	e8 6e b5 ff ff       	call   8010184e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801062e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062e7:	66 83 f8 01          	cmp    $0x1,%ax
801062eb:	75 1c                	jne    80106309 <sys_open+0xdc>
801062ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062f0:	85 c0                	test   %eax,%eax
801062f2:	74 15                	je     80106309 <sys_open+0xdc>
      iunlockput(ip);
801062f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f7:	89 04 24             	mov    %eax,(%esp)
801062fa:	e8 d3 b7 ff ff       	call   80101ad2 <iunlockput>
      return -1;
801062ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106304:	e9 aa 00 00 00       	jmp    801063b3 <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106309:	e8 0b ac ff ff       	call   80100f19 <filealloc>
8010630e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106311:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106315:	74 14                	je     8010632b <sys_open+0xfe>
80106317:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010631a:	89 04 24             	mov    %eax,(%esp)
8010631d:	e8 42 f7 ff ff       	call   80105a64 <fdalloc>
80106322:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106325:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106329:	79 23                	jns    8010634e <sys_open+0x121>
    if(f)
8010632b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010632f:	74 0b                	je     8010633c <sys_open+0x10f>
      fileclose(f);
80106331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106334:	89 04 24             	mov    %eax,(%esp)
80106337:	e8 85 ac ff ff       	call   80100fc1 <fileclose>
    iunlockput(ip);
8010633c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010633f:	89 04 24             	mov    %eax,(%esp)
80106342:	e8 8b b7 ff ff       	call   80101ad2 <iunlockput>
    return -1;
80106347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010634c:	eb 65                	jmp    801063b3 <sys_open+0x186>
  }
  iunlock(ip);
8010634e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106351:	89 04 24             	mov    %eax,(%esp)
80106354:	e8 43 b6 ff ff       	call   8010199c <iunlock>

  f->type = FD_INODE;
80106359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010635c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106362:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106368:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010636b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010636e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106375:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106378:	83 e0 01             	and    $0x1,%eax
8010637b:	85 c0                	test   %eax,%eax
8010637d:	0f 94 c0             	sete   %al
80106380:	89 c2                	mov    %eax,%edx
80106382:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106385:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010638b:	83 e0 01             	and    $0x1,%eax
8010638e:	85 c0                	test   %eax,%eax
80106390:	75 0a                	jne    8010639c <sys_open+0x16f>
80106392:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106395:	83 e0 02             	and    $0x2,%eax
80106398:	85 c0                	test   %eax,%eax
8010639a:	74 07                	je     801063a3 <sys_open+0x176>
8010639c:	b8 01 00 00 00       	mov    $0x1,%eax
801063a1:	eb 05                	jmp    801063a8 <sys_open+0x17b>
801063a3:	b8 00 00 00 00       	mov    $0x0,%eax
801063a8:	89 c2                	mov    %eax,%edx
801063aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ad:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801063b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801063b3:	c9                   	leave  
801063b4:	c3                   	ret    

801063b5 <sys_mkdir>:

int
sys_mkdir(void)
{
801063b5:	55                   	push   %ebp
801063b6:	89 e5                	mov    %esp,%ebp
801063b8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
801063bb:	e8 18 ce ff ff       	call   801031d8 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801063c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801063c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063ce:	e8 16 f5 ff ff       	call   801058e9 <argstr>
801063d3:	85 c0                	test   %eax,%eax
801063d5:	78 2c                	js     80106403 <sys_mkdir+0x4e>
801063d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801063e1:	00 
801063e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801063e9:	00 
801063ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801063f1:	00 
801063f2:	89 04 24             	mov    %eax,(%esp)
801063f5:	e8 73 fc ff ff       	call   8010606d <create>
801063fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106401:	75 0c                	jne    8010640f <sys_mkdir+0x5a>
    commit_trans();
80106403:	e8 19 ce ff ff       	call   80103221 <commit_trans>
    return -1;
80106408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010640d:	eb 15                	jmp    80106424 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010640f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106412:	89 04 24             	mov    %eax,(%esp)
80106415:	e8 b8 b6 ff ff       	call   80101ad2 <iunlockput>
  commit_trans();
8010641a:	e8 02 ce ff ff       	call   80103221 <commit_trans>
  return 0;
8010641f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106424:	c9                   	leave  
80106425:	c3                   	ret    

80106426 <sys_mknod>:

int
sys_mknod(void)
{
80106426:	55                   	push   %ebp
80106427:	89 e5                	mov    %esp,%ebp
80106429:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
8010642c:	e8 a7 cd ff ff       	call   801031d8 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80106431:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106434:	89 44 24 04          	mov    %eax,0x4(%esp)
80106438:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010643f:	e8 a5 f4 ff ff       	call   801058e9 <argstr>
80106444:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010644b:	78 5e                	js     801064ab <sys_mknod+0x85>
     argint(1, &major) < 0 ||
8010644d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106450:	89 44 24 04          	mov    %eax,0x4(%esp)
80106454:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010645b:	e8 ef f3 ff ff       	call   8010584f <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80106460:	85 c0                	test   %eax,%eax
80106462:	78 47                	js     801064ab <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106464:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106467:	89 44 24 04          	mov    %eax,0x4(%esp)
8010646b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106472:	e8 d8 f3 ff ff       	call   8010584f <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106477:	85 c0                	test   %eax,%eax
80106479:	78 30                	js     801064ab <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010647b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010647e:	0f bf c8             	movswl %ax,%ecx
80106481:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106484:	0f bf d0             	movswl %ax,%edx
80106487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010648a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010648e:	89 54 24 08          	mov    %edx,0x8(%esp)
80106492:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106499:	00 
8010649a:	89 04 24             	mov    %eax,(%esp)
8010649d:	e8 cb fb ff ff       	call   8010606d <create>
801064a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064a9:	75 0c                	jne    801064b7 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
801064ab:	e8 71 cd ff ff       	call   80103221 <commit_trans>
    return -1;
801064b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b5:	eb 15                	jmp    801064cc <sys_mknod+0xa6>
  }
  iunlockput(ip);
801064b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ba:	89 04 24             	mov    %eax,(%esp)
801064bd:	e8 10 b6 ff ff       	call   80101ad2 <iunlockput>
  commit_trans();
801064c2:	e8 5a cd ff ff       	call   80103221 <commit_trans>
  return 0;
801064c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064cc:	c9                   	leave  
801064cd:	c3                   	ret    

801064ce <sys_chdir>:

int
sys_chdir(void)
{
801064ce:	55                   	push   %ebp
801064cf:	89 e5                	mov    %esp,%ebp
801064d1:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801064d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801064db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064e2:	e8 02 f4 ff ff       	call   801058e9 <argstr>
801064e7:	85 c0                	test   %eax,%eax
801064e9:	78 14                	js     801064ff <sys_chdir+0x31>
801064eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ee:	89 04 24             	mov    %eax,(%esp)
801064f1:	e8 03 bf ff ff       	call   801023f9 <namei>
801064f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064fd:	75 07                	jne    80106506 <sys_chdir+0x38>
    return -1;
801064ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106504:	eb 57                	jmp    8010655d <sys_chdir+0x8f>
  ilock(ip);
80106506:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106509:	89 04 24             	mov    %eax,(%esp)
8010650c:	e8 3d b3 ff ff       	call   8010184e <ilock>
  if(ip->type != T_DIR){
80106511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106514:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106518:	66 83 f8 01          	cmp    $0x1,%ax
8010651c:	74 12                	je     80106530 <sys_chdir+0x62>
    iunlockput(ip);
8010651e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106521:	89 04 24             	mov    %eax,(%esp)
80106524:	e8 a9 b5 ff ff       	call   80101ad2 <iunlockput>
    return -1;
80106529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010652e:	eb 2d                	jmp    8010655d <sys_chdir+0x8f>
  }
  iunlock(ip);
80106530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106533:	89 04 24             	mov    %eax,(%esp)
80106536:	e8 61 b4 ff ff       	call   8010199c <iunlock>
  iput(proc->cwd);
8010653b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106541:	8b 40 68             	mov    0x68(%eax),%eax
80106544:	89 04 24             	mov    %eax,(%esp)
80106547:	e8 b5 b4 ff ff       	call   80101a01 <iput>
  proc->cwd = ip;
8010654c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106552:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106555:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106558:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010655d:	c9                   	leave  
8010655e:	c3                   	ret    

8010655f <sys_exec>:

int
sys_exec(void)
{
8010655f:	55                   	push   %ebp
80106560:	89 e5                	mov    %esp,%ebp
80106562:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106568:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010656b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010656f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106576:	e8 6e f3 ff ff       	call   801058e9 <argstr>
8010657b:	85 c0                	test   %eax,%eax
8010657d:	78 1a                	js     80106599 <sys_exec+0x3a>
8010657f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106585:	89 44 24 04          	mov    %eax,0x4(%esp)
80106589:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106590:	e8 ba f2 ff ff       	call   8010584f <argint>
80106595:	85 c0                	test   %eax,%eax
80106597:	79 0a                	jns    801065a3 <sys_exec+0x44>
    return -1;
80106599:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010659e:	e9 de 00 00 00       	jmp    80106681 <sys_exec+0x122>
  }
  memset(argv, 0, sizeof(argv));
801065a3:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801065aa:	00 
801065ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065b2:	00 
801065b3:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065b9:	89 04 24             	mov    %eax,(%esp)
801065bc:	e8 58 ef ff ff       	call   80105519 <memset>
  for(i=0;; i++){
801065c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801065c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065cb:	83 f8 1f             	cmp    $0x1f,%eax
801065ce:	76 0a                	jbe    801065da <sys_exec+0x7b>
      return -1;
801065d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d5:	e9 a7 00 00 00       	jmp    80106681 <sys_exec+0x122>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
801065da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065dd:	c1 e0 02             	shl    $0x2,%eax
801065e0:	89 c2                	mov    %eax,%edx
801065e2:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801065e8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801065eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065f1:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
801065f7:	89 54 24 08          	mov    %edx,0x8(%esp)
801065fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801065ff:	89 04 24             	mov    %eax,(%esp)
80106602:	e8 b8 f1 ff ff       	call   801057bf <fetchint>
80106607:	85 c0                	test   %eax,%eax
80106609:	79 07                	jns    80106612 <sys_exec+0xb3>
      return -1;
8010660b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106610:	eb 6f                	jmp    80106681 <sys_exec+0x122>
    if(uarg == 0){
80106612:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106618:	85 c0                	test   %eax,%eax
8010661a:	75 26                	jne    80106642 <sys_exec+0xe3>
      argv[i] = 0;
8010661c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661f:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106626:	00 00 00 00 
      break;
8010662a:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010662b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010662e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106634:	89 54 24 04          	mov    %edx,0x4(%esp)
80106638:	89 04 24             	mov    %eax,(%esp)
8010663b:	e8 af a4 ff ff       	call   80100aef <exec>
80106640:	eb 3f                	jmp    80106681 <sys_exec+0x122>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
80106642:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106648:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010664b:	c1 e2 02             	shl    $0x2,%edx
8010664e:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80106651:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106657:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010665d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106661:	89 54 24 04          	mov    %edx,0x4(%esp)
80106665:	89 04 24             	mov    %eax,(%esp)
80106668:	e8 86 f1 ff ff       	call   801057f3 <fetchstr>
8010666d:	85 c0                	test   %eax,%eax
8010666f:	79 07                	jns    80106678 <sys_exec+0x119>
      return -1;
80106671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106676:	eb 09                	jmp    80106681 <sys_exec+0x122>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106678:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
8010667c:	e9 47 ff ff ff       	jmp    801065c8 <sys_exec+0x69>
  return exec(path, argv);
}
80106681:	c9                   	leave  
80106682:	c3                   	ret    

80106683 <sys_pipe>:

int
sys_pipe(void)
{
80106683:	55                   	push   %ebp
80106684:	89 e5                	mov    %esp,%ebp
80106686:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106689:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106690:	00 
80106691:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106694:	89 44 24 04          	mov    %eax,0x4(%esp)
80106698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010669f:	e8 e3 f1 ff ff       	call   80105887 <argptr>
801066a4:	85 c0                	test   %eax,%eax
801066a6:	79 0a                	jns    801066b2 <sys_pipe+0x2f>
    return -1;
801066a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ad:	e9 9b 00 00 00       	jmp    8010674d <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801066b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801066b9:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066bc:	89 04 24             	mov    %eax,(%esp)
801066bf:	e8 25 d5 ff ff       	call   80103be9 <pipealloc>
801066c4:	85 c0                	test   %eax,%eax
801066c6:	79 07                	jns    801066cf <sys_pipe+0x4c>
    return -1;
801066c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066cd:	eb 7e                	jmp    8010674d <sys_pipe+0xca>
  fd0 = -1;
801066cf:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801066d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066d9:	89 04 24             	mov    %eax,(%esp)
801066dc:	e8 83 f3 ff ff       	call   80105a64 <fdalloc>
801066e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066e8:	78 14                	js     801066fe <sys_pipe+0x7b>
801066ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066ed:	89 04 24             	mov    %eax,(%esp)
801066f0:	e8 6f f3 ff ff       	call   80105a64 <fdalloc>
801066f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066fc:	79 37                	jns    80106735 <sys_pipe+0xb2>
    if(fd0 >= 0)
801066fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106702:	78 14                	js     80106718 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106704:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010670a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010670d:	83 c2 08             	add    $0x8,%edx
80106710:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106717:	00 
    fileclose(rf);
80106718:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010671b:	89 04 24             	mov    %eax,(%esp)
8010671e:	e8 9e a8 ff ff       	call   80100fc1 <fileclose>
    fileclose(wf);
80106723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106726:	89 04 24             	mov    %eax,(%esp)
80106729:	e8 93 a8 ff ff       	call   80100fc1 <fileclose>
    return -1;
8010672e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106733:	eb 18                	jmp    8010674d <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106735:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106738:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010673b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010673d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106740:	8d 50 04             	lea    0x4(%eax),%edx
80106743:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106746:	89 02                	mov    %eax,(%edx)
  return 0;
80106748:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010674d:	c9                   	leave  
8010674e:	c3                   	ret    

8010674f <sys_wait2>:
#include "mmu.h"
#include "proc.h"

int 
sys_wait2(void)
{
8010674f:	55                   	push   %ebp
80106750:	89 e5                	mov    %esp,%ebp
80106752:	83 ec 28             	sub    $0x28,%esp
    int *wtime, *rtime, *iotime;
    if ((argptr(0, (void*)&wtime, sizeof(wtime))) < 0)
80106755:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010675c:	00 
8010675d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106760:	89 44 24 04          	mov    %eax,0x4(%esp)
80106764:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010676b:	e8 17 f1 ff ff       	call   80105887 <argptr>
80106770:	85 c0                	test   %eax,%eax
80106772:	79 07                	jns    8010677b <sys_wait2+0x2c>
    	return -1;
80106774:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106779:	eb 65                	jmp    801067e0 <sys_wait2+0x91>
    if ((argptr(1, (void*)&rtime, sizeof(rtime))) < 0)
8010677b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106782:	00 
80106783:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106786:	89 44 24 04          	mov    %eax,0x4(%esp)
8010678a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106791:	e8 f1 f0 ff ff       	call   80105887 <argptr>
80106796:	85 c0                	test   %eax,%eax
80106798:	79 07                	jns    801067a1 <sys_wait2+0x52>
    	return -1;
8010679a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010679f:	eb 3f                	jmp    801067e0 <sys_wait2+0x91>
    if ((argptr(2, (void*)&iotime, sizeof(iotime))) < 0)
801067a1:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801067a8:	00 
801067a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801067ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801067b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801067b7:	e8 cb f0 ff ff       	call   80105887 <argptr>
801067bc:	85 c0                	test   %eax,%eax
801067be:	79 07                	jns    801067c7 <sys_wait2+0x78>
    	return -1;
801067c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c5:	eb 19                	jmp    801067e0 <sys_wait2+0x91>

    return wait2(wtime, rtime, iotime);
801067c7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801067ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801067cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067d4:	89 54 24 04          	mov    %edx,0x4(%esp)
801067d8:	89 04 24             	mov    %eax,(%esp)
801067db:	e8 54 e1 ff ff       	call   80104934 <wait2>
}
801067e0:	c9                   	leave  
801067e1:	c3                   	ret    

801067e2 <sys_get_sched_record>:

int
sys_get_sched_record(void)
{
801067e2:	55                   	push   %ebp
801067e3:	89 e5                	mov    %esp,%ebp
801067e5:	83 ec 28             	sub    $0x28,%esp
	int *s_tick, *e_tick, *cpu;
    if ((argptr(0, (void*)&s_tick, sizeof(s_tick))) <0)
801067e8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801067ef:	00 
801067f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801067f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067fe:	e8 84 f0 ff ff       	call   80105887 <argptr>
80106803:	85 c0                	test   %eax,%eax
80106805:	79 07                	jns    8010680e <sys_get_sched_record+0x2c>
    	return -1;
80106807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010680c:	eb 65                	jmp    80106873 <sys_get_sched_record+0x91>
    if ((argptr(1, (void*)&e_tick, sizeof(e_tick))) <0)
8010680e:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106815:	00 
80106816:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106819:	89 44 24 04          	mov    %eax,0x4(%esp)
8010681d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106824:	e8 5e f0 ff ff       	call   80105887 <argptr>
80106829:	85 c0                	test   %eax,%eax
8010682b:	79 07                	jns    80106834 <sys_get_sched_record+0x52>
    	return -1;
8010682d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106832:	eb 3f                	jmp    80106873 <sys_get_sched_record+0x91>
    if ((argptr(2, (void*)&cpu, sizeof(cpu))) <0)
80106834:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010683b:	00 
8010683c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010683f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106843:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010684a:	e8 38 f0 ff ff       	call   80105887 <argptr>
8010684f:	85 c0                	test   %eax,%eax
80106851:	79 07                	jns    8010685a <sys_get_sched_record+0x78>
    	return -1;
80106853:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106858:	eb 19                	jmp    80106873 <sys_get_sched_record+0x91>

    return get_sched_record(s_tick, e_tick, cpu);
8010685a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010685d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106863:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106867:	89 54 24 04          	mov    %edx,0x4(%esp)
8010686b:	89 04 24             	mov    %eax,(%esp)
8010686e:	e8 25 e2 ff ff       	call   80104a98 <get_sched_record>
}
80106873:	c9                   	leave  
80106874:	c3                   	ret    

80106875 <sys_getPriority>:

int
sys_getPriority(void)
{
80106875:	55                   	push   %ebp
80106876:	89 e5                	mov    %esp,%ebp
80106878:	83 ec 28             	sub    $0x28,%esp
   int *pid;
   if((argptr(0,(void*) &pid,sizeof(&pid))) < 0) return -1;
8010687b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106882:	00 
80106883:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106886:	89 44 24 04          	mov    %eax,0x4(%esp)
8010688a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106891:	e8 f1 ef ff ff       	call   80105887 <argptr>
80106896:	85 c0                	test   %eax,%eax
80106898:	79 07                	jns    801068a1 <sys_getPriority+0x2c>
8010689a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010689f:	eb 0b                	jmp    801068ac <sys_getPriority+0x37>
   return getPriority(pid);
801068a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a4:	89 04 24             	mov    %eax,(%esp)
801068a7:	e8 f6 e1 ff ff       	call   80104aa2 <getPriority>
}
801068ac:	c9                   	leave  
801068ad:	c3                   	ret    

801068ae <sys_fork>:

int
sys_fork(void)
{
801068ae:	55                   	push   %ebp
801068af:	89 e5                	mov    %esp,%ebp
801068b1:	83 ec 08             	sub    $0x8,%esp
  return fork();
801068b4:	e8 a6 dc ff ff       	call   8010455f <fork>
}
801068b9:	c9                   	leave  
801068ba:	c3                   	ret    

801068bb <sys_exit>:

int
sys_exit(void)
{
801068bb:	55                   	push   %ebp
801068bc:	89 e5                	mov    %esp,%ebp
801068be:	83 ec 08             	sub    $0x8,%esp
  exit();
801068c1:	e8 10 de ff ff       	call   801046d6 <exit>
  return 0;  // not reached
801068c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068cb:	c9                   	leave  
801068cc:	c3                   	ret    

801068cd <sys_wait>:

int
sys_wait(void)
{
801068cd:	55                   	push   %ebp
801068ce:	89 e5                	mov    %esp,%ebp
801068d0:	83 ec 08             	sub    $0x8,%esp
  return wait();
801068d3:	e8 4a df ff ff       	call   80104822 <wait>
}
801068d8:	c9                   	leave  
801068d9:	c3                   	ret    

801068da <sys_kill>:

int
sys_kill(void)
{
801068da:	55                   	push   %ebp
801068db:	89 e5                	mov    %esp,%ebp
801068dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801068e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801068e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068ee:	e8 5c ef ff ff       	call   8010584f <argint>
801068f3:	85 c0                	test   %eax,%eax
801068f5:	79 07                	jns    801068fe <sys_kill+0x24>
    return -1;
801068f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068fc:	eb 0b                	jmp    80106909 <sys_kill+0x2f>
  return kill(pid);
801068fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106901:	89 04 24             	mov    %eax,(%esp)
80106904:	e8 c0 e7 ff ff       	call   801050c9 <kill>
}
80106909:	c9                   	leave  
8010690a:	c3                   	ret    

8010690b <sys_getpid>:

int
sys_getpid(void)
{
8010690b:	55                   	push   %ebp
8010690c:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010690e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106914:	8b 40 10             	mov    0x10(%eax),%eax
}
80106917:	5d                   	pop    %ebp
80106918:	c3                   	ret    

80106919 <sys_sbrk>:

int
sys_sbrk(void)
{
80106919:	55                   	push   %ebp
8010691a:	89 e5                	mov    %esp,%ebp
8010691c:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010691f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106922:	89 44 24 04          	mov    %eax,0x4(%esp)
80106926:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010692d:	e8 1d ef ff ff       	call   8010584f <argint>
80106932:	85 c0                	test   %eax,%eax
80106934:	79 07                	jns    8010693d <sys_sbrk+0x24>
    return -1;
80106936:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010693b:	eb 24                	jmp    80106961 <sys_sbrk+0x48>
  addr = proc->sz;
8010693d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106943:	8b 00                	mov    (%eax),%eax
80106945:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106948:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010694b:	89 04 24             	mov    %eax,(%esp)
8010694e:	e8 67 db ff ff       	call   801044ba <growproc>
80106953:	85 c0                	test   %eax,%eax
80106955:	79 07                	jns    8010695e <sys_sbrk+0x45>
    return -1;
80106957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695c:	eb 03                	jmp    80106961 <sys_sbrk+0x48>
  return addr;
8010695e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106961:	c9                   	leave  
80106962:	c3                   	ret    

80106963 <sys_sleep>:

int
sys_sleep(void)
{
80106963:	55                   	push   %ebp
80106964:	89 e5                	mov    %esp,%ebp
80106966:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106969:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010696c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106970:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106977:	e8 d3 ee ff ff       	call   8010584f <argint>
8010697c:	85 c0                	test   %eax,%eax
8010697e:	79 07                	jns    80106987 <sys_sleep+0x24>
    return -1;
80106980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106985:	eb 6c                	jmp    801069f3 <sys_sleep+0x90>
  acquire(&tickslock);
80106987:	c7 04 24 80 2a 15 80 	movl   $0x80152a80,(%esp)
8010698e:	e8 32 e9 ff ff       	call   801052c5 <acquire>
  ticks0 = ticks;
80106993:	a1 c0 32 15 80       	mov    0x801532c0,%eax
80106998:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010699b:	eb 34                	jmp    801069d1 <sys_sleep+0x6e>
    if(proc->killed){
8010699d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a3:	8b 40 24             	mov    0x24(%eax),%eax
801069a6:	85 c0                	test   %eax,%eax
801069a8:	74 13                	je     801069bd <sys_sleep+0x5a>
      release(&tickslock);
801069aa:	c7 04 24 80 2a 15 80 	movl   $0x80152a80,(%esp)
801069b1:	e8 71 e9 ff ff       	call   80105327 <release>
      return -1;
801069b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069bb:	eb 36                	jmp    801069f3 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801069bd:	c7 44 24 04 80 2a 15 	movl   $0x80152a80,0x4(%esp)
801069c4:	80 
801069c5:	c7 04 24 c0 32 15 80 	movl   $0x801532c0,(%esp)
801069cc:	e8 83 e5 ff ff       	call   80104f54 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801069d1:	a1 c0 32 15 80       	mov    0x801532c0,%eax
801069d6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801069d9:	89 c2                	mov    %eax,%edx
801069db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069de:	39 c2                	cmp    %eax,%edx
801069e0:	72 bb                	jb     8010699d <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801069e2:	c7 04 24 80 2a 15 80 	movl   $0x80152a80,(%esp)
801069e9:	e8 39 e9 ff ff       	call   80105327 <release>
  return 0;
801069ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069f3:	c9                   	leave  
801069f4:	c3                   	ret    

801069f5 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801069f5:	55                   	push   %ebp
801069f6:	89 e5                	mov    %esp,%ebp
801069f8:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801069fb:	c7 04 24 80 2a 15 80 	movl   $0x80152a80,(%esp)
80106a02:	e8 be e8 ff ff       	call   801052c5 <acquire>
  xticks = ticks;
80106a07:	a1 c0 32 15 80       	mov    0x801532c0,%eax
80106a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106a0f:	c7 04 24 80 2a 15 80 	movl   $0x80152a80,(%esp)
80106a16:	e8 0c e9 ff ff       	call   80105327 <release>
  return xticks;
80106a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a1e:	c9                   	leave  
80106a1f:	c3                   	ret    

80106a20 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	83 ec 08             	sub    $0x8,%esp
80106a26:	8b 55 08             	mov    0x8(%ebp),%edx
80106a29:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a2c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a30:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a33:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a37:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a3b:	ee                   	out    %al,(%dx)
}
80106a3c:	c9                   	leave  
80106a3d:	c3                   	ret    

80106a3e <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106a3e:	55                   	push   %ebp
80106a3f:	89 e5                	mov    %esp,%ebp
80106a41:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106a44:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106a4b:	00 
80106a4c:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106a53:	e8 c8 ff ff ff       	call   80106a20 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106a58:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106a5f:	00 
80106a60:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106a67:	e8 b4 ff ff ff       	call   80106a20 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106a6c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106a73:	00 
80106a74:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106a7b:	e8 a0 ff ff ff       	call   80106a20 <outb>
  picenable(IRQ_TIMER);
80106a80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a87:	e8 f0 cf ff ff       	call   80103a7c <picenable>
}
80106a8c:	c9                   	leave  
80106a8d:	c3                   	ret    

80106a8e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a8e:	1e                   	push   %ds
  pushl %es
80106a8f:	06                   	push   %es
  pushl %fs
80106a90:	0f a0                	push   %fs
  pushl %gs
80106a92:	0f a8                	push   %gs
  pushal
80106a94:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106a95:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a99:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a9b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106a9d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106aa1:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106aa3:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106aa5:	54                   	push   %esp
  call trap
80106aa6:	e8 d8 01 00 00       	call   80106c83 <trap>
  addl $4, %esp
80106aab:	83 c4 04             	add    $0x4,%esp

80106aae <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106aae:	61                   	popa   
  popl %gs
80106aaf:	0f a9                	pop    %gs
  popl %fs
80106ab1:	0f a1                	pop    %fs
  popl %es
80106ab3:	07                   	pop    %es
  popl %ds
80106ab4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106ab5:	83 c4 08             	add    $0x8,%esp
  iret
80106ab8:	cf                   	iret   

80106ab9 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106ab9:	55                   	push   %ebp
80106aba:	89 e5                	mov    %esp,%ebp
80106abc:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106abf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ac2:	83 e8 01             	sub    $0x1,%eax
80106ac5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80106acc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad3:	c1 e8 10             	shr    $0x10,%eax
80106ad6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106ada:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106add:	0f 01 18             	lidtl  (%eax)
}
80106ae0:	c9                   	leave  
80106ae1:	c3                   	ret    

80106ae2 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106ae2:	55                   	push   %ebp
80106ae3:	89 e5                	mov    %esp,%ebp
80106ae5:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106ae8:	0f 20 d0             	mov    %cr2,%eax
80106aeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106af1:	c9                   	leave  
80106af2:	c3                   	ret    

80106af3 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
80106af3:	55                   	push   %ebp
80106af4:	89 e5                	mov    %esp,%ebp
80106af6:	83 ec 28             	sub    $0x28,%esp
	int i;

	for (i = 0; i < 256; i++)
80106af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106b00:	e9 c3 00 00 00       	jmp    80106bc8 <tvinit+0xd5>
		SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b08:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
80106b0f:	89 c2                	mov    %eax,%edx
80106b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b14:	66 89 14 c5 c0 2a 15 	mov    %dx,-0x7fead540(,%eax,8)
80106b1b:	80 
80106b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b1f:	66 c7 04 c5 c2 2a 15 	movw   $0x8,-0x7fead53e(,%eax,8)
80106b26:	80 08 00 
80106b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2c:	0f b6 14 c5 c4 2a 15 	movzbl -0x7fead53c(,%eax,8),%edx
80106b33:	80 
80106b34:	83 e2 e0             	and    $0xffffffe0,%edx
80106b37:	88 14 c5 c4 2a 15 80 	mov    %dl,-0x7fead53c(,%eax,8)
80106b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b41:	0f b6 14 c5 c4 2a 15 	movzbl -0x7fead53c(,%eax,8),%edx
80106b48:	80 
80106b49:	83 e2 1f             	and    $0x1f,%edx
80106b4c:	88 14 c5 c4 2a 15 80 	mov    %dl,-0x7fead53c(,%eax,8)
80106b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b56:	0f b6 14 c5 c5 2a 15 	movzbl -0x7fead53b(,%eax,8),%edx
80106b5d:	80 
80106b5e:	83 e2 f0             	and    $0xfffffff0,%edx
80106b61:	83 ca 0e             	or     $0xe,%edx
80106b64:	88 14 c5 c5 2a 15 80 	mov    %dl,-0x7fead53b(,%eax,8)
80106b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b6e:	0f b6 14 c5 c5 2a 15 	movzbl -0x7fead53b(,%eax,8),%edx
80106b75:	80 
80106b76:	83 e2 ef             	and    $0xffffffef,%edx
80106b79:	88 14 c5 c5 2a 15 80 	mov    %dl,-0x7fead53b(,%eax,8)
80106b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b83:	0f b6 14 c5 c5 2a 15 	movzbl -0x7fead53b(,%eax,8),%edx
80106b8a:	80 
80106b8b:	83 e2 9f             	and    $0xffffff9f,%edx
80106b8e:	88 14 c5 c5 2a 15 80 	mov    %dl,-0x7fead53b(,%eax,8)
80106b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b98:	0f b6 14 c5 c5 2a 15 	movzbl -0x7fead53b(,%eax,8),%edx
80106b9f:	80 
80106ba0:	83 ca 80             	or     $0xffffff80,%edx
80106ba3:	88 14 c5 c5 2a 15 80 	mov    %dl,-0x7fead53b(,%eax,8)
80106baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bad:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
80106bb4:	c1 e8 10             	shr    $0x10,%eax
80106bb7:	89 c2                	mov    %eax,%edx
80106bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bbc:	66 89 14 c5 c6 2a 15 	mov    %dx,-0x7fead53a(,%eax,8)
80106bc3:	80 
uint ticks;

void tvinit(void) {
	int i;

	for (i = 0; i < 256; i++)
80106bc4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bc8:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106bcf:	0f 8e 30 ff ff ff    	jle    80106b05 <tvinit+0x12>
		SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106bd5:	a1 a0 c1 10 80       	mov    0x8010c1a0,%eax
80106bda:	66 a3 c0 2c 15 80    	mov    %ax,0x80152cc0
80106be0:	66 c7 05 c2 2c 15 80 	movw   $0x8,0x80152cc2
80106be7:	08 00 
80106be9:	0f b6 05 c4 2c 15 80 	movzbl 0x80152cc4,%eax
80106bf0:	83 e0 e0             	and    $0xffffffe0,%eax
80106bf3:	a2 c4 2c 15 80       	mov    %al,0x80152cc4
80106bf8:	0f b6 05 c4 2c 15 80 	movzbl 0x80152cc4,%eax
80106bff:	83 e0 1f             	and    $0x1f,%eax
80106c02:	a2 c4 2c 15 80       	mov    %al,0x80152cc4
80106c07:	0f b6 05 c5 2c 15 80 	movzbl 0x80152cc5,%eax
80106c0e:	83 c8 0f             	or     $0xf,%eax
80106c11:	a2 c5 2c 15 80       	mov    %al,0x80152cc5
80106c16:	0f b6 05 c5 2c 15 80 	movzbl 0x80152cc5,%eax
80106c1d:	83 e0 ef             	and    $0xffffffef,%eax
80106c20:	a2 c5 2c 15 80       	mov    %al,0x80152cc5
80106c25:	0f b6 05 c5 2c 15 80 	movzbl 0x80152cc5,%eax
80106c2c:	83 c8 60             	or     $0x60,%eax
80106c2f:	a2 c5 2c 15 80       	mov    %al,0x80152cc5
80106c34:	0f b6 05 c5 2c 15 80 	movzbl 0x80152cc5,%eax
80106c3b:	83 c8 80             	or     $0xffffff80,%eax
80106c3e:	a2 c5 2c 15 80       	mov    %al,0x80152cc5
80106c43:	a1 a0 c1 10 80       	mov    0x8010c1a0,%eax
80106c48:	c1 e8 10             	shr    $0x10,%eax
80106c4b:	66 a3 c6 2c 15 80    	mov    %ax,0x80152cc6

	initlock(&tickslock, "time");
80106c51:	c7 44 24 04 a4 8e 10 	movl   $0x80108ea4,0x4(%esp)
80106c58:	80 
80106c59:	c7 04 24 80 2a 15 80 	movl   $0x80152a80,(%esp)
80106c60:	e8 3f e6 ff ff       	call   801052a4 <initlock>
}
80106c65:	c9                   	leave  
80106c66:	c3                   	ret    

80106c67 <idtinit>:

void idtinit(void) {
80106c67:	55                   	push   %ebp
80106c68:	89 e5                	mov    %esp,%ebp
80106c6a:	83 ec 08             	sub    $0x8,%esp
	lidt(idt, sizeof(idt));
80106c6d:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106c74:	00 
80106c75:	c7 04 24 c0 2a 15 80 	movl   $0x80152ac0,(%esp)
80106c7c:	e8 38 fe ff ff       	call   80106ab9 <lidt>
}
80106c81:	c9                   	leave  
80106c82:	c3                   	ret    

80106c83 <trap>:

//PAGEBREAK: 41
void trap(struct trapframe *tf) {
80106c83:	55                   	push   %ebp
80106c84:	89 e5                	mov    %esp,%ebp
80106c86:	57                   	push   %edi
80106c87:	56                   	push   %esi
80106c88:	53                   	push   %ebx
80106c89:	83 ec 4c             	sub    $0x4c,%esp
	if (tf->trapno == T_SYSCALL) {
80106c8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8f:	8b 40 30             	mov    0x30(%eax),%eax
80106c92:	83 f8 40             	cmp    $0x40,%eax
80106c95:	75 3f                	jne    80106cd6 <trap+0x53>
		if (proc->killed)
80106c97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c9d:	8b 40 24             	mov    0x24(%eax),%eax
80106ca0:	85 c0                	test   %eax,%eax
80106ca2:	74 05                	je     80106ca9 <trap+0x26>
			exit();
80106ca4:	e8 2d da ff ff       	call   801046d6 <exit>
		proc->tf = tf;
80106ca9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106caf:	8b 55 08             	mov    0x8(%ebp),%edx
80106cb2:	89 50 18             	mov    %edx,0x18(%eax)
		syscall();
80106cb5:	e8 72 ec ff ff       	call   8010592c <syscall>
		if (proc->killed)
80106cba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cc0:	8b 40 24             	mov    0x24(%eax),%eax
80106cc3:	85 c0                	test   %eax,%eax
80106cc5:	74 0a                	je     80106cd1 <trap+0x4e>
			exit();
80106cc7:	e8 0a da ff ff       	call   801046d6 <exit>
		return;
80106ccc:	e9 75 02 00 00       	jmp    80106f46 <trap+0x2c3>
80106cd1:	e9 70 02 00 00       	jmp    80106f46 <trap+0x2c3>
	}

	switch (tf->trapno) {
80106cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd9:	8b 40 30             	mov    0x30(%eax),%eax
80106cdc:	83 e8 20             	sub    $0x20,%eax
80106cdf:	83 f8 1f             	cmp    $0x1f,%eax
80106ce2:	0f 87 c1 00 00 00    	ja     80106da9 <trap+0x126>
80106ce8:	8b 04 85 4c 8f 10 80 	mov    -0x7fef70b4(,%eax,4),%eax
80106cef:	ff e0                	jmp    *%eax
	case T_IRQ0 + IRQ_TIMER:
		if (cpu->id == 0) {
80106cf1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cf7:	0f b6 00             	movzbl (%eax),%eax
80106cfa:	84 c0                	test   %al,%al
80106cfc:	75 36                	jne    80106d34 <trap+0xb1>
			acquire(&tickslock);
80106cfe:	c7 04 24 80 2a 15 80 	movl   $0x80152a80,(%esp)
80106d05:	e8 bb e5 ff ff       	call   801052c5 <acquire>
			ticks++;
80106d0a:	a1 c0 32 15 80       	mov    0x801532c0,%eax
80106d0f:	83 c0 01             	add    $0x1,%eax
80106d12:	a3 c0 32 15 80       	mov    %eax,0x801532c0
			updateProc();
80106d17:	e8 a8 d4 ff ff       	call   801041c4 <updateProc>
			wakeup(&ticks);
80106d1c:	c7 04 24 c0 32 15 80 	movl   $0x801532c0,(%esp)
80106d23:	e8 76 e3 ff ff       	call   8010509e <wakeup>
			release(&tickslock);
80106d28:	c7 04 24 80 2a 15 80 	movl   $0x80152a80,(%esp)
80106d2f:	e8 f3 e5 ff ff       	call   80105327 <release>
		}
		lapiceoi();
80106d34:	e8 6d c1 ff ff       	call   80102ea6 <lapiceoi>
		break;
80106d39:	e9 41 01 00 00       	jmp    80106e7f <trap+0x1fc>
	case T_IRQ0 + IRQ_IDE:
		ideintr();
80106d3e:	e8 8e b9 ff ff       	call   801026d1 <ideintr>
		lapiceoi();
80106d43:	e8 5e c1 ff ff       	call   80102ea6 <lapiceoi>
		break;
80106d48:	e9 32 01 00 00       	jmp    80106e7f <trap+0x1fc>
	case T_IRQ0 + IRQ_IDE + 1:
		// Bochs generates spurious IDE1 interrupts.
		break;
	case T_IRQ0 + IRQ_KBD:
		kbdintr();
80106d4d:	e8 40 bf ff ff       	call   80102c92 <kbdintr>
		lapiceoi();
80106d52:	e8 4f c1 ff ff       	call   80102ea6 <lapiceoi>
		break;
80106d57:	e9 23 01 00 00       	jmp    80106e7f <trap+0x1fc>
	case T_IRQ0 + IRQ_COM1:
		uartintr();
80106d5c:	e8 da 03 00 00       	call   8010713b <uartintr>
		lapiceoi();
80106d61:	e8 40 c1 ff ff       	call   80102ea6 <lapiceoi>
		break;
80106d66:	e9 14 01 00 00       	jmp    80106e7f <trap+0x1fc>
	case T_IRQ0 + 7:
	case T_IRQ0 + IRQ_SPURIOUS:
		cprintf("cpu%d: spurious interrupt at %x:%x\n", cpu->id, tf->cs,
80106d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6e:	8b 48 38             	mov    0x38(%eax),%ecx
80106d71:	8b 45 08             	mov    0x8(%ebp),%eax
80106d74:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d78:	0f b7 d0             	movzwl %ax,%edx
80106d7b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d81:	0f b6 00             	movzbl (%eax),%eax
80106d84:	0f b6 c0             	movzbl %al,%eax
80106d87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106d8b:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d93:	c7 04 24 ac 8e 10 80 	movl   $0x80108eac,(%esp)
80106d9a:	e8 01 96 ff ff       	call   801003a0 <cprintf>
				tf->eip);
		lapiceoi();
80106d9f:	e8 02 c1 ff ff       	call   80102ea6 <lapiceoi>
		break;
80106da4:	e9 d6 00 00 00       	jmp    80106e7f <trap+0x1fc>

		//PAGEBREAK: 13
	default:
		if (proc == 0 || (tf->cs & 3) == 0) {
80106da9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106daf:	85 c0                	test   %eax,%eax
80106db1:	74 11                	je     80106dc4 <trap+0x141>
80106db3:	8b 45 08             	mov    0x8(%ebp),%eax
80106db6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106dba:	0f b7 c0             	movzwl %ax,%eax
80106dbd:	83 e0 03             	and    $0x3,%eax
80106dc0:	85 c0                	test   %eax,%eax
80106dc2:	75 46                	jne    80106e0a <trap+0x187>
			// In kernel, it must be our mistake.
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dc4:	e8 19 fd ff ff       	call   80106ae2 <rcr2>
80106dc9:	8b 55 08             	mov    0x8(%ebp),%edx
80106dcc:	8b 5a 38             	mov    0x38(%edx),%ebx
					tf->trapno, cpu->id, tf->eip, rcr2());
80106dcf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106dd6:	0f b6 12             	movzbl (%edx),%edx

		//PAGEBREAK: 13
	default:
		if (proc == 0 || (tf->cs & 3) == 0) {
			// In kernel, it must be our mistake.
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dd9:	0f b6 ca             	movzbl %dl,%ecx
80106ddc:	8b 55 08             	mov    0x8(%ebp),%edx
80106ddf:	8b 52 30             	mov    0x30(%edx),%edx
80106de2:	89 44 24 10          	mov    %eax,0x10(%esp)
80106de6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106dea:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106dee:	89 54 24 04          	mov    %edx,0x4(%esp)
80106df2:	c7 04 24 d0 8e 10 80 	movl   $0x80108ed0,(%esp)
80106df9:	e8 a2 95 ff ff       	call   801003a0 <cprintf>
					tf->trapno, cpu->id, tf->eip, rcr2());
			panic("trap");
80106dfe:	c7 04 24 02 8f 10 80 	movl   $0x80108f02,(%esp)
80106e05:	e8 30 97 ff ff       	call   8010053a <panic>
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e0a:	e8 d3 fc ff ff       	call   80106ae2 <rcr2>
80106e0f:	89 c2                	mov    %eax,%edx
80106e11:	8b 45 08             	mov    0x8(%ebp),%eax
80106e14:	8b 78 38             	mov    0x38(%eax),%edi
				"eip 0x%x addr 0x%x--kill proc\n", proc->pid, proc->name,
				tf->trapno, tf->err, cpu->id, tf->eip, rcr2());
80106e17:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e1d:	0f b6 00             	movzbl (%eax),%eax
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
					tf->trapno, cpu->id, tf->eip, rcr2());
			panic("trap");
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e20:	0f b6 f0             	movzbl %al,%esi
80106e23:	8b 45 08             	mov    0x8(%ebp),%eax
80106e26:	8b 58 34             	mov    0x34(%eax),%ebx
80106e29:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2c:	8b 48 30             	mov    0x30(%eax),%ecx
				"eip 0x%x addr 0x%x--kill proc\n", proc->pid, proc->name,
80106e2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e35:	83 c0 6c             	add    $0x6c,%eax
80106e38:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106e3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
					tf->trapno, cpu->id, tf->eip, rcr2());
			panic("trap");
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e41:	8b 40 10             	mov    0x10(%eax),%eax
80106e44:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106e48:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106e4c:	89 74 24 14          	mov    %esi,0x14(%esp)
80106e50:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106e54:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106e58:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80106e5b:	89 74 24 08          	mov    %esi,0x8(%esp)
80106e5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e63:	c7 04 24 08 8f 10 80 	movl   $0x80108f08,(%esp)
80106e6a:	e8 31 95 ff ff       	call   801003a0 <cprintf>
				"eip 0x%x addr 0x%x--kill proc\n", proc->pid, proc->name,
				tf->trapno, tf->err, cpu->id, tf->eip, rcr2());
		proc->killed = 1;
80106e6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e75:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106e7c:	eb 01                	jmp    80106e7f <trap+0x1fc>
		ideintr();
		lapiceoi();
		break;
	case T_IRQ0 + IRQ_IDE + 1:
		// Bochs generates spurious IDE1 interrupts.
		break;
80106e7e:	90                   	nop
	}

	// Force process exit if it has been killed and is in user space.
	// (If it is still executing in the kernel, let it keep running
	// until it gets to the regular system call return.)
	if (proc && proc->killed && (tf->cs & 3) == DPL_USER)
80106e7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e85:	85 c0                	test   %eax,%eax
80106e87:	74 24                	je     80106ead <trap+0x22a>
80106e89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e8f:	8b 40 24             	mov    0x24(%eax),%eax
80106e92:	85 c0                	test   %eax,%eax
80106e94:	74 17                	je     80106ead <trap+0x22a>
80106e96:	8b 45 08             	mov    0x8(%ebp),%eax
80106e99:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e9d:	0f b7 c0             	movzwl %ax,%eax
80106ea0:	83 e0 03             	and    $0x3,%eax
80106ea3:	83 f8 03             	cmp    $0x3,%eax
80106ea6:	75 05                	jne    80106ead <trap+0x22a>
		exit();
80106ea8:	e8 29 d8 ff ff       	call   801046d6 <exit>

	// Force process to give up CPU on clock tick.
	// If interrupts were on while locks held, would need to check nlock.
	if (proc && proc->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER) {
80106ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eb3:	85 c0                	test   %eax,%eax
80106eb5:	74 61                	je     80106f18 <trap+0x295>
80106eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ebd:	8b 40 0c             	mov    0xc(%eax),%eax
80106ec0:	83 f8 04             	cmp    $0x4,%eax
80106ec3:	75 53                	jne    80106f18 <trap+0x295>
80106ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec8:	8b 40 30             	mov    0x30(%eax),%eax
80106ecb:	83 f8 20             	cmp    $0x20,%eax
80106ece:	75 48                	jne    80106f18 <trap+0x295>
		uint shouldYield;
#ifdef FCFS
		shouldYield = 0;
#elif defined (DEFAULT) || defined (FRR) || defined (MC_FRR)
		if (proc->quanta % QUANTA == 0)
80106ed0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ed6:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
80106edc:	ba 67 66 66 66       	mov    $0x66666667,%edx
80106ee1:	89 c8                	mov    %ecx,%eax
80106ee3:	f7 ea                	imul   %edx
80106ee5:	d1 fa                	sar    %edx
80106ee7:	89 c8                	mov    %ecx,%eax
80106ee9:	c1 f8 1f             	sar    $0x1f,%eax
80106eec:	29 c2                	sub    %eax,%edx
80106eee:	89 d0                	mov    %edx,%eax
80106ef0:	c1 e0 02             	shl    $0x2,%eax
80106ef3:	01 d0                	add    %edx,%eax
80106ef5:	29 c1                	sub    %eax,%ecx
80106ef7:	89 ca                	mov    %ecx,%edx
80106ef9:	85 d2                	test   %edx,%edx
80106efb:	75 09                	jne    80106f06 <trap+0x283>
		shouldYield = 1;
80106efd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80106f04:	eb 07                	jmp    80106f0d <trap+0x28a>
		else
		shouldYield = 0;
80106f06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			shouldYield = 1;
			else
			shouldYield = 0;
		}
#endif
		if (shouldYield == 1)
80106f0d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
80106f11:	75 05                	jne    80106f18 <trap+0x295>
			yield();
80106f13:	e8 b0 df ff ff       	call   80104ec8 <yield>
	}

	// Check if the process has been killed since we yielded
	if (proc && proc->killed && (tf->cs & 3) == DPL_USER)
80106f18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f1e:	85 c0                	test   %eax,%eax
80106f20:	74 24                	je     80106f46 <trap+0x2c3>
80106f22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f28:	8b 40 24             	mov    0x24(%eax),%eax
80106f2b:	85 c0                	test   %eax,%eax
80106f2d:	74 17                	je     80106f46 <trap+0x2c3>
80106f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f36:	0f b7 c0             	movzwl %ax,%eax
80106f39:	83 e0 03             	and    $0x3,%eax
80106f3c:	83 f8 03             	cmp    $0x3,%eax
80106f3f:	75 05                	jne    80106f46 <trap+0x2c3>
		exit();
80106f41:	e8 90 d7 ff ff       	call   801046d6 <exit>
}
80106f46:	83 c4 4c             	add    $0x4c,%esp
80106f49:	5b                   	pop    %ebx
80106f4a:	5e                   	pop    %esi
80106f4b:	5f                   	pop    %edi
80106f4c:	5d                   	pop    %ebp
80106f4d:	c3                   	ret    

80106f4e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106f4e:	55                   	push   %ebp
80106f4f:	89 e5                	mov    %esp,%ebp
80106f51:	83 ec 14             	sub    $0x14,%esp
80106f54:	8b 45 08             	mov    0x8(%ebp),%eax
80106f57:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106f5f:	89 c2                	mov    %eax,%edx
80106f61:	ec                   	in     (%dx),%al
80106f62:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106f65:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106f69:	c9                   	leave  
80106f6a:	c3                   	ret    

80106f6b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106f6b:	55                   	push   %ebp
80106f6c:	89 e5                	mov    %esp,%ebp
80106f6e:	83 ec 08             	sub    $0x8,%esp
80106f71:	8b 55 08             	mov    0x8(%ebp),%edx
80106f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f77:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106f7b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f7e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f82:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f86:	ee                   	out    %al,(%dx)
}
80106f87:	c9                   	leave  
80106f88:	c3                   	ret    

80106f89 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106f89:	55                   	push   %ebp
80106f8a:	89 e5                	mov    %esp,%ebp
80106f8c:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106f8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f96:	00 
80106f97:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106f9e:	e8 c8 ff ff ff       	call   80106f6b <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106fa3:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106faa:	00 
80106fab:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106fb2:	e8 b4 ff ff ff       	call   80106f6b <outb>
  outb(COM1+0, 115200/9600);
80106fb7:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106fbe:	00 
80106fbf:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106fc6:	e8 a0 ff ff ff       	call   80106f6b <outb>
  outb(COM1+1, 0);
80106fcb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106fd2:	00 
80106fd3:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106fda:	e8 8c ff ff ff       	call   80106f6b <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106fdf:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106fe6:	00 
80106fe7:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106fee:	e8 78 ff ff ff       	call   80106f6b <outb>
  outb(COM1+4, 0);
80106ff3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ffa:	00 
80106ffb:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107002:	e8 64 ff ff ff       	call   80106f6b <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107007:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010700e:	00 
8010700f:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107016:	e8 50 ff ff ff       	call   80106f6b <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010701b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107022:	e8 27 ff ff ff       	call   80106f4e <inb>
80107027:	3c ff                	cmp    $0xff,%al
80107029:	75 02                	jne    8010702d <uartinit+0xa4>
    return;
8010702b:	eb 6a                	jmp    80107097 <uartinit+0x10e>
  uart = 1;
8010702d:	c7 05 64 c6 10 80 01 	movl   $0x1,0x8010c664
80107034:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107037:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010703e:	e8 0b ff ff ff       	call   80106f4e <inb>
  inb(COM1+0);
80107043:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010704a:	e8 ff fe ff ff       	call   80106f4e <inb>
  picenable(IRQ_COM1);
8010704f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107056:	e8 21 ca ff ff       	call   80103a7c <picenable>
  ioapicenable(IRQ_COM1, 0);
8010705b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107062:	00 
80107063:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010706a:	e8 e1 b8 ff ff       	call   80102950 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010706f:	c7 45 f4 cc 8f 10 80 	movl   $0x80108fcc,-0xc(%ebp)
80107076:	eb 15                	jmp    8010708d <uartinit+0x104>
    uartputc(*p);
80107078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010707b:	0f b6 00             	movzbl (%eax),%eax
8010707e:	0f be c0             	movsbl %al,%eax
80107081:	89 04 24             	mov    %eax,(%esp)
80107084:	e8 10 00 00 00       	call   80107099 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107089:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010708d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107090:	0f b6 00             	movzbl (%eax),%eax
80107093:	84 c0                	test   %al,%al
80107095:	75 e1                	jne    80107078 <uartinit+0xef>
    uartputc(*p);
}
80107097:	c9                   	leave  
80107098:	c3                   	ret    

80107099 <uartputc>:

void
uartputc(int c)
{
80107099:	55                   	push   %ebp
8010709a:	89 e5                	mov    %esp,%ebp
8010709c:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010709f:	a1 64 c6 10 80       	mov    0x8010c664,%eax
801070a4:	85 c0                	test   %eax,%eax
801070a6:	75 02                	jne    801070aa <uartputc+0x11>
    return;
801070a8:	eb 4b                	jmp    801070f5 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801070aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801070b1:	eb 10                	jmp    801070c3 <uartputc+0x2a>
    microdelay(10);
801070b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801070ba:	e8 0c be ff ff       	call   80102ecb <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801070bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801070c3:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801070c7:	7f 16                	jg     801070df <uartputc+0x46>
801070c9:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801070d0:	e8 79 fe ff ff       	call   80106f4e <inb>
801070d5:	0f b6 c0             	movzbl %al,%eax
801070d8:	83 e0 20             	and    $0x20,%eax
801070db:	85 c0                	test   %eax,%eax
801070dd:	74 d4                	je     801070b3 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801070df:	8b 45 08             	mov    0x8(%ebp),%eax
801070e2:	0f b6 c0             	movzbl %al,%eax
801070e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801070e9:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801070f0:	e8 76 fe ff ff       	call   80106f6b <outb>
}
801070f5:	c9                   	leave  
801070f6:	c3                   	ret    

801070f7 <uartgetc>:

static int
uartgetc(void)
{
801070f7:	55                   	push   %ebp
801070f8:	89 e5                	mov    %esp,%ebp
801070fa:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801070fd:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80107102:	85 c0                	test   %eax,%eax
80107104:	75 07                	jne    8010710d <uartgetc+0x16>
    return -1;
80107106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010710b:	eb 2c                	jmp    80107139 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010710d:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107114:	e8 35 fe ff ff       	call   80106f4e <inb>
80107119:	0f b6 c0             	movzbl %al,%eax
8010711c:	83 e0 01             	and    $0x1,%eax
8010711f:	85 c0                	test   %eax,%eax
80107121:	75 07                	jne    8010712a <uartgetc+0x33>
    return -1;
80107123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107128:	eb 0f                	jmp    80107139 <uartgetc+0x42>
  return inb(COM1+0);
8010712a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107131:	e8 18 fe ff ff       	call   80106f4e <inb>
80107136:	0f b6 c0             	movzbl %al,%eax
}
80107139:	c9                   	leave  
8010713a:	c3                   	ret    

8010713b <uartintr>:

void
uartintr(void)
{
8010713b:	55                   	push   %ebp
8010713c:	89 e5                	mov    %esp,%ebp
8010713e:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107141:	c7 04 24 f7 70 10 80 	movl   $0x801070f7,(%esp)
80107148:	e8 60 96 ff ff       	call   801007ad <consoleintr>
}
8010714d:	c9                   	leave  
8010714e:	c3                   	ret    

8010714f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $0
80107151:	6a 00                	push   $0x0
  jmp alltraps
80107153:	e9 36 f9 ff ff       	jmp    80106a8e <alltraps>

80107158 <vector1>:
.globl vector1
vector1:
  pushl $0
80107158:	6a 00                	push   $0x0
  pushl $1
8010715a:	6a 01                	push   $0x1
  jmp alltraps
8010715c:	e9 2d f9 ff ff       	jmp    80106a8e <alltraps>

80107161 <vector2>:
.globl vector2
vector2:
  pushl $0
80107161:	6a 00                	push   $0x0
  pushl $2
80107163:	6a 02                	push   $0x2
  jmp alltraps
80107165:	e9 24 f9 ff ff       	jmp    80106a8e <alltraps>

8010716a <vector3>:
.globl vector3
vector3:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $3
8010716c:	6a 03                	push   $0x3
  jmp alltraps
8010716e:	e9 1b f9 ff ff       	jmp    80106a8e <alltraps>

80107173 <vector4>:
.globl vector4
vector4:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $4
80107175:	6a 04                	push   $0x4
  jmp alltraps
80107177:	e9 12 f9 ff ff       	jmp    80106a8e <alltraps>

8010717c <vector5>:
.globl vector5
vector5:
  pushl $0
8010717c:	6a 00                	push   $0x0
  pushl $5
8010717e:	6a 05                	push   $0x5
  jmp alltraps
80107180:	e9 09 f9 ff ff       	jmp    80106a8e <alltraps>

80107185 <vector6>:
.globl vector6
vector6:
  pushl $0
80107185:	6a 00                	push   $0x0
  pushl $6
80107187:	6a 06                	push   $0x6
  jmp alltraps
80107189:	e9 00 f9 ff ff       	jmp    80106a8e <alltraps>

8010718e <vector7>:
.globl vector7
vector7:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $7
80107190:	6a 07                	push   $0x7
  jmp alltraps
80107192:	e9 f7 f8 ff ff       	jmp    80106a8e <alltraps>

80107197 <vector8>:
.globl vector8
vector8:
  pushl $8
80107197:	6a 08                	push   $0x8
  jmp alltraps
80107199:	e9 f0 f8 ff ff       	jmp    80106a8e <alltraps>

8010719e <vector9>:
.globl vector9
vector9:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $9
801071a0:	6a 09                	push   $0x9
  jmp alltraps
801071a2:	e9 e7 f8 ff ff       	jmp    80106a8e <alltraps>

801071a7 <vector10>:
.globl vector10
vector10:
  pushl $10
801071a7:	6a 0a                	push   $0xa
  jmp alltraps
801071a9:	e9 e0 f8 ff ff       	jmp    80106a8e <alltraps>

801071ae <vector11>:
.globl vector11
vector11:
  pushl $11
801071ae:	6a 0b                	push   $0xb
  jmp alltraps
801071b0:	e9 d9 f8 ff ff       	jmp    80106a8e <alltraps>

801071b5 <vector12>:
.globl vector12
vector12:
  pushl $12
801071b5:	6a 0c                	push   $0xc
  jmp alltraps
801071b7:	e9 d2 f8 ff ff       	jmp    80106a8e <alltraps>

801071bc <vector13>:
.globl vector13
vector13:
  pushl $13
801071bc:	6a 0d                	push   $0xd
  jmp alltraps
801071be:	e9 cb f8 ff ff       	jmp    80106a8e <alltraps>

801071c3 <vector14>:
.globl vector14
vector14:
  pushl $14
801071c3:	6a 0e                	push   $0xe
  jmp alltraps
801071c5:	e9 c4 f8 ff ff       	jmp    80106a8e <alltraps>

801071ca <vector15>:
.globl vector15
vector15:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $15
801071cc:	6a 0f                	push   $0xf
  jmp alltraps
801071ce:	e9 bb f8 ff ff       	jmp    80106a8e <alltraps>

801071d3 <vector16>:
.globl vector16
vector16:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $16
801071d5:	6a 10                	push   $0x10
  jmp alltraps
801071d7:	e9 b2 f8 ff ff       	jmp    80106a8e <alltraps>

801071dc <vector17>:
.globl vector17
vector17:
  pushl $17
801071dc:	6a 11                	push   $0x11
  jmp alltraps
801071de:	e9 ab f8 ff ff       	jmp    80106a8e <alltraps>

801071e3 <vector18>:
.globl vector18
vector18:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $18
801071e5:	6a 12                	push   $0x12
  jmp alltraps
801071e7:	e9 a2 f8 ff ff       	jmp    80106a8e <alltraps>

801071ec <vector19>:
.globl vector19
vector19:
  pushl $0
801071ec:	6a 00                	push   $0x0
  pushl $19
801071ee:	6a 13                	push   $0x13
  jmp alltraps
801071f0:	e9 99 f8 ff ff       	jmp    80106a8e <alltraps>

801071f5 <vector20>:
.globl vector20
vector20:
  pushl $0
801071f5:	6a 00                	push   $0x0
  pushl $20
801071f7:	6a 14                	push   $0x14
  jmp alltraps
801071f9:	e9 90 f8 ff ff       	jmp    80106a8e <alltraps>

801071fe <vector21>:
.globl vector21
vector21:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $21
80107200:	6a 15                	push   $0x15
  jmp alltraps
80107202:	e9 87 f8 ff ff       	jmp    80106a8e <alltraps>

80107207 <vector22>:
.globl vector22
vector22:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $22
80107209:	6a 16                	push   $0x16
  jmp alltraps
8010720b:	e9 7e f8 ff ff       	jmp    80106a8e <alltraps>

80107210 <vector23>:
.globl vector23
vector23:
  pushl $0
80107210:	6a 00                	push   $0x0
  pushl $23
80107212:	6a 17                	push   $0x17
  jmp alltraps
80107214:	e9 75 f8 ff ff       	jmp    80106a8e <alltraps>

80107219 <vector24>:
.globl vector24
vector24:
  pushl $0
80107219:	6a 00                	push   $0x0
  pushl $24
8010721b:	6a 18                	push   $0x18
  jmp alltraps
8010721d:	e9 6c f8 ff ff       	jmp    80106a8e <alltraps>

80107222 <vector25>:
.globl vector25
vector25:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $25
80107224:	6a 19                	push   $0x19
  jmp alltraps
80107226:	e9 63 f8 ff ff       	jmp    80106a8e <alltraps>

8010722b <vector26>:
.globl vector26
vector26:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $26
8010722d:	6a 1a                	push   $0x1a
  jmp alltraps
8010722f:	e9 5a f8 ff ff       	jmp    80106a8e <alltraps>

80107234 <vector27>:
.globl vector27
vector27:
  pushl $0
80107234:	6a 00                	push   $0x0
  pushl $27
80107236:	6a 1b                	push   $0x1b
  jmp alltraps
80107238:	e9 51 f8 ff ff       	jmp    80106a8e <alltraps>

8010723d <vector28>:
.globl vector28
vector28:
  pushl $0
8010723d:	6a 00                	push   $0x0
  pushl $28
8010723f:	6a 1c                	push   $0x1c
  jmp alltraps
80107241:	e9 48 f8 ff ff       	jmp    80106a8e <alltraps>

80107246 <vector29>:
.globl vector29
vector29:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $29
80107248:	6a 1d                	push   $0x1d
  jmp alltraps
8010724a:	e9 3f f8 ff ff       	jmp    80106a8e <alltraps>

8010724f <vector30>:
.globl vector30
vector30:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $30
80107251:	6a 1e                	push   $0x1e
  jmp alltraps
80107253:	e9 36 f8 ff ff       	jmp    80106a8e <alltraps>

80107258 <vector31>:
.globl vector31
vector31:
  pushl $0
80107258:	6a 00                	push   $0x0
  pushl $31
8010725a:	6a 1f                	push   $0x1f
  jmp alltraps
8010725c:	e9 2d f8 ff ff       	jmp    80106a8e <alltraps>

80107261 <vector32>:
.globl vector32
vector32:
  pushl $0
80107261:	6a 00                	push   $0x0
  pushl $32
80107263:	6a 20                	push   $0x20
  jmp alltraps
80107265:	e9 24 f8 ff ff       	jmp    80106a8e <alltraps>

8010726a <vector33>:
.globl vector33
vector33:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $33
8010726c:	6a 21                	push   $0x21
  jmp alltraps
8010726e:	e9 1b f8 ff ff       	jmp    80106a8e <alltraps>

80107273 <vector34>:
.globl vector34
vector34:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $34
80107275:	6a 22                	push   $0x22
  jmp alltraps
80107277:	e9 12 f8 ff ff       	jmp    80106a8e <alltraps>

8010727c <vector35>:
.globl vector35
vector35:
  pushl $0
8010727c:	6a 00                	push   $0x0
  pushl $35
8010727e:	6a 23                	push   $0x23
  jmp alltraps
80107280:	e9 09 f8 ff ff       	jmp    80106a8e <alltraps>

80107285 <vector36>:
.globl vector36
vector36:
  pushl $0
80107285:	6a 00                	push   $0x0
  pushl $36
80107287:	6a 24                	push   $0x24
  jmp alltraps
80107289:	e9 00 f8 ff ff       	jmp    80106a8e <alltraps>

8010728e <vector37>:
.globl vector37
vector37:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $37
80107290:	6a 25                	push   $0x25
  jmp alltraps
80107292:	e9 f7 f7 ff ff       	jmp    80106a8e <alltraps>

80107297 <vector38>:
.globl vector38
vector38:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $38
80107299:	6a 26                	push   $0x26
  jmp alltraps
8010729b:	e9 ee f7 ff ff       	jmp    80106a8e <alltraps>

801072a0 <vector39>:
.globl vector39
vector39:
  pushl $0
801072a0:	6a 00                	push   $0x0
  pushl $39
801072a2:	6a 27                	push   $0x27
  jmp alltraps
801072a4:	e9 e5 f7 ff ff       	jmp    80106a8e <alltraps>

801072a9 <vector40>:
.globl vector40
vector40:
  pushl $0
801072a9:	6a 00                	push   $0x0
  pushl $40
801072ab:	6a 28                	push   $0x28
  jmp alltraps
801072ad:	e9 dc f7 ff ff       	jmp    80106a8e <alltraps>

801072b2 <vector41>:
.globl vector41
vector41:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $41
801072b4:	6a 29                	push   $0x29
  jmp alltraps
801072b6:	e9 d3 f7 ff ff       	jmp    80106a8e <alltraps>

801072bb <vector42>:
.globl vector42
vector42:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $42
801072bd:	6a 2a                	push   $0x2a
  jmp alltraps
801072bf:	e9 ca f7 ff ff       	jmp    80106a8e <alltraps>

801072c4 <vector43>:
.globl vector43
vector43:
  pushl $0
801072c4:	6a 00                	push   $0x0
  pushl $43
801072c6:	6a 2b                	push   $0x2b
  jmp alltraps
801072c8:	e9 c1 f7 ff ff       	jmp    80106a8e <alltraps>

801072cd <vector44>:
.globl vector44
vector44:
  pushl $0
801072cd:	6a 00                	push   $0x0
  pushl $44
801072cf:	6a 2c                	push   $0x2c
  jmp alltraps
801072d1:	e9 b8 f7 ff ff       	jmp    80106a8e <alltraps>

801072d6 <vector45>:
.globl vector45
vector45:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $45
801072d8:	6a 2d                	push   $0x2d
  jmp alltraps
801072da:	e9 af f7 ff ff       	jmp    80106a8e <alltraps>

801072df <vector46>:
.globl vector46
vector46:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $46
801072e1:	6a 2e                	push   $0x2e
  jmp alltraps
801072e3:	e9 a6 f7 ff ff       	jmp    80106a8e <alltraps>

801072e8 <vector47>:
.globl vector47
vector47:
  pushl $0
801072e8:	6a 00                	push   $0x0
  pushl $47
801072ea:	6a 2f                	push   $0x2f
  jmp alltraps
801072ec:	e9 9d f7 ff ff       	jmp    80106a8e <alltraps>

801072f1 <vector48>:
.globl vector48
vector48:
  pushl $0
801072f1:	6a 00                	push   $0x0
  pushl $48
801072f3:	6a 30                	push   $0x30
  jmp alltraps
801072f5:	e9 94 f7 ff ff       	jmp    80106a8e <alltraps>

801072fa <vector49>:
.globl vector49
vector49:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $49
801072fc:	6a 31                	push   $0x31
  jmp alltraps
801072fe:	e9 8b f7 ff ff       	jmp    80106a8e <alltraps>

80107303 <vector50>:
.globl vector50
vector50:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $50
80107305:	6a 32                	push   $0x32
  jmp alltraps
80107307:	e9 82 f7 ff ff       	jmp    80106a8e <alltraps>

8010730c <vector51>:
.globl vector51
vector51:
  pushl $0
8010730c:	6a 00                	push   $0x0
  pushl $51
8010730e:	6a 33                	push   $0x33
  jmp alltraps
80107310:	e9 79 f7 ff ff       	jmp    80106a8e <alltraps>

80107315 <vector52>:
.globl vector52
vector52:
  pushl $0
80107315:	6a 00                	push   $0x0
  pushl $52
80107317:	6a 34                	push   $0x34
  jmp alltraps
80107319:	e9 70 f7 ff ff       	jmp    80106a8e <alltraps>

8010731e <vector53>:
.globl vector53
vector53:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $53
80107320:	6a 35                	push   $0x35
  jmp alltraps
80107322:	e9 67 f7 ff ff       	jmp    80106a8e <alltraps>

80107327 <vector54>:
.globl vector54
vector54:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $54
80107329:	6a 36                	push   $0x36
  jmp alltraps
8010732b:	e9 5e f7 ff ff       	jmp    80106a8e <alltraps>

80107330 <vector55>:
.globl vector55
vector55:
  pushl $0
80107330:	6a 00                	push   $0x0
  pushl $55
80107332:	6a 37                	push   $0x37
  jmp alltraps
80107334:	e9 55 f7 ff ff       	jmp    80106a8e <alltraps>

80107339 <vector56>:
.globl vector56
vector56:
  pushl $0
80107339:	6a 00                	push   $0x0
  pushl $56
8010733b:	6a 38                	push   $0x38
  jmp alltraps
8010733d:	e9 4c f7 ff ff       	jmp    80106a8e <alltraps>

80107342 <vector57>:
.globl vector57
vector57:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $57
80107344:	6a 39                	push   $0x39
  jmp alltraps
80107346:	e9 43 f7 ff ff       	jmp    80106a8e <alltraps>

8010734b <vector58>:
.globl vector58
vector58:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $58
8010734d:	6a 3a                	push   $0x3a
  jmp alltraps
8010734f:	e9 3a f7 ff ff       	jmp    80106a8e <alltraps>

80107354 <vector59>:
.globl vector59
vector59:
  pushl $0
80107354:	6a 00                	push   $0x0
  pushl $59
80107356:	6a 3b                	push   $0x3b
  jmp alltraps
80107358:	e9 31 f7 ff ff       	jmp    80106a8e <alltraps>

8010735d <vector60>:
.globl vector60
vector60:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $60
8010735f:	6a 3c                	push   $0x3c
  jmp alltraps
80107361:	e9 28 f7 ff ff       	jmp    80106a8e <alltraps>

80107366 <vector61>:
.globl vector61
vector61:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $61
80107368:	6a 3d                	push   $0x3d
  jmp alltraps
8010736a:	e9 1f f7 ff ff       	jmp    80106a8e <alltraps>

8010736f <vector62>:
.globl vector62
vector62:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $62
80107371:	6a 3e                	push   $0x3e
  jmp alltraps
80107373:	e9 16 f7 ff ff       	jmp    80106a8e <alltraps>

80107378 <vector63>:
.globl vector63
vector63:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $63
8010737a:	6a 3f                	push   $0x3f
  jmp alltraps
8010737c:	e9 0d f7 ff ff       	jmp    80106a8e <alltraps>

80107381 <vector64>:
.globl vector64
vector64:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $64
80107383:	6a 40                	push   $0x40
  jmp alltraps
80107385:	e9 04 f7 ff ff       	jmp    80106a8e <alltraps>

8010738a <vector65>:
.globl vector65
vector65:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $65
8010738c:	6a 41                	push   $0x41
  jmp alltraps
8010738e:	e9 fb f6 ff ff       	jmp    80106a8e <alltraps>

80107393 <vector66>:
.globl vector66
vector66:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $66
80107395:	6a 42                	push   $0x42
  jmp alltraps
80107397:	e9 f2 f6 ff ff       	jmp    80106a8e <alltraps>

8010739c <vector67>:
.globl vector67
vector67:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $67
8010739e:	6a 43                	push   $0x43
  jmp alltraps
801073a0:	e9 e9 f6 ff ff       	jmp    80106a8e <alltraps>

801073a5 <vector68>:
.globl vector68
vector68:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $68
801073a7:	6a 44                	push   $0x44
  jmp alltraps
801073a9:	e9 e0 f6 ff ff       	jmp    80106a8e <alltraps>

801073ae <vector69>:
.globl vector69
vector69:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $69
801073b0:	6a 45                	push   $0x45
  jmp alltraps
801073b2:	e9 d7 f6 ff ff       	jmp    80106a8e <alltraps>

801073b7 <vector70>:
.globl vector70
vector70:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $70
801073b9:	6a 46                	push   $0x46
  jmp alltraps
801073bb:	e9 ce f6 ff ff       	jmp    80106a8e <alltraps>

801073c0 <vector71>:
.globl vector71
vector71:
  pushl $0
801073c0:	6a 00                	push   $0x0
  pushl $71
801073c2:	6a 47                	push   $0x47
  jmp alltraps
801073c4:	e9 c5 f6 ff ff       	jmp    80106a8e <alltraps>

801073c9 <vector72>:
.globl vector72
vector72:
  pushl $0
801073c9:	6a 00                	push   $0x0
  pushl $72
801073cb:	6a 48                	push   $0x48
  jmp alltraps
801073cd:	e9 bc f6 ff ff       	jmp    80106a8e <alltraps>

801073d2 <vector73>:
.globl vector73
vector73:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $73
801073d4:	6a 49                	push   $0x49
  jmp alltraps
801073d6:	e9 b3 f6 ff ff       	jmp    80106a8e <alltraps>

801073db <vector74>:
.globl vector74
vector74:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $74
801073dd:	6a 4a                	push   $0x4a
  jmp alltraps
801073df:	e9 aa f6 ff ff       	jmp    80106a8e <alltraps>

801073e4 <vector75>:
.globl vector75
vector75:
  pushl $0
801073e4:	6a 00                	push   $0x0
  pushl $75
801073e6:	6a 4b                	push   $0x4b
  jmp alltraps
801073e8:	e9 a1 f6 ff ff       	jmp    80106a8e <alltraps>

801073ed <vector76>:
.globl vector76
vector76:
  pushl $0
801073ed:	6a 00                	push   $0x0
  pushl $76
801073ef:	6a 4c                	push   $0x4c
  jmp alltraps
801073f1:	e9 98 f6 ff ff       	jmp    80106a8e <alltraps>

801073f6 <vector77>:
.globl vector77
vector77:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $77
801073f8:	6a 4d                	push   $0x4d
  jmp alltraps
801073fa:	e9 8f f6 ff ff       	jmp    80106a8e <alltraps>

801073ff <vector78>:
.globl vector78
vector78:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $78
80107401:	6a 4e                	push   $0x4e
  jmp alltraps
80107403:	e9 86 f6 ff ff       	jmp    80106a8e <alltraps>

80107408 <vector79>:
.globl vector79
vector79:
  pushl $0
80107408:	6a 00                	push   $0x0
  pushl $79
8010740a:	6a 4f                	push   $0x4f
  jmp alltraps
8010740c:	e9 7d f6 ff ff       	jmp    80106a8e <alltraps>

80107411 <vector80>:
.globl vector80
vector80:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $80
80107413:	6a 50                	push   $0x50
  jmp alltraps
80107415:	e9 74 f6 ff ff       	jmp    80106a8e <alltraps>

8010741a <vector81>:
.globl vector81
vector81:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $81
8010741c:	6a 51                	push   $0x51
  jmp alltraps
8010741e:	e9 6b f6 ff ff       	jmp    80106a8e <alltraps>

80107423 <vector82>:
.globl vector82
vector82:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $82
80107425:	6a 52                	push   $0x52
  jmp alltraps
80107427:	e9 62 f6 ff ff       	jmp    80106a8e <alltraps>

8010742c <vector83>:
.globl vector83
vector83:
  pushl $0
8010742c:	6a 00                	push   $0x0
  pushl $83
8010742e:	6a 53                	push   $0x53
  jmp alltraps
80107430:	e9 59 f6 ff ff       	jmp    80106a8e <alltraps>

80107435 <vector84>:
.globl vector84
vector84:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $84
80107437:	6a 54                	push   $0x54
  jmp alltraps
80107439:	e9 50 f6 ff ff       	jmp    80106a8e <alltraps>

8010743e <vector85>:
.globl vector85
vector85:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $85
80107440:	6a 55                	push   $0x55
  jmp alltraps
80107442:	e9 47 f6 ff ff       	jmp    80106a8e <alltraps>

80107447 <vector86>:
.globl vector86
vector86:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $86
80107449:	6a 56                	push   $0x56
  jmp alltraps
8010744b:	e9 3e f6 ff ff       	jmp    80106a8e <alltraps>

80107450 <vector87>:
.globl vector87
vector87:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $87
80107452:	6a 57                	push   $0x57
  jmp alltraps
80107454:	e9 35 f6 ff ff       	jmp    80106a8e <alltraps>

80107459 <vector88>:
.globl vector88
vector88:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $88
8010745b:	6a 58                	push   $0x58
  jmp alltraps
8010745d:	e9 2c f6 ff ff       	jmp    80106a8e <alltraps>

80107462 <vector89>:
.globl vector89
vector89:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $89
80107464:	6a 59                	push   $0x59
  jmp alltraps
80107466:	e9 23 f6 ff ff       	jmp    80106a8e <alltraps>

8010746b <vector90>:
.globl vector90
vector90:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $90
8010746d:	6a 5a                	push   $0x5a
  jmp alltraps
8010746f:	e9 1a f6 ff ff       	jmp    80106a8e <alltraps>

80107474 <vector91>:
.globl vector91
vector91:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $91
80107476:	6a 5b                	push   $0x5b
  jmp alltraps
80107478:	e9 11 f6 ff ff       	jmp    80106a8e <alltraps>

8010747d <vector92>:
.globl vector92
vector92:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $92
8010747f:	6a 5c                	push   $0x5c
  jmp alltraps
80107481:	e9 08 f6 ff ff       	jmp    80106a8e <alltraps>

80107486 <vector93>:
.globl vector93
vector93:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $93
80107488:	6a 5d                	push   $0x5d
  jmp alltraps
8010748a:	e9 ff f5 ff ff       	jmp    80106a8e <alltraps>

8010748f <vector94>:
.globl vector94
vector94:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $94
80107491:	6a 5e                	push   $0x5e
  jmp alltraps
80107493:	e9 f6 f5 ff ff       	jmp    80106a8e <alltraps>

80107498 <vector95>:
.globl vector95
vector95:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $95
8010749a:	6a 5f                	push   $0x5f
  jmp alltraps
8010749c:	e9 ed f5 ff ff       	jmp    80106a8e <alltraps>

801074a1 <vector96>:
.globl vector96
vector96:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $96
801074a3:	6a 60                	push   $0x60
  jmp alltraps
801074a5:	e9 e4 f5 ff ff       	jmp    80106a8e <alltraps>

801074aa <vector97>:
.globl vector97
vector97:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $97
801074ac:	6a 61                	push   $0x61
  jmp alltraps
801074ae:	e9 db f5 ff ff       	jmp    80106a8e <alltraps>

801074b3 <vector98>:
.globl vector98
vector98:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $98
801074b5:	6a 62                	push   $0x62
  jmp alltraps
801074b7:	e9 d2 f5 ff ff       	jmp    80106a8e <alltraps>

801074bc <vector99>:
.globl vector99
vector99:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $99
801074be:	6a 63                	push   $0x63
  jmp alltraps
801074c0:	e9 c9 f5 ff ff       	jmp    80106a8e <alltraps>

801074c5 <vector100>:
.globl vector100
vector100:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $100
801074c7:	6a 64                	push   $0x64
  jmp alltraps
801074c9:	e9 c0 f5 ff ff       	jmp    80106a8e <alltraps>

801074ce <vector101>:
.globl vector101
vector101:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $101
801074d0:	6a 65                	push   $0x65
  jmp alltraps
801074d2:	e9 b7 f5 ff ff       	jmp    80106a8e <alltraps>

801074d7 <vector102>:
.globl vector102
vector102:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $102
801074d9:	6a 66                	push   $0x66
  jmp alltraps
801074db:	e9 ae f5 ff ff       	jmp    80106a8e <alltraps>

801074e0 <vector103>:
.globl vector103
vector103:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $103
801074e2:	6a 67                	push   $0x67
  jmp alltraps
801074e4:	e9 a5 f5 ff ff       	jmp    80106a8e <alltraps>

801074e9 <vector104>:
.globl vector104
vector104:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $104
801074eb:	6a 68                	push   $0x68
  jmp alltraps
801074ed:	e9 9c f5 ff ff       	jmp    80106a8e <alltraps>

801074f2 <vector105>:
.globl vector105
vector105:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $105
801074f4:	6a 69                	push   $0x69
  jmp alltraps
801074f6:	e9 93 f5 ff ff       	jmp    80106a8e <alltraps>

801074fb <vector106>:
.globl vector106
vector106:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $106
801074fd:	6a 6a                	push   $0x6a
  jmp alltraps
801074ff:	e9 8a f5 ff ff       	jmp    80106a8e <alltraps>

80107504 <vector107>:
.globl vector107
vector107:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $107
80107506:	6a 6b                	push   $0x6b
  jmp alltraps
80107508:	e9 81 f5 ff ff       	jmp    80106a8e <alltraps>

8010750d <vector108>:
.globl vector108
vector108:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $108
8010750f:	6a 6c                	push   $0x6c
  jmp alltraps
80107511:	e9 78 f5 ff ff       	jmp    80106a8e <alltraps>

80107516 <vector109>:
.globl vector109
vector109:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $109
80107518:	6a 6d                	push   $0x6d
  jmp alltraps
8010751a:	e9 6f f5 ff ff       	jmp    80106a8e <alltraps>

8010751f <vector110>:
.globl vector110
vector110:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $110
80107521:	6a 6e                	push   $0x6e
  jmp alltraps
80107523:	e9 66 f5 ff ff       	jmp    80106a8e <alltraps>

80107528 <vector111>:
.globl vector111
vector111:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $111
8010752a:	6a 6f                	push   $0x6f
  jmp alltraps
8010752c:	e9 5d f5 ff ff       	jmp    80106a8e <alltraps>

80107531 <vector112>:
.globl vector112
vector112:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $112
80107533:	6a 70                	push   $0x70
  jmp alltraps
80107535:	e9 54 f5 ff ff       	jmp    80106a8e <alltraps>

8010753a <vector113>:
.globl vector113
vector113:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $113
8010753c:	6a 71                	push   $0x71
  jmp alltraps
8010753e:	e9 4b f5 ff ff       	jmp    80106a8e <alltraps>

80107543 <vector114>:
.globl vector114
vector114:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $114
80107545:	6a 72                	push   $0x72
  jmp alltraps
80107547:	e9 42 f5 ff ff       	jmp    80106a8e <alltraps>

8010754c <vector115>:
.globl vector115
vector115:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $115
8010754e:	6a 73                	push   $0x73
  jmp alltraps
80107550:	e9 39 f5 ff ff       	jmp    80106a8e <alltraps>

80107555 <vector116>:
.globl vector116
vector116:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $116
80107557:	6a 74                	push   $0x74
  jmp alltraps
80107559:	e9 30 f5 ff ff       	jmp    80106a8e <alltraps>

8010755e <vector117>:
.globl vector117
vector117:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $117
80107560:	6a 75                	push   $0x75
  jmp alltraps
80107562:	e9 27 f5 ff ff       	jmp    80106a8e <alltraps>

80107567 <vector118>:
.globl vector118
vector118:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $118
80107569:	6a 76                	push   $0x76
  jmp alltraps
8010756b:	e9 1e f5 ff ff       	jmp    80106a8e <alltraps>

80107570 <vector119>:
.globl vector119
vector119:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $119
80107572:	6a 77                	push   $0x77
  jmp alltraps
80107574:	e9 15 f5 ff ff       	jmp    80106a8e <alltraps>

80107579 <vector120>:
.globl vector120
vector120:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $120
8010757b:	6a 78                	push   $0x78
  jmp alltraps
8010757d:	e9 0c f5 ff ff       	jmp    80106a8e <alltraps>

80107582 <vector121>:
.globl vector121
vector121:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $121
80107584:	6a 79                	push   $0x79
  jmp alltraps
80107586:	e9 03 f5 ff ff       	jmp    80106a8e <alltraps>

8010758b <vector122>:
.globl vector122
vector122:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $122
8010758d:	6a 7a                	push   $0x7a
  jmp alltraps
8010758f:	e9 fa f4 ff ff       	jmp    80106a8e <alltraps>

80107594 <vector123>:
.globl vector123
vector123:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $123
80107596:	6a 7b                	push   $0x7b
  jmp alltraps
80107598:	e9 f1 f4 ff ff       	jmp    80106a8e <alltraps>

8010759d <vector124>:
.globl vector124
vector124:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $124
8010759f:	6a 7c                	push   $0x7c
  jmp alltraps
801075a1:	e9 e8 f4 ff ff       	jmp    80106a8e <alltraps>

801075a6 <vector125>:
.globl vector125
vector125:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $125
801075a8:	6a 7d                	push   $0x7d
  jmp alltraps
801075aa:	e9 df f4 ff ff       	jmp    80106a8e <alltraps>

801075af <vector126>:
.globl vector126
vector126:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $126
801075b1:	6a 7e                	push   $0x7e
  jmp alltraps
801075b3:	e9 d6 f4 ff ff       	jmp    80106a8e <alltraps>

801075b8 <vector127>:
.globl vector127
vector127:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $127
801075ba:	6a 7f                	push   $0x7f
  jmp alltraps
801075bc:	e9 cd f4 ff ff       	jmp    80106a8e <alltraps>

801075c1 <vector128>:
.globl vector128
vector128:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $128
801075c3:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801075c8:	e9 c1 f4 ff ff       	jmp    80106a8e <alltraps>

801075cd <vector129>:
.globl vector129
vector129:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $129
801075cf:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801075d4:	e9 b5 f4 ff ff       	jmp    80106a8e <alltraps>

801075d9 <vector130>:
.globl vector130
vector130:
  pushl $0
801075d9:	6a 00                	push   $0x0
  pushl $130
801075db:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801075e0:	e9 a9 f4 ff ff       	jmp    80106a8e <alltraps>

801075e5 <vector131>:
.globl vector131
vector131:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $131
801075e7:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801075ec:	e9 9d f4 ff ff       	jmp    80106a8e <alltraps>

801075f1 <vector132>:
.globl vector132
vector132:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $132
801075f3:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801075f8:	e9 91 f4 ff ff       	jmp    80106a8e <alltraps>

801075fd <vector133>:
.globl vector133
vector133:
  pushl $0
801075fd:	6a 00                	push   $0x0
  pushl $133
801075ff:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107604:	e9 85 f4 ff ff       	jmp    80106a8e <alltraps>

80107609 <vector134>:
.globl vector134
vector134:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $134
8010760b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107610:	e9 79 f4 ff ff       	jmp    80106a8e <alltraps>

80107615 <vector135>:
.globl vector135
vector135:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $135
80107617:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010761c:	e9 6d f4 ff ff       	jmp    80106a8e <alltraps>

80107621 <vector136>:
.globl vector136
vector136:
  pushl $0
80107621:	6a 00                	push   $0x0
  pushl $136
80107623:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107628:	e9 61 f4 ff ff       	jmp    80106a8e <alltraps>

8010762d <vector137>:
.globl vector137
vector137:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $137
8010762f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107634:	e9 55 f4 ff ff       	jmp    80106a8e <alltraps>

80107639 <vector138>:
.globl vector138
vector138:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $138
8010763b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107640:	e9 49 f4 ff ff       	jmp    80106a8e <alltraps>

80107645 <vector139>:
.globl vector139
vector139:
  pushl $0
80107645:	6a 00                	push   $0x0
  pushl $139
80107647:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010764c:	e9 3d f4 ff ff       	jmp    80106a8e <alltraps>

80107651 <vector140>:
.globl vector140
vector140:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $140
80107653:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107658:	e9 31 f4 ff ff       	jmp    80106a8e <alltraps>

8010765d <vector141>:
.globl vector141
vector141:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $141
8010765f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107664:	e9 25 f4 ff ff       	jmp    80106a8e <alltraps>

80107669 <vector142>:
.globl vector142
vector142:
  pushl $0
80107669:	6a 00                	push   $0x0
  pushl $142
8010766b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107670:	e9 19 f4 ff ff       	jmp    80106a8e <alltraps>

80107675 <vector143>:
.globl vector143
vector143:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $143
80107677:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010767c:	e9 0d f4 ff ff       	jmp    80106a8e <alltraps>

80107681 <vector144>:
.globl vector144
vector144:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $144
80107683:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107688:	e9 01 f4 ff ff       	jmp    80106a8e <alltraps>

8010768d <vector145>:
.globl vector145
vector145:
  pushl $0
8010768d:	6a 00                	push   $0x0
  pushl $145
8010768f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107694:	e9 f5 f3 ff ff       	jmp    80106a8e <alltraps>

80107699 <vector146>:
.globl vector146
vector146:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $146
8010769b:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801076a0:	e9 e9 f3 ff ff       	jmp    80106a8e <alltraps>

801076a5 <vector147>:
.globl vector147
vector147:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $147
801076a7:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801076ac:	e9 dd f3 ff ff       	jmp    80106a8e <alltraps>

801076b1 <vector148>:
.globl vector148
vector148:
  pushl $0
801076b1:	6a 00                	push   $0x0
  pushl $148
801076b3:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801076b8:	e9 d1 f3 ff ff       	jmp    80106a8e <alltraps>

801076bd <vector149>:
.globl vector149
vector149:
  pushl $0
801076bd:	6a 00                	push   $0x0
  pushl $149
801076bf:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801076c4:	e9 c5 f3 ff ff       	jmp    80106a8e <alltraps>

801076c9 <vector150>:
.globl vector150
vector150:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $150
801076cb:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801076d0:	e9 b9 f3 ff ff       	jmp    80106a8e <alltraps>

801076d5 <vector151>:
.globl vector151
vector151:
  pushl $0
801076d5:	6a 00                	push   $0x0
  pushl $151
801076d7:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801076dc:	e9 ad f3 ff ff       	jmp    80106a8e <alltraps>

801076e1 <vector152>:
.globl vector152
vector152:
  pushl $0
801076e1:	6a 00                	push   $0x0
  pushl $152
801076e3:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801076e8:	e9 a1 f3 ff ff       	jmp    80106a8e <alltraps>

801076ed <vector153>:
.globl vector153
vector153:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $153
801076ef:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801076f4:	e9 95 f3 ff ff       	jmp    80106a8e <alltraps>

801076f9 <vector154>:
.globl vector154
vector154:
  pushl $0
801076f9:	6a 00                	push   $0x0
  pushl $154
801076fb:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107700:	e9 89 f3 ff ff       	jmp    80106a8e <alltraps>

80107705 <vector155>:
.globl vector155
vector155:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $155
80107707:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010770c:	e9 7d f3 ff ff       	jmp    80106a8e <alltraps>

80107711 <vector156>:
.globl vector156
vector156:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $156
80107713:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107718:	e9 71 f3 ff ff       	jmp    80106a8e <alltraps>

8010771d <vector157>:
.globl vector157
vector157:
  pushl $0
8010771d:	6a 00                	push   $0x0
  pushl $157
8010771f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107724:	e9 65 f3 ff ff       	jmp    80106a8e <alltraps>

80107729 <vector158>:
.globl vector158
vector158:
  pushl $0
80107729:	6a 00                	push   $0x0
  pushl $158
8010772b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107730:	e9 59 f3 ff ff       	jmp    80106a8e <alltraps>

80107735 <vector159>:
.globl vector159
vector159:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $159
80107737:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010773c:	e9 4d f3 ff ff       	jmp    80106a8e <alltraps>

80107741 <vector160>:
.globl vector160
vector160:
  pushl $0
80107741:	6a 00                	push   $0x0
  pushl $160
80107743:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107748:	e9 41 f3 ff ff       	jmp    80106a8e <alltraps>

8010774d <vector161>:
.globl vector161
vector161:
  pushl $0
8010774d:	6a 00                	push   $0x0
  pushl $161
8010774f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107754:	e9 35 f3 ff ff       	jmp    80106a8e <alltraps>

80107759 <vector162>:
.globl vector162
vector162:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $162
8010775b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107760:	e9 29 f3 ff ff       	jmp    80106a8e <alltraps>

80107765 <vector163>:
.globl vector163
vector163:
  pushl $0
80107765:	6a 00                	push   $0x0
  pushl $163
80107767:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010776c:	e9 1d f3 ff ff       	jmp    80106a8e <alltraps>

80107771 <vector164>:
.globl vector164
vector164:
  pushl $0
80107771:	6a 00                	push   $0x0
  pushl $164
80107773:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107778:	e9 11 f3 ff ff       	jmp    80106a8e <alltraps>

8010777d <vector165>:
.globl vector165
vector165:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $165
8010777f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107784:	e9 05 f3 ff ff       	jmp    80106a8e <alltraps>

80107789 <vector166>:
.globl vector166
vector166:
  pushl $0
80107789:	6a 00                	push   $0x0
  pushl $166
8010778b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107790:	e9 f9 f2 ff ff       	jmp    80106a8e <alltraps>

80107795 <vector167>:
.globl vector167
vector167:
  pushl $0
80107795:	6a 00                	push   $0x0
  pushl $167
80107797:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010779c:	e9 ed f2 ff ff       	jmp    80106a8e <alltraps>

801077a1 <vector168>:
.globl vector168
vector168:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $168
801077a3:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801077a8:	e9 e1 f2 ff ff       	jmp    80106a8e <alltraps>

801077ad <vector169>:
.globl vector169
vector169:
  pushl $0
801077ad:	6a 00                	push   $0x0
  pushl $169
801077af:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801077b4:	e9 d5 f2 ff ff       	jmp    80106a8e <alltraps>

801077b9 <vector170>:
.globl vector170
vector170:
  pushl $0
801077b9:	6a 00                	push   $0x0
  pushl $170
801077bb:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801077c0:	e9 c9 f2 ff ff       	jmp    80106a8e <alltraps>

801077c5 <vector171>:
.globl vector171
vector171:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $171
801077c7:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801077cc:	e9 bd f2 ff ff       	jmp    80106a8e <alltraps>

801077d1 <vector172>:
.globl vector172
vector172:
  pushl $0
801077d1:	6a 00                	push   $0x0
  pushl $172
801077d3:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801077d8:	e9 b1 f2 ff ff       	jmp    80106a8e <alltraps>

801077dd <vector173>:
.globl vector173
vector173:
  pushl $0
801077dd:	6a 00                	push   $0x0
  pushl $173
801077df:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801077e4:	e9 a5 f2 ff ff       	jmp    80106a8e <alltraps>

801077e9 <vector174>:
.globl vector174
vector174:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $174
801077eb:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801077f0:	e9 99 f2 ff ff       	jmp    80106a8e <alltraps>

801077f5 <vector175>:
.globl vector175
vector175:
  pushl $0
801077f5:	6a 00                	push   $0x0
  pushl $175
801077f7:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801077fc:	e9 8d f2 ff ff       	jmp    80106a8e <alltraps>

80107801 <vector176>:
.globl vector176
vector176:
  pushl $0
80107801:	6a 00                	push   $0x0
  pushl $176
80107803:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107808:	e9 81 f2 ff ff       	jmp    80106a8e <alltraps>

8010780d <vector177>:
.globl vector177
vector177:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $177
8010780f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107814:	e9 75 f2 ff ff       	jmp    80106a8e <alltraps>

80107819 <vector178>:
.globl vector178
vector178:
  pushl $0
80107819:	6a 00                	push   $0x0
  pushl $178
8010781b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107820:	e9 69 f2 ff ff       	jmp    80106a8e <alltraps>

80107825 <vector179>:
.globl vector179
vector179:
  pushl $0
80107825:	6a 00                	push   $0x0
  pushl $179
80107827:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010782c:	e9 5d f2 ff ff       	jmp    80106a8e <alltraps>

80107831 <vector180>:
.globl vector180
vector180:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $180
80107833:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107838:	e9 51 f2 ff ff       	jmp    80106a8e <alltraps>

8010783d <vector181>:
.globl vector181
vector181:
  pushl $0
8010783d:	6a 00                	push   $0x0
  pushl $181
8010783f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107844:	e9 45 f2 ff ff       	jmp    80106a8e <alltraps>

80107849 <vector182>:
.globl vector182
vector182:
  pushl $0
80107849:	6a 00                	push   $0x0
  pushl $182
8010784b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107850:	e9 39 f2 ff ff       	jmp    80106a8e <alltraps>

80107855 <vector183>:
.globl vector183
vector183:
  pushl $0
80107855:	6a 00                	push   $0x0
  pushl $183
80107857:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010785c:	e9 2d f2 ff ff       	jmp    80106a8e <alltraps>

80107861 <vector184>:
.globl vector184
vector184:
  pushl $0
80107861:	6a 00                	push   $0x0
  pushl $184
80107863:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107868:	e9 21 f2 ff ff       	jmp    80106a8e <alltraps>

8010786d <vector185>:
.globl vector185
vector185:
  pushl $0
8010786d:	6a 00                	push   $0x0
  pushl $185
8010786f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107874:	e9 15 f2 ff ff       	jmp    80106a8e <alltraps>

80107879 <vector186>:
.globl vector186
vector186:
  pushl $0
80107879:	6a 00                	push   $0x0
  pushl $186
8010787b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107880:	e9 09 f2 ff ff       	jmp    80106a8e <alltraps>

80107885 <vector187>:
.globl vector187
vector187:
  pushl $0
80107885:	6a 00                	push   $0x0
  pushl $187
80107887:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010788c:	e9 fd f1 ff ff       	jmp    80106a8e <alltraps>

80107891 <vector188>:
.globl vector188
vector188:
  pushl $0
80107891:	6a 00                	push   $0x0
  pushl $188
80107893:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107898:	e9 f1 f1 ff ff       	jmp    80106a8e <alltraps>

8010789d <vector189>:
.globl vector189
vector189:
  pushl $0
8010789d:	6a 00                	push   $0x0
  pushl $189
8010789f:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801078a4:	e9 e5 f1 ff ff       	jmp    80106a8e <alltraps>

801078a9 <vector190>:
.globl vector190
vector190:
  pushl $0
801078a9:	6a 00                	push   $0x0
  pushl $190
801078ab:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801078b0:	e9 d9 f1 ff ff       	jmp    80106a8e <alltraps>

801078b5 <vector191>:
.globl vector191
vector191:
  pushl $0
801078b5:	6a 00                	push   $0x0
  pushl $191
801078b7:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801078bc:	e9 cd f1 ff ff       	jmp    80106a8e <alltraps>

801078c1 <vector192>:
.globl vector192
vector192:
  pushl $0
801078c1:	6a 00                	push   $0x0
  pushl $192
801078c3:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801078c8:	e9 c1 f1 ff ff       	jmp    80106a8e <alltraps>

801078cd <vector193>:
.globl vector193
vector193:
  pushl $0
801078cd:	6a 00                	push   $0x0
  pushl $193
801078cf:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801078d4:	e9 b5 f1 ff ff       	jmp    80106a8e <alltraps>

801078d9 <vector194>:
.globl vector194
vector194:
  pushl $0
801078d9:	6a 00                	push   $0x0
  pushl $194
801078db:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801078e0:	e9 a9 f1 ff ff       	jmp    80106a8e <alltraps>

801078e5 <vector195>:
.globl vector195
vector195:
  pushl $0
801078e5:	6a 00                	push   $0x0
  pushl $195
801078e7:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801078ec:	e9 9d f1 ff ff       	jmp    80106a8e <alltraps>

801078f1 <vector196>:
.globl vector196
vector196:
  pushl $0
801078f1:	6a 00                	push   $0x0
  pushl $196
801078f3:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801078f8:	e9 91 f1 ff ff       	jmp    80106a8e <alltraps>

801078fd <vector197>:
.globl vector197
vector197:
  pushl $0
801078fd:	6a 00                	push   $0x0
  pushl $197
801078ff:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107904:	e9 85 f1 ff ff       	jmp    80106a8e <alltraps>

80107909 <vector198>:
.globl vector198
vector198:
  pushl $0
80107909:	6a 00                	push   $0x0
  pushl $198
8010790b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107910:	e9 79 f1 ff ff       	jmp    80106a8e <alltraps>

80107915 <vector199>:
.globl vector199
vector199:
  pushl $0
80107915:	6a 00                	push   $0x0
  pushl $199
80107917:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010791c:	e9 6d f1 ff ff       	jmp    80106a8e <alltraps>

80107921 <vector200>:
.globl vector200
vector200:
  pushl $0
80107921:	6a 00                	push   $0x0
  pushl $200
80107923:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107928:	e9 61 f1 ff ff       	jmp    80106a8e <alltraps>

8010792d <vector201>:
.globl vector201
vector201:
  pushl $0
8010792d:	6a 00                	push   $0x0
  pushl $201
8010792f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107934:	e9 55 f1 ff ff       	jmp    80106a8e <alltraps>

80107939 <vector202>:
.globl vector202
vector202:
  pushl $0
80107939:	6a 00                	push   $0x0
  pushl $202
8010793b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107940:	e9 49 f1 ff ff       	jmp    80106a8e <alltraps>

80107945 <vector203>:
.globl vector203
vector203:
  pushl $0
80107945:	6a 00                	push   $0x0
  pushl $203
80107947:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010794c:	e9 3d f1 ff ff       	jmp    80106a8e <alltraps>

80107951 <vector204>:
.globl vector204
vector204:
  pushl $0
80107951:	6a 00                	push   $0x0
  pushl $204
80107953:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107958:	e9 31 f1 ff ff       	jmp    80106a8e <alltraps>

8010795d <vector205>:
.globl vector205
vector205:
  pushl $0
8010795d:	6a 00                	push   $0x0
  pushl $205
8010795f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107964:	e9 25 f1 ff ff       	jmp    80106a8e <alltraps>

80107969 <vector206>:
.globl vector206
vector206:
  pushl $0
80107969:	6a 00                	push   $0x0
  pushl $206
8010796b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107970:	e9 19 f1 ff ff       	jmp    80106a8e <alltraps>

80107975 <vector207>:
.globl vector207
vector207:
  pushl $0
80107975:	6a 00                	push   $0x0
  pushl $207
80107977:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010797c:	e9 0d f1 ff ff       	jmp    80106a8e <alltraps>

80107981 <vector208>:
.globl vector208
vector208:
  pushl $0
80107981:	6a 00                	push   $0x0
  pushl $208
80107983:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107988:	e9 01 f1 ff ff       	jmp    80106a8e <alltraps>

8010798d <vector209>:
.globl vector209
vector209:
  pushl $0
8010798d:	6a 00                	push   $0x0
  pushl $209
8010798f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107994:	e9 f5 f0 ff ff       	jmp    80106a8e <alltraps>

80107999 <vector210>:
.globl vector210
vector210:
  pushl $0
80107999:	6a 00                	push   $0x0
  pushl $210
8010799b:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801079a0:	e9 e9 f0 ff ff       	jmp    80106a8e <alltraps>

801079a5 <vector211>:
.globl vector211
vector211:
  pushl $0
801079a5:	6a 00                	push   $0x0
  pushl $211
801079a7:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801079ac:	e9 dd f0 ff ff       	jmp    80106a8e <alltraps>

801079b1 <vector212>:
.globl vector212
vector212:
  pushl $0
801079b1:	6a 00                	push   $0x0
  pushl $212
801079b3:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801079b8:	e9 d1 f0 ff ff       	jmp    80106a8e <alltraps>

801079bd <vector213>:
.globl vector213
vector213:
  pushl $0
801079bd:	6a 00                	push   $0x0
  pushl $213
801079bf:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801079c4:	e9 c5 f0 ff ff       	jmp    80106a8e <alltraps>

801079c9 <vector214>:
.globl vector214
vector214:
  pushl $0
801079c9:	6a 00                	push   $0x0
  pushl $214
801079cb:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801079d0:	e9 b9 f0 ff ff       	jmp    80106a8e <alltraps>

801079d5 <vector215>:
.globl vector215
vector215:
  pushl $0
801079d5:	6a 00                	push   $0x0
  pushl $215
801079d7:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801079dc:	e9 ad f0 ff ff       	jmp    80106a8e <alltraps>

801079e1 <vector216>:
.globl vector216
vector216:
  pushl $0
801079e1:	6a 00                	push   $0x0
  pushl $216
801079e3:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801079e8:	e9 a1 f0 ff ff       	jmp    80106a8e <alltraps>

801079ed <vector217>:
.globl vector217
vector217:
  pushl $0
801079ed:	6a 00                	push   $0x0
  pushl $217
801079ef:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801079f4:	e9 95 f0 ff ff       	jmp    80106a8e <alltraps>

801079f9 <vector218>:
.globl vector218
vector218:
  pushl $0
801079f9:	6a 00                	push   $0x0
  pushl $218
801079fb:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107a00:	e9 89 f0 ff ff       	jmp    80106a8e <alltraps>

80107a05 <vector219>:
.globl vector219
vector219:
  pushl $0
80107a05:	6a 00                	push   $0x0
  pushl $219
80107a07:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107a0c:	e9 7d f0 ff ff       	jmp    80106a8e <alltraps>

80107a11 <vector220>:
.globl vector220
vector220:
  pushl $0
80107a11:	6a 00                	push   $0x0
  pushl $220
80107a13:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107a18:	e9 71 f0 ff ff       	jmp    80106a8e <alltraps>

80107a1d <vector221>:
.globl vector221
vector221:
  pushl $0
80107a1d:	6a 00                	push   $0x0
  pushl $221
80107a1f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107a24:	e9 65 f0 ff ff       	jmp    80106a8e <alltraps>

80107a29 <vector222>:
.globl vector222
vector222:
  pushl $0
80107a29:	6a 00                	push   $0x0
  pushl $222
80107a2b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a30:	e9 59 f0 ff ff       	jmp    80106a8e <alltraps>

80107a35 <vector223>:
.globl vector223
vector223:
  pushl $0
80107a35:	6a 00                	push   $0x0
  pushl $223
80107a37:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a3c:	e9 4d f0 ff ff       	jmp    80106a8e <alltraps>

80107a41 <vector224>:
.globl vector224
vector224:
  pushl $0
80107a41:	6a 00                	push   $0x0
  pushl $224
80107a43:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107a48:	e9 41 f0 ff ff       	jmp    80106a8e <alltraps>

80107a4d <vector225>:
.globl vector225
vector225:
  pushl $0
80107a4d:	6a 00                	push   $0x0
  pushl $225
80107a4f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107a54:	e9 35 f0 ff ff       	jmp    80106a8e <alltraps>

80107a59 <vector226>:
.globl vector226
vector226:
  pushl $0
80107a59:	6a 00                	push   $0x0
  pushl $226
80107a5b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107a60:	e9 29 f0 ff ff       	jmp    80106a8e <alltraps>

80107a65 <vector227>:
.globl vector227
vector227:
  pushl $0
80107a65:	6a 00                	push   $0x0
  pushl $227
80107a67:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107a6c:	e9 1d f0 ff ff       	jmp    80106a8e <alltraps>

80107a71 <vector228>:
.globl vector228
vector228:
  pushl $0
80107a71:	6a 00                	push   $0x0
  pushl $228
80107a73:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a78:	e9 11 f0 ff ff       	jmp    80106a8e <alltraps>

80107a7d <vector229>:
.globl vector229
vector229:
  pushl $0
80107a7d:	6a 00                	push   $0x0
  pushl $229
80107a7f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a84:	e9 05 f0 ff ff       	jmp    80106a8e <alltraps>

80107a89 <vector230>:
.globl vector230
vector230:
  pushl $0
80107a89:	6a 00                	push   $0x0
  pushl $230
80107a8b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107a90:	e9 f9 ef ff ff       	jmp    80106a8e <alltraps>

80107a95 <vector231>:
.globl vector231
vector231:
  pushl $0
80107a95:	6a 00                	push   $0x0
  pushl $231
80107a97:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107a9c:	e9 ed ef ff ff       	jmp    80106a8e <alltraps>

80107aa1 <vector232>:
.globl vector232
vector232:
  pushl $0
80107aa1:	6a 00                	push   $0x0
  pushl $232
80107aa3:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107aa8:	e9 e1 ef ff ff       	jmp    80106a8e <alltraps>

80107aad <vector233>:
.globl vector233
vector233:
  pushl $0
80107aad:	6a 00                	push   $0x0
  pushl $233
80107aaf:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107ab4:	e9 d5 ef ff ff       	jmp    80106a8e <alltraps>

80107ab9 <vector234>:
.globl vector234
vector234:
  pushl $0
80107ab9:	6a 00                	push   $0x0
  pushl $234
80107abb:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107ac0:	e9 c9 ef ff ff       	jmp    80106a8e <alltraps>

80107ac5 <vector235>:
.globl vector235
vector235:
  pushl $0
80107ac5:	6a 00                	push   $0x0
  pushl $235
80107ac7:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107acc:	e9 bd ef ff ff       	jmp    80106a8e <alltraps>

80107ad1 <vector236>:
.globl vector236
vector236:
  pushl $0
80107ad1:	6a 00                	push   $0x0
  pushl $236
80107ad3:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107ad8:	e9 b1 ef ff ff       	jmp    80106a8e <alltraps>

80107add <vector237>:
.globl vector237
vector237:
  pushl $0
80107add:	6a 00                	push   $0x0
  pushl $237
80107adf:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107ae4:	e9 a5 ef ff ff       	jmp    80106a8e <alltraps>

80107ae9 <vector238>:
.globl vector238
vector238:
  pushl $0
80107ae9:	6a 00                	push   $0x0
  pushl $238
80107aeb:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107af0:	e9 99 ef ff ff       	jmp    80106a8e <alltraps>

80107af5 <vector239>:
.globl vector239
vector239:
  pushl $0
80107af5:	6a 00                	push   $0x0
  pushl $239
80107af7:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107afc:	e9 8d ef ff ff       	jmp    80106a8e <alltraps>

80107b01 <vector240>:
.globl vector240
vector240:
  pushl $0
80107b01:	6a 00                	push   $0x0
  pushl $240
80107b03:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107b08:	e9 81 ef ff ff       	jmp    80106a8e <alltraps>

80107b0d <vector241>:
.globl vector241
vector241:
  pushl $0
80107b0d:	6a 00                	push   $0x0
  pushl $241
80107b0f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107b14:	e9 75 ef ff ff       	jmp    80106a8e <alltraps>

80107b19 <vector242>:
.globl vector242
vector242:
  pushl $0
80107b19:	6a 00                	push   $0x0
  pushl $242
80107b1b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107b20:	e9 69 ef ff ff       	jmp    80106a8e <alltraps>

80107b25 <vector243>:
.globl vector243
vector243:
  pushl $0
80107b25:	6a 00                	push   $0x0
  pushl $243
80107b27:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b2c:	e9 5d ef ff ff       	jmp    80106a8e <alltraps>

80107b31 <vector244>:
.globl vector244
vector244:
  pushl $0
80107b31:	6a 00                	push   $0x0
  pushl $244
80107b33:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b38:	e9 51 ef ff ff       	jmp    80106a8e <alltraps>

80107b3d <vector245>:
.globl vector245
vector245:
  pushl $0
80107b3d:	6a 00                	push   $0x0
  pushl $245
80107b3f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b44:	e9 45 ef ff ff       	jmp    80106a8e <alltraps>

80107b49 <vector246>:
.globl vector246
vector246:
  pushl $0
80107b49:	6a 00                	push   $0x0
  pushl $246
80107b4b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107b50:	e9 39 ef ff ff       	jmp    80106a8e <alltraps>

80107b55 <vector247>:
.globl vector247
vector247:
  pushl $0
80107b55:	6a 00                	push   $0x0
  pushl $247
80107b57:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107b5c:	e9 2d ef ff ff       	jmp    80106a8e <alltraps>

80107b61 <vector248>:
.globl vector248
vector248:
  pushl $0
80107b61:	6a 00                	push   $0x0
  pushl $248
80107b63:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107b68:	e9 21 ef ff ff       	jmp    80106a8e <alltraps>

80107b6d <vector249>:
.globl vector249
vector249:
  pushl $0
80107b6d:	6a 00                	push   $0x0
  pushl $249
80107b6f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107b74:	e9 15 ef ff ff       	jmp    80106a8e <alltraps>

80107b79 <vector250>:
.globl vector250
vector250:
  pushl $0
80107b79:	6a 00                	push   $0x0
  pushl $250
80107b7b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b80:	e9 09 ef ff ff       	jmp    80106a8e <alltraps>

80107b85 <vector251>:
.globl vector251
vector251:
  pushl $0
80107b85:	6a 00                	push   $0x0
  pushl $251
80107b87:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107b8c:	e9 fd ee ff ff       	jmp    80106a8e <alltraps>

80107b91 <vector252>:
.globl vector252
vector252:
  pushl $0
80107b91:	6a 00                	push   $0x0
  pushl $252
80107b93:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107b98:	e9 f1 ee ff ff       	jmp    80106a8e <alltraps>

80107b9d <vector253>:
.globl vector253
vector253:
  pushl $0
80107b9d:	6a 00                	push   $0x0
  pushl $253
80107b9f:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107ba4:	e9 e5 ee ff ff       	jmp    80106a8e <alltraps>

80107ba9 <vector254>:
.globl vector254
vector254:
  pushl $0
80107ba9:	6a 00                	push   $0x0
  pushl $254
80107bab:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107bb0:	e9 d9 ee ff ff       	jmp    80106a8e <alltraps>

80107bb5 <vector255>:
.globl vector255
vector255:
  pushl $0
80107bb5:	6a 00                	push   $0x0
  pushl $255
80107bb7:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107bbc:	e9 cd ee ff ff       	jmp    80106a8e <alltraps>

80107bc1 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107bc1:	55                   	push   %ebp
80107bc2:	89 e5                	mov    %esp,%ebp
80107bc4:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bca:	83 e8 01             	sub    $0x1,%eax
80107bcd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107bd1:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80107bdb:	c1 e8 10             	shr    $0x10,%eax
80107bde:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107be2:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107be5:	0f 01 10             	lgdtl  (%eax)
}
80107be8:	c9                   	leave  
80107be9:	c3                   	ret    

80107bea <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107bea:	55                   	push   %ebp
80107beb:	89 e5                	mov    %esp,%ebp
80107bed:	83 ec 04             	sub    $0x4,%esp
80107bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107bf7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bfb:	0f 00 d8             	ltr    %ax
}
80107bfe:	c9                   	leave  
80107bff:	c3                   	ret    

80107c00 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107c00:	55                   	push   %ebp
80107c01:	89 e5                	mov    %esp,%ebp
80107c03:	83 ec 04             	sub    $0x4,%esp
80107c06:	8b 45 08             	mov    0x8(%ebp),%eax
80107c09:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107c0d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c11:	8e e8                	mov    %eax,%gs
}
80107c13:	c9                   	leave  
80107c14:	c3                   	ret    

80107c15 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107c15:	55                   	push   %ebp
80107c16:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c18:	8b 45 08             	mov    0x8(%ebp),%eax
80107c1b:	0f 22 d8             	mov    %eax,%cr3
}
80107c1e:	5d                   	pop    %ebp
80107c1f:	c3                   	ret    

80107c20 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
80107c23:	8b 45 08             	mov    0x8(%ebp),%eax
80107c26:	05 00 00 00 80       	add    $0x80000000,%eax
80107c2b:	5d                   	pop    %ebp
80107c2c:	c3                   	ret    

80107c2d <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107c2d:	55                   	push   %ebp
80107c2e:	89 e5                	mov    %esp,%ebp
80107c30:	8b 45 08             	mov    0x8(%ebp),%eax
80107c33:	05 00 00 00 80       	add    $0x80000000,%eax
80107c38:	5d                   	pop    %ebp
80107c39:	c3                   	ret    

80107c3a <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107c3a:	55                   	push   %ebp
80107c3b:	89 e5                	mov    %esp,%ebp
80107c3d:	53                   	push   %ebx
80107c3e:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107c41:	e8 08 b2 ff ff       	call   80102e4e <cpunum>
80107c46:	c1 e0 02             	shl    $0x2,%eax
80107c49:	89 c2                	mov    %eax,%edx
80107c4b:	c1 e2 07             	shl    $0x7,%edx
80107c4e:	29 c2                	sub    %eax,%edx
80107c50:	8d 82 40 09 11 80    	lea    -0x7feef6c0(%edx),%eax
80107c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5c:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c65:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6e:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c75:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c79:	83 e2 f0             	and    $0xfffffff0,%edx
80107c7c:	83 ca 0a             	or     $0xa,%edx
80107c7f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c85:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c89:	83 ca 10             	or     $0x10,%edx
80107c8c:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c92:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c96:	83 e2 9f             	and    $0xffffff9f,%edx
80107c99:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ca3:	83 ca 80             	or     $0xffffff80,%edx
80107ca6:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cac:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cb0:	83 ca 0f             	or     $0xf,%edx
80107cb3:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cbd:	83 e2 ef             	and    $0xffffffef,%edx
80107cc0:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cca:	83 e2 df             	and    $0xffffffdf,%edx
80107ccd:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cd7:	83 ca 40             	or     $0x40,%edx
80107cda:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ce4:	83 ca 80             	or     $0xffffff80,%edx
80107ce7:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ced:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf4:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107cfb:	ff ff 
80107cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d00:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107d07:	00 00 
80107d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d16:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d1d:	83 e2 f0             	and    $0xfffffff0,%edx
80107d20:	83 ca 02             	or     $0x2,%edx
80107d23:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d33:	83 ca 10             	or     $0x10,%edx
80107d36:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d46:	83 e2 9f             	and    $0xffffff9f,%edx
80107d49:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d52:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d59:	83 ca 80             	or     $0xffffff80,%edx
80107d5c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d65:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d6c:	83 ca 0f             	or     $0xf,%edx
80107d6f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d78:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d7f:	83 e2 ef             	and    $0xffffffef,%edx
80107d82:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d92:	83 e2 df             	and    $0xffffffdf,%edx
80107d95:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107da5:	83 ca 40             	or     $0x40,%edx
80107da8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107db8:	83 ca 80             	or     $0xffffff80,%edx
80107dbb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc4:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dce:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107dd5:	ff ff 
80107dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dda:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107de1:	00 00 
80107de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de6:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107df7:	83 e2 f0             	and    $0xfffffff0,%edx
80107dfa:	83 ca 0a             	or     $0xa,%edx
80107dfd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e06:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e0d:	83 ca 10             	or     $0x10,%edx
80107e10:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e19:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e20:	83 ca 60             	or     $0x60,%edx
80107e23:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e33:	83 ca 80             	or     $0xffffff80,%edx
80107e36:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e46:	83 ca 0f             	or     $0xf,%edx
80107e49:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e52:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e59:	83 e2 ef             	and    $0xffffffef,%edx
80107e5c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e65:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e6c:	83 e2 df             	and    $0xffffffdf,%edx
80107e6f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e78:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e7f:	83 ca 40             	or     $0x40,%edx
80107e82:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e92:	83 ca 80             	or     $0xffffff80,%edx
80107e95:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9e:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea8:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107eaf:	ff ff 
80107eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb4:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107ebb:	00 00 
80107ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec0:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eca:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ed1:	83 e2 f0             	and    $0xfffffff0,%edx
80107ed4:	83 ca 02             	or     $0x2,%edx
80107ed7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ee7:	83 ca 10             	or     $0x10,%edx
80107eea:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107efa:	83 ca 60             	or     $0x60,%edx
80107efd:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f06:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f0d:	83 ca 80             	or     $0xffffff80,%edx
80107f10:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f19:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f20:	83 ca 0f             	or     $0xf,%edx
80107f23:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f33:	83 e2 ef             	and    $0xffffffef,%edx
80107f36:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f46:	83 e2 df             	and    $0xffffffdf,%edx
80107f49:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f52:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f59:	83 ca 40             	or     $0x40,%edx
80107f5c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f65:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f6c:	83 ca 80             	or     $0xffffff80,%edx
80107f6f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f78:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f82:	05 b4 00 00 00       	add    $0xb4,%eax
80107f87:	89 c3                	mov    %eax,%ebx
80107f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8c:	05 b4 00 00 00       	add    $0xb4,%eax
80107f91:	c1 e8 10             	shr    $0x10,%eax
80107f94:	89 c1                	mov    %eax,%ecx
80107f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f99:	05 b4 00 00 00       	add    $0xb4,%eax
80107f9e:	c1 e8 18             	shr    $0x18,%eax
80107fa1:	89 c2                	mov    %eax,%edx
80107fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa6:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107fad:	00 00 
80107faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb2:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbc:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc5:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107fcc:	83 e1 f0             	and    $0xfffffff0,%ecx
80107fcf:	83 c9 02             	or     $0x2,%ecx
80107fd2:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdb:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107fe2:	83 c9 10             	or     $0x10,%ecx
80107fe5:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fee:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107ff5:	83 e1 9f             	and    $0xffffff9f,%ecx
80107ff8:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108001:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108008:	83 c9 80             	or     $0xffffff80,%ecx
8010800b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108014:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010801b:	83 e1 f0             	and    $0xfffffff0,%ecx
8010801e:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108027:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010802e:	83 e1 ef             	and    $0xffffffef,%ecx
80108031:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803a:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108041:	83 e1 df             	and    $0xffffffdf,%ecx
80108044:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010804a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804d:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108054:	83 c9 40             	or     $0x40,%ecx
80108057:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010805d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108060:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108067:	83 c9 80             	or     $0xffffff80,%ecx
8010806a:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108070:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108073:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807c:	83 c0 70             	add    $0x70,%eax
8010807f:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80108086:	00 
80108087:	89 04 24             	mov    %eax,(%esp)
8010808a:	e8 32 fb ff ff       	call   80107bc1 <lgdt>
  loadgs(SEG_KCPU << 3);
8010808f:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80108096:	e8 65 fb ff ff       	call   80107c00 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
8010809b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809e:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801080a4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801080ab:	00 00 00 00 
}
801080af:	83 c4 24             	add    $0x24,%esp
801080b2:	5b                   	pop    %ebx
801080b3:	5d                   	pop    %ebp
801080b4:	c3                   	ret    

801080b5 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801080b5:	55                   	push   %ebp
801080b6:	89 e5                	mov    %esp,%ebp
801080b8:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801080bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801080be:	c1 e8 16             	shr    $0x16,%eax
801080c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080c8:	8b 45 08             	mov    0x8(%ebp),%eax
801080cb:	01 d0                	add    %edx,%eax
801080cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801080d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080d3:	8b 00                	mov    (%eax),%eax
801080d5:	83 e0 01             	and    $0x1,%eax
801080d8:	85 c0                	test   %eax,%eax
801080da:	74 17                	je     801080f3 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801080dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080df:	8b 00                	mov    (%eax),%eax
801080e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080e6:	89 04 24             	mov    %eax,(%esp)
801080e9:	e8 3f fb ff ff       	call   80107c2d <p2v>
801080ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080f1:	eb 4b                	jmp    8010813e <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801080f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801080f7:	74 0e                	je     80108107 <walkpgdir+0x52>
801080f9:	e8 d7 a9 ff ff       	call   80102ad5 <kalloc>
801080fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108101:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108105:	75 07                	jne    8010810e <walkpgdir+0x59>
      return 0;
80108107:	b8 00 00 00 00       	mov    $0x0,%eax
8010810c:	eb 47                	jmp    80108155 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010810e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108115:	00 
80108116:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010811d:	00 
8010811e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108121:	89 04 24             	mov    %eax,(%esp)
80108124:	e8 f0 d3 ff ff       	call   80105519 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812c:	89 04 24             	mov    %eax,(%esp)
8010812f:	e8 ec fa ff ff       	call   80107c20 <v2p>
80108134:	83 c8 07             	or     $0x7,%eax
80108137:	89 c2                	mov    %eax,%edx
80108139:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010813c:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010813e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108141:	c1 e8 0c             	shr    $0xc,%eax
80108144:	25 ff 03 00 00       	and    $0x3ff,%eax
80108149:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108153:	01 d0                	add    %edx,%eax
}
80108155:	c9                   	leave  
80108156:	c3                   	ret    

80108157 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108157:	55                   	push   %ebp
80108158:	89 e5                	mov    %esp,%ebp
8010815a:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010815d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108168:	8b 55 0c             	mov    0xc(%ebp),%edx
8010816b:	8b 45 10             	mov    0x10(%ebp),%eax
8010816e:	01 d0                	add    %edx,%eax
80108170:	83 e8 01             	sub    $0x1,%eax
80108173:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108178:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010817b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80108182:	00 
80108183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108186:	89 44 24 04          	mov    %eax,0x4(%esp)
8010818a:	8b 45 08             	mov    0x8(%ebp),%eax
8010818d:	89 04 24             	mov    %eax,(%esp)
80108190:	e8 20 ff ff ff       	call   801080b5 <walkpgdir>
80108195:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108198:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010819c:	75 07                	jne    801081a5 <mappages+0x4e>
      return -1;
8010819e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081a3:	eb 48                	jmp    801081ed <mappages+0x96>
    if(*pte & PTE_P)
801081a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081a8:	8b 00                	mov    (%eax),%eax
801081aa:	83 e0 01             	and    $0x1,%eax
801081ad:	85 c0                	test   %eax,%eax
801081af:	74 0c                	je     801081bd <mappages+0x66>
      panic("remap");
801081b1:	c7 04 24 d4 8f 10 80 	movl   $0x80108fd4,(%esp)
801081b8:	e8 7d 83 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
801081bd:	8b 45 18             	mov    0x18(%ebp),%eax
801081c0:	0b 45 14             	or     0x14(%ebp),%eax
801081c3:	83 c8 01             	or     $0x1,%eax
801081c6:	89 c2                	mov    %eax,%edx
801081c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081cb:	89 10                	mov    %edx,(%eax)
    if(a == last)
801081cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801081d3:	75 08                	jne    801081dd <mappages+0x86>
      break;
801081d5:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801081d6:	b8 00 00 00 00       	mov    $0x0,%eax
801081db:	eb 10                	jmp    801081ed <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801081dd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801081e4:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801081eb:	eb 8e                	jmp    8010817b <mappages+0x24>
  return 0;
}
801081ed:	c9                   	leave  
801081ee:	c3                   	ret    

801081ef <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
801081ef:	55                   	push   %ebp
801081f0:	89 e5                	mov    %esp,%ebp
801081f2:	53                   	push   %ebx
801081f3:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801081f6:	e8 da a8 ff ff       	call   80102ad5 <kalloc>
801081fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108202:	75 0a                	jne    8010820e <setupkvm+0x1f>
    return 0;
80108204:	b8 00 00 00 00       	mov    $0x0,%eax
80108209:	e9 98 00 00 00       	jmp    801082a6 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
8010820e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108215:	00 
80108216:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010821d:	00 
8010821e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108221:	89 04 24             	mov    %eax,(%esp)
80108224:	e8 f0 d2 ff ff       	call   80105519 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108229:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108230:	e8 f8 f9 ff ff       	call   80107c2d <p2v>
80108235:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010823a:	76 0c                	jbe    80108248 <setupkvm+0x59>
    panic("PHYSTOP too high");
8010823c:	c7 04 24 da 8f 10 80 	movl   $0x80108fda,(%esp)
80108243:	e8 f2 82 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108248:	c7 45 f4 a0 c4 10 80 	movl   $0x8010c4a0,-0xc(%ebp)
8010824f:	eb 49                	jmp    8010829a <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108254:	8b 48 0c             	mov    0xc(%eax),%ecx
80108257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825a:	8b 50 04             	mov    0x4(%eax),%edx
8010825d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108260:	8b 58 08             	mov    0x8(%eax),%ebx
80108263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108266:	8b 40 04             	mov    0x4(%eax),%eax
80108269:	29 c3                	sub    %eax,%ebx
8010826b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826e:	8b 00                	mov    (%eax),%eax
80108270:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108274:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108278:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010827c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108280:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108283:	89 04 24             	mov    %eax,(%esp)
80108286:	e8 cc fe ff ff       	call   80108157 <mappages>
8010828b:	85 c0                	test   %eax,%eax
8010828d:	79 07                	jns    80108296 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010828f:	b8 00 00 00 00       	mov    $0x0,%eax
80108294:	eb 10                	jmp    801082a6 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108296:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010829a:	81 7d f4 e0 c4 10 80 	cmpl   $0x8010c4e0,-0xc(%ebp)
801082a1:	72 ae                	jb     80108251 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801082a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801082a6:	83 c4 34             	add    $0x34,%esp
801082a9:	5b                   	pop    %ebx
801082aa:	5d                   	pop    %ebp
801082ab:	c3                   	ret    

801082ac <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801082ac:	55                   	push   %ebp
801082ad:	89 e5                	mov    %esp,%ebp
801082af:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801082b2:	e8 38 ff ff ff       	call   801081ef <setupkvm>
801082b7:	a3 18 33 15 80       	mov    %eax,0x80153318
  switchkvm();
801082bc:	e8 02 00 00 00       	call   801082c3 <switchkvm>
}
801082c1:	c9                   	leave  
801082c2:	c3                   	ret    

801082c3 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801082c3:	55                   	push   %ebp
801082c4:	89 e5                	mov    %esp,%ebp
801082c6:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801082c9:	a1 18 33 15 80       	mov    0x80153318,%eax
801082ce:	89 04 24             	mov    %eax,(%esp)
801082d1:	e8 4a f9 ff ff       	call   80107c20 <v2p>
801082d6:	89 04 24             	mov    %eax,(%esp)
801082d9:	e8 37 f9 ff ff       	call   80107c15 <lcr3>
}
801082de:	c9                   	leave  
801082df:	c3                   	ret    

801082e0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	53                   	push   %ebx
801082e4:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801082e7:	e8 2d d1 ff ff       	call   80105419 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801082ec:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082f2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082f9:	83 c2 08             	add    $0x8,%edx
801082fc:	89 d3                	mov    %edx,%ebx
801082fe:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108305:	83 c2 08             	add    $0x8,%edx
80108308:	c1 ea 10             	shr    $0x10,%edx
8010830b:	89 d1                	mov    %edx,%ecx
8010830d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108314:	83 c2 08             	add    $0x8,%edx
80108317:	c1 ea 18             	shr    $0x18,%edx
8010831a:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108321:	67 00 
80108323:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
8010832a:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80108330:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108337:	83 e1 f0             	and    $0xfffffff0,%ecx
8010833a:	83 c9 09             	or     $0x9,%ecx
8010833d:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108343:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010834a:	83 c9 10             	or     $0x10,%ecx
8010834d:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108353:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010835a:	83 e1 9f             	and    $0xffffff9f,%ecx
8010835d:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108363:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010836a:	83 c9 80             	or     $0xffffff80,%ecx
8010836d:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108373:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010837a:	83 e1 f0             	and    $0xfffffff0,%ecx
8010837d:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108383:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010838a:	83 e1 ef             	and    $0xffffffef,%ecx
8010838d:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108393:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010839a:	83 e1 df             	and    $0xffffffdf,%ecx
8010839d:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801083a3:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801083aa:	83 c9 40             	or     $0x40,%ecx
801083ad:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801083b3:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801083ba:	83 e1 7f             	and    $0x7f,%ecx
801083bd:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801083c3:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801083c9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083cf:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801083d6:	83 e2 ef             	and    $0xffffffef,%edx
801083d9:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801083df:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083e5:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801083eb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083f1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801083f8:	8b 52 08             	mov    0x8(%edx),%edx
801083fb:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108401:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108404:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
8010840b:	e8 da f7 ff ff       	call   80107bea <ltr>
  if(p->pgdir == 0)
80108410:	8b 45 08             	mov    0x8(%ebp),%eax
80108413:	8b 40 04             	mov    0x4(%eax),%eax
80108416:	85 c0                	test   %eax,%eax
80108418:	75 0c                	jne    80108426 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
8010841a:	c7 04 24 eb 8f 10 80 	movl   $0x80108feb,(%esp)
80108421:	e8 14 81 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108426:	8b 45 08             	mov    0x8(%ebp),%eax
80108429:	8b 40 04             	mov    0x4(%eax),%eax
8010842c:	89 04 24             	mov    %eax,(%esp)
8010842f:	e8 ec f7 ff ff       	call   80107c20 <v2p>
80108434:	89 04 24             	mov    %eax,(%esp)
80108437:	e8 d9 f7 ff ff       	call   80107c15 <lcr3>
  popcli();
8010843c:	e8 1c d0 ff ff       	call   8010545d <popcli>
}
80108441:	83 c4 14             	add    $0x14,%esp
80108444:	5b                   	pop    %ebx
80108445:	5d                   	pop    %ebp
80108446:	c3                   	ret    

80108447 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108447:	55                   	push   %ebp
80108448:	89 e5                	mov    %esp,%ebp
8010844a:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010844d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108454:	76 0c                	jbe    80108462 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108456:	c7 04 24 ff 8f 10 80 	movl   $0x80108fff,(%esp)
8010845d:	e8 d8 80 ff ff       	call   8010053a <panic>
  mem = kalloc();
80108462:	e8 6e a6 ff ff       	call   80102ad5 <kalloc>
80108467:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010846a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108471:	00 
80108472:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108479:	00 
8010847a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010847d:	89 04 24             	mov    %eax,(%esp)
80108480:	e8 94 d0 ff ff       	call   80105519 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108488:	89 04 24             	mov    %eax,(%esp)
8010848b:	e8 90 f7 ff ff       	call   80107c20 <v2p>
80108490:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108497:	00 
80108498:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010849c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084a3:	00 
801084a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801084ab:	00 
801084ac:	8b 45 08             	mov    0x8(%ebp),%eax
801084af:	89 04 24             	mov    %eax,(%esp)
801084b2:	e8 a0 fc ff ff       	call   80108157 <mappages>
  memmove(mem, init, sz);
801084b7:	8b 45 10             	mov    0x10(%ebp),%eax
801084ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801084be:	8b 45 0c             	mov    0xc(%ebp),%eax
801084c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801084c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c8:	89 04 24             	mov    %eax,(%esp)
801084cb:	e8 18 d1 ff ff       	call   801055e8 <memmove>
}
801084d0:	c9                   	leave  
801084d1:	c3                   	ret    

801084d2 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801084d2:	55                   	push   %ebp
801084d3:	89 e5                	mov    %esp,%ebp
801084d5:	53                   	push   %ebx
801084d6:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801084d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801084dc:	25 ff 0f 00 00       	and    $0xfff,%eax
801084e1:	85 c0                	test   %eax,%eax
801084e3:	74 0c                	je     801084f1 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801084e5:	c7 04 24 1c 90 10 80 	movl   $0x8010901c,(%esp)
801084ec:	e8 49 80 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
801084f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084f8:	e9 a9 00 00 00       	jmp    801085a6 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801084fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108500:	8b 55 0c             	mov    0xc(%ebp),%edx
80108503:	01 d0                	add    %edx,%eax
80108505:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010850c:	00 
8010850d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108511:	8b 45 08             	mov    0x8(%ebp),%eax
80108514:	89 04 24             	mov    %eax,(%esp)
80108517:	e8 99 fb ff ff       	call   801080b5 <walkpgdir>
8010851c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010851f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108523:	75 0c                	jne    80108531 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108525:	c7 04 24 3f 90 10 80 	movl   $0x8010903f,(%esp)
8010852c:	e8 09 80 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108531:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108534:	8b 00                	mov    (%eax),%eax
80108536:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010853b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010853e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108541:	8b 55 18             	mov    0x18(%ebp),%edx
80108544:	29 c2                	sub    %eax,%edx
80108546:	89 d0                	mov    %edx,%eax
80108548:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010854d:	77 0f                	ja     8010855e <loaduvm+0x8c>
      n = sz - i;
8010854f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108552:	8b 55 18             	mov    0x18(%ebp),%edx
80108555:	29 c2                	sub    %eax,%edx
80108557:	89 d0                	mov    %edx,%eax
80108559:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010855c:	eb 07                	jmp    80108565 <loaduvm+0x93>
    else
      n = PGSIZE;
8010855e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108568:	8b 55 14             	mov    0x14(%ebp),%edx
8010856b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010856e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108571:	89 04 24             	mov    %eax,(%esp)
80108574:	e8 b4 f6 ff ff       	call   80107c2d <p2v>
80108579:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010857c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108580:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108584:	89 44 24 04          	mov    %eax,0x4(%esp)
80108588:	8b 45 10             	mov    0x10(%ebp),%eax
8010858b:	89 04 24             	mov    %eax,(%esp)
8010858e:	e8 c8 97 ff ff       	call   80101d5b <readi>
80108593:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108596:	74 07                	je     8010859f <loaduvm+0xcd>
      return -1;
80108598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010859d:	eb 18                	jmp    801085b7 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010859f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a9:	3b 45 18             	cmp    0x18(%ebp),%eax
801085ac:	0f 82 4b ff ff ff    	jb     801084fd <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801085b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085b7:	83 c4 24             	add    $0x24,%esp
801085ba:	5b                   	pop    %ebx
801085bb:	5d                   	pop    %ebp
801085bc:	c3                   	ret    

801085bd <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801085bd:	55                   	push   %ebp
801085be:	89 e5                	mov    %esp,%ebp
801085c0:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801085c3:	8b 45 10             	mov    0x10(%ebp),%eax
801085c6:	85 c0                	test   %eax,%eax
801085c8:	79 0a                	jns    801085d4 <allocuvm+0x17>
    return 0;
801085ca:	b8 00 00 00 00       	mov    $0x0,%eax
801085cf:	e9 c1 00 00 00       	jmp    80108695 <allocuvm+0xd8>
  if(newsz < oldsz)
801085d4:	8b 45 10             	mov    0x10(%ebp),%eax
801085d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801085da:	73 08                	jae    801085e4 <allocuvm+0x27>
    return oldsz;
801085dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801085df:	e9 b1 00 00 00       	jmp    80108695 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801085e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801085e7:	05 ff 0f 00 00       	add    $0xfff,%eax
801085ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801085f4:	e9 8d 00 00 00       	jmp    80108686 <allocuvm+0xc9>
    mem = kalloc();
801085f9:	e8 d7 a4 ff ff       	call   80102ad5 <kalloc>
801085fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108601:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108605:	75 2c                	jne    80108633 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108607:	c7 04 24 5d 90 10 80 	movl   $0x8010905d,(%esp)
8010860e:	e8 8d 7d ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108613:	8b 45 0c             	mov    0xc(%ebp),%eax
80108616:	89 44 24 08          	mov    %eax,0x8(%esp)
8010861a:	8b 45 10             	mov    0x10(%ebp),%eax
8010861d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108621:	8b 45 08             	mov    0x8(%ebp),%eax
80108624:	89 04 24             	mov    %eax,(%esp)
80108627:	e8 6b 00 00 00       	call   80108697 <deallocuvm>
      return 0;
8010862c:	b8 00 00 00 00       	mov    $0x0,%eax
80108631:	eb 62                	jmp    80108695 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108633:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010863a:	00 
8010863b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108642:	00 
80108643:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108646:	89 04 24             	mov    %eax,(%esp)
80108649:	e8 cb ce ff ff       	call   80105519 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010864e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108651:	89 04 24             	mov    %eax,(%esp)
80108654:	e8 c7 f5 ff ff       	call   80107c20 <v2p>
80108659:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010865c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108663:	00 
80108664:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108668:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010866f:	00 
80108670:	89 54 24 04          	mov    %edx,0x4(%esp)
80108674:	8b 45 08             	mov    0x8(%ebp),%eax
80108677:	89 04 24             	mov    %eax,(%esp)
8010867a:	e8 d8 fa ff ff       	call   80108157 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010867f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108689:	3b 45 10             	cmp    0x10(%ebp),%eax
8010868c:	0f 82 67 ff ff ff    	jb     801085f9 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108692:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108695:	c9                   	leave  
80108696:	c3                   	ret    

80108697 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108697:	55                   	push   %ebp
80108698:	89 e5                	mov    %esp,%ebp
8010869a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010869d:	8b 45 10             	mov    0x10(%ebp),%eax
801086a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086a3:	72 08                	jb     801086ad <deallocuvm+0x16>
    return oldsz;
801086a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801086a8:	e9 a4 00 00 00       	jmp    80108751 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801086ad:	8b 45 10             	mov    0x10(%ebp),%eax
801086b0:	05 ff 0f 00 00       	add    $0xfff,%eax
801086b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801086bd:	e9 80 00 00 00       	jmp    80108742 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801086c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801086cc:	00 
801086cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801086d1:	8b 45 08             	mov    0x8(%ebp),%eax
801086d4:	89 04 24             	mov    %eax,(%esp)
801086d7:	e8 d9 f9 ff ff       	call   801080b5 <walkpgdir>
801086dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801086df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086e3:	75 09                	jne    801086ee <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801086e5:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801086ec:	eb 4d                	jmp    8010873b <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801086ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086f1:	8b 00                	mov    (%eax),%eax
801086f3:	83 e0 01             	and    $0x1,%eax
801086f6:	85 c0                	test   %eax,%eax
801086f8:	74 41                	je     8010873b <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801086fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086fd:	8b 00                	mov    (%eax),%eax
801086ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108704:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108707:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010870b:	75 0c                	jne    80108719 <deallocuvm+0x82>
        panic("kfree");
8010870d:	c7 04 24 75 90 10 80 	movl   $0x80109075,(%esp)
80108714:	e8 21 7e ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108719:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010871c:	89 04 24             	mov    %eax,(%esp)
8010871f:	e8 09 f5 ff ff       	call   80107c2d <p2v>
80108724:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108727:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010872a:	89 04 24             	mov    %eax,(%esp)
8010872d:	e8 0a a3 ff ff       	call   80102a3c <kfree>
      *pte = 0;
80108732:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010873b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108745:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108748:	0f 82 74 ff ff ff    	jb     801086c2 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010874e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108751:	c9                   	leave  
80108752:	c3                   	ret    

80108753 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108753:	55                   	push   %ebp
80108754:	89 e5                	mov    %esp,%ebp
80108756:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108759:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010875d:	75 0c                	jne    8010876b <freevm+0x18>
    panic("freevm: no pgdir");
8010875f:	c7 04 24 7b 90 10 80 	movl   $0x8010907b,(%esp)
80108766:	e8 cf 7d ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010876b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108772:	00 
80108773:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010877a:	80 
8010877b:	8b 45 08             	mov    0x8(%ebp),%eax
8010877e:	89 04 24             	mov    %eax,(%esp)
80108781:	e8 11 ff ff ff       	call   80108697 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108786:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010878d:	eb 48                	jmp    801087d7 <freevm+0x84>
    if(pgdir[i] & PTE_P){
8010878f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108799:	8b 45 08             	mov    0x8(%ebp),%eax
8010879c:	01 d0                	add    %edx,%eax
8010879e:	8b 00                	mov    (%eax),%eax
801087a0:	83 e0 01             	and    $0x1,%eax
801087a3:	85 c0                	test   %eax,%eax
801087a5:	74 2c                	je     801087d3 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801087a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801087b1:	8b 45 08             	mov    0x8(%ebp),%eax
801087b4:	01 d0                	add    %edx,%eax
801087b6:	8b 00                	mov    (%eax),%eax
801087b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087bd:	89 04 24             	mov    %eax,(%esp)
801087c0:	e8 68 f4 ff ff       	call   80107c2d <p2v>
801087c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801087c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087cb:	89 04 24             	mov    %eax,(%esp)
801087ce:	e8 69 a2 ff ff       	call   80102a3c <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801087d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801087d7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801087de:	76 af                	jbe    8010878f <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801087e0:	8b 45 08             	mov    0x8(%ebp),%eax
801087e3:	89 04 24             	mov    %eax,(%esp)
801087e6:	e8 51 a2 ff ff       	call   80102a3c <kfree>
}
801087eb:	c9                   	leave  
801087ec:	c3                   	ret    

801087ed <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801087ed:	55                   	push   %ebp
801087ee:	89 e5                	mov    %esp,%ebp
801087f0:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801087f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087fa:	00 
801087fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801087fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80108802:	8b 45 08             	mov    0x8(%ebp),%eax
80108805:	89 04 24             	mov    %eax,(%esp)
80108808:	e8 a8 f8 ff ff       	call   801080b5 <walkpgdir>
8010880d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108814:	75 0c                	jne    80108822 <clearpteu+0x35>
    panic("clearpteu");
80108816:	c7 04 24 8c 90 10 80 	movl   $0x8010908c,(%esp)
8010881d:	e8 18 7d ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108825:	8b 00                	mov    (%eax),%eax
80108827:	83 e0 fb             	and    $0xfffffffb,%eax
8010882a:	89 c2                	mov    %eax,%edx
8010882c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010882f:	89 10                	mov    %edx,(%eax)
}
80108831:	c9                   	leave  
80108832:	c3                   	ret    

80108833 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108833:	55                   	push   %ebp
80108834:	89 e5                	mov    %esp,%ebp
80108836:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
80108839:	e8 b1 f9 ff ff       	call   801081ef <setupkvm>
8010883e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108841:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108845:	75 0a                	jne    80108851 <copyuvm+0x1e>
    return 0;
80108847:	b8 00 00 00 00       	mov    $0x0,%eax
8010884c:	e9 f1 00 00 00       	jmp    80108942 <copyuvm+0x10f>
  for(i = 0; i < sz; i += PGSIZE){
80108851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108858:	e9 c4 00 00 00       	jmp    80108921 <copyuvm+0xee>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010885d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108860:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108867:	00 
80108868:	89 44 24 04          	mov    %eax,0x4(%esp)
8010886c:	8b 45 08             	mov    0x8(%ebp),%eax
8010886f:	89 04 24             	mov    %eax,(%esp)
80108872:	e8 3e f8 ff ff       	call   801080b5 <walkpgdir>
80108877:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010887a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010887e:	75 0c                	jne    8010888c <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108880:	c7 04 24 96 90 10 80 	movl   $0x80109096,(%esp)
80108887:	e8 ae 7c ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
8010888c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010888f:	8b 00                	mov    (%eax),%eax
80108891:	83 e0 01             	and    $0x1,%eax
80108894:	85 c0                	test   %eax,%eax
80108896:	75 0c                	jne    801088a4 <copyuvm+0x71>
      panic("copyuvm: page not present");
80108898:	c7 04 24 b0 90 10 80 	movl   $0x801090b0,(%esp)
8010889f:	e8 96 7c ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801088a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088a7:	8b 00                	mov    (%eax),%eax
801088a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
801088b1:	e8 1f a2 ff ff       	call   80102ad5 <kalloc>
801088b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801088b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801088bd:	75 02                	jne    801088c1 <copyuvm+0x8e>
      goto bad;
801088bf:	eb 71                	jmp    80108932 <copyuvm+0xff>
    memmove(mem, (char*)p2v(pa), PGSIZE);
801088c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801088c4:	89 04 24             	mov    %eax,(%esp)
801088c7:	e8 61 f3 ff ff       	call   80107c2d <p2v>
801088cc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088d3:	00 
801088d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801088d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801088db:	89 04 24             	mov    %eax,(%esp)
801088de:	e8 05 cd ff ff       	call   801055e8 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
801088e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801088e6:	89 04 24             	mov    %eax,(%esp)
801088e9:	e8 32 f3 ff ff       	call   80107c20 <v2p>
801088ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801088f1:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801088f8:	00 
801088f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
801088fd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108904:	00 
80108905:	89 54 24 04          	mov    %edx,0x4(%esp)
80108909:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010890c:	89 04 24             	mov    %eax,(%esp)
8010890f:	e8 43 f8 ff ff       	call   80108157 <mappages>
80108914:	85 c0                	test   %eax,%eax
80108916:	79 02                	jns    8010891a <copyuvm+0xe7>
      goto bad;
80108918:	eb 18                	jmp    80108932 <copyuvm+0xff>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010891a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108924:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108927:	0f 82 30 ff ff ff    	jb     8010885d <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
8010892d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108930:	eb 10                	jmp    80108942 <copyuvm+0x10f>

bad:
  freevm(d);
80108932:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108935:	89 04 24             	mov    %eax,(%esp)
80108938:	e8 16 fe ff ff       	call   80108753 <freevm>
  return 0;
8010893d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108942:	c9                   	leave  
80108943:	c3                   	ret    

80108944 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108944:	55                   	push   %ebp
80108945:	89 e5                	mov    %esp,%ebp
80108947:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010894a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108951:	00 
80108952:	8b 45 0c             	mov    0xc(%ebp),%eax
80108955:	89 44 24 04          	mov    %eax,0x4(%esp)
80108959:	8b 45 08             	mov    0x8(%ebp),%eax
8010895c:	89 04 24             	mov    %eax,(%esp)
8010895f:	e8 51 f7 ff ff       	call   801080b5 <walkpgdir>
80108964:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010896a:	8b 00                	mov    (%eax),%eax
8010896c:	83 e0 01             	and    $0x1,%eax
8010896f:	85 c0                	test   %eax,%eax
80108971:	75 07                	jne    8010897a <uva2ka+0x36>
    return 0;
80108973:	b8 00 00 00 00       	mov    $0x0,%eax
80108978:	eb 25                	jmp    8010899f <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010897a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010897d:	8b 00                	mov    (%eax),%eax
8010897f:	83 e0 04             	and    $0x4,%eax
80108982:	85 c0                	test   %eax,%eax
80108984:	75 07                	jne    8010898d <uva2ka+0x49>
    return 0;
80108986:	b8 00 00 00 00       	mov    $0x0,%eax
8010898b:	eb 12                	jmp    8010899f <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010898d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108990:	8b 00                	mov    (%eax),%eax
80108992:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108997:	89 04 24             	mov    %eax,(%esp)
8010899a:	e8 8e f2 ff ff       	call   80107c2d <p2v>
}
8010899f:	c9                   	leave  
801089a0:	c3                   	ret    

801089a1 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801089a1:	55                   	push   %ebp
801089a2:	89 e5                	mov    %esp,%ebp
801089a4:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801089a7:	8b 45 10             	mov    0x10(%ebp),%eax
801089aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801089ad:	e9 87 00 00 00       	jmp    80108a39 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801089b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801089b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801089bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801089c4:	8b 45 08             	mov    0x8(%ebp),%eax
801089c7:	89 04 24             	mov    %eax,(%esp)
801089ca:	e8 75 ff ff ff       	call   80108944 <uva2ka>
801089cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801089d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801089d6:	75 07                	jne    801089df <copyout+0x3e>
      return -1;
801089d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801089dd:	eb 69                	jmp    80108a48 <copyout+0xa7>
    n = PGSIZE - (va - va0);
801089df:	8b 45 0c             	mov    0xc(%ebp),%eax
801089e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801089e5:	29 c2                	sub    %eax,%edx
801089e7:	89 d0                	mov    %edx,%eax
801089e9:	05 00 10 00 00       	add    $0x1000,%eax
801089ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801089f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089f4:	3b 45 14             	cmp    0x14(%ebp),%eax
801089f7:	76 06                	jbe    801089ff <copyout+0x5e>
      n = len;
801089f9:	8b 45 14             	mov    0x14(%ebp),%eax
801089fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801089ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a02:	8b 55 0c             	mov    0xc(%ebp),%edx
80108a05:	29 c2                	sub    %eax,%edx
80108a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a0a:	01 c2                	add    %eax,%edx
80108a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a0f:	89 44 24 08          	mov    %eax,0x8(%esp)
80108a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a16:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a1a:	89 14 24             	mov    %edx,(%esp)
80108a1d:	e8 c6 cb ff ff       	call   801055e8 <memmove>
    len -= n;
80108a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a25:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a2b:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a31:	05 00 10 00 00       	add    $0x1000,%eax
80108a36:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108a39:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108a3d:	0f 85 6f ff ff ff    	jne    801089b2 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a48:	c9                   	leave  
80108a49:	c3                   	ret    
