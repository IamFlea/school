/**
 * Author: Petr Dvoracek
 * Date: Dec, 2012
 * Project: Arkanoid 16x8 on two displays
 * Description: Implementation of the old school game arkanoid.
 */
#include <fitkitlib.h>   
#include <keyboard/keyboard.h>
#include <lcd/display.h>

#define D_HEIGHT 7
#define D_WIDTH 10

#define P_NIC   0
#define P_KOULE 1
#define P_CIHLA 2
#define P_DESKA 3

const char initDisplay [D_HEIGHT][D_WIDTH] = {
  {2,2,2,2,2,2,2,2,2,2},
  {2,2,2,2,2,2,2,2,2,2},
  {0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,1,0,0,0,0},
  {0,0,0,0,3,3,3,0,0,0}
};

char display [D_HEIGHT][D_WIDTH] = {
  {0,0,0,0,1,1,1,0,0,0},
  {0,0,0,1,0,1,0,1,0,0},
  {0,0,1,0,0,1,0,0,1,0},
  {0,0,1,0,0,1,0,0,1,0},
  {0,0,1,0,1,1,1,0,1,0},
  {0,0,0,1,0,1,0,1,0,0},
  {0,0,0,0,1,1,1,0,0,0}
};

/**
 * Vypis napovedy na terminal
 */
void print_user_help(void)
{
  term_send_str_crlf(" INIT             inicializuje LCD");
}

/**
 * Obsluha terminalu  
 */
unsigned char decode_user_cmd(char* cmd_ucase, char* cmd)
{
  return(CMD_UNKNOWN);
}

/**
 * Inicializace periferii/komponent po naprogramovani FPGA
 */
void fpga_initialized() {
  //keyboard_init();
}
void LED_draw();
/**
 * Ocekavane stisknuti klavesy 5...
 */ 
int press5()
{
  char ch;
  ch = key_decode(read_word_keyboard_4x4());
  delay_ms(10); // Nebyl to zakmit?
  if (ch == key_decode(read_word_keyboard_4x4()))
  {
      if(ch == '5')
        return 1; 
  }
  LED_draw();
  return 0;
}


/**
 * Moje zpozdeni, protoze pri 1ms vidite blikat ledky..
 * (je to skoro 1ms) akorat polovicni
 */
void LED_delay()
{
  unsigned long Pomdelay_cycle;
  unsigned int  FirstTBR;
  unsigned int  SecondTBR;
  unsigned long msecs = 921;  // cca 0.5 ms
  FirstTBR = TBR;
  Pomdelay_cycle = 0;

  while (Pomdelay_cycle < msecs) 
  {

    WDG_reset();  //nulovani watchdogu

    SecondTBR = TBR;
    if (SecondTBR != FirstTBR) 
    {
       if (SecondTBR > FirstTBR)
         Pomdelay_cycle = Pomdelay_cycle + (unsigned long)(SecondTBR - FirstTBR);
       else
         Pomdelay_cycle = Pomdelay_cycle + (unsigned long)((TBCCR0 - FirstTBR) + SecondTBR + 1);

       FirstTBR = SecondTBR;
    }
  }
}

// Init displaye
void LED_init()
{
  int i, j;
  for(i = 0; i < D_HEIGHT; i++)
  {
    for(j = 0; j < D_WIDTH; j++)
      display[i][j] = initDisplay[i][j];
  }
}

/**
 * Vykresli na LED
 */
void LED_draw()
{
  int i;
  int j;
  unsigned char print = 0;
  P4DIR = 0x3f; // 0011 1111 1-6 radek
  P2DIR = 0xf2; // 1111 0010 1-4 sloupec + 7 radek
  P1DIR = 0xf0; // 1111 0000 5-8 sloupec
  P6DIR = 0xF0; // 1111 0000 9-10 sloupec (FIXME: nepouzivane porty)
  P2OUT = 0x02; // fix
  P4OUT = 0x3f;
  int tmp = 0;

  // radek
  for(i = 0; i < 7; i++)
  {
    // Aktivace jednotlivych radku
    if(i < 6)
    {
      tmp = 0x20 >> i;
      P4OUT ^= tmp;
    }
    else
      P2OUT = 0x00;

    // sloupec
    for(j = 0; j < 10; j++)
    {
      // Naplneni pole na tisk
      print = print << 1;
      if(display [i][j])
          print |= 0x10;
      if(j == 3)
      {
        P2OUT |= print;
        print = 0;
      }
      else if(j == 7)
      {
        P1OUT = print;
        print = 0;
      }
    }
    P6OUT = print;

    // Vytiskne na display
    LED_delay();

    // Reset hodnot
    print = 0;
    P2OUT = 0x02;
    P4OUT = 0x3f;
  }
}

typedef struct{
  int y;                             // y souradnice koule
  int x;                             // x souradnice koule
  int dir_y;                         // smer koule nahoru || dolu
  int dir_x;                         // smer koule doprava || doleva
} TKoule;

typedef struct{
  int a;
  int b;
  int c;
} TDeska;

// smycka hry
int game_loop()
{
  TKoule koule = {5,5,-1,1}; // pocatecni hodnoty
  TDeska deska = {4,5,6};
  unsigned int i = 0;
  int state = 0;
  int new_x;
  int new_y;
  int cihly = 0;
  char ch;
  for(;;)
  {
    // Posun koule co 0.5s cca.
    //if(i >= 142)
    if(i >= 100)
    {
      new_x = koule.x + koule.dir_x;
      new_y = koule.y + koule.dir_y;

      // Hranice plochy, osa x
      if(new_x < 0 || new_x >= D_WIDTH)
      {
        koule.dir_x *= -1;
        new_x = koule.x + koule.dir_x;
      }

      // Hranice plochy, osa y
      if(new_y < 0)
      {
        koule.dir_y *= -1;
        new_y = koule.y + koule.dir_y;
      }
      if(new_y >= D_HEIGHT)
        return 0;

sejmiCihlu: // a studenta ktery pouziva goto.. 
      if(display[new_y][new_x] == P_CIHLA) // if is too mainstream
      {
        // Odraz zpatky
        //   xx|   xx|     |         | xxxx| xxxx| xx  |
        //     |  *  |     |     OR  |   xx|  *xx|   xx|
        // *   |     | *   |         | *   |     | *   |
        if(display[new_y][koule.x] == display[koule.y][new_x])
        {
          // smer koule
          koule.dir_x *= -1;
          koule.dir_y *= -1;
          // vymazani cihly
          display[new_y][new_x] = P_NIC;
          if(new_x % 2)
            display[new_y][new_x-1] = P_NIC;
          else
            display[new_y][new_x+1] = P_NIC;
        }
        // Odraz o stenu
        //    xx|    xx|  * xx|      |     |     |   * |
        //    xx|   *xx|      |  !!! |   xx|  *xx|   xx|
        //  *   |      |      |      | *   |     |     |
        else if(display[new_y][koule.x] == P_NIC)
        {
          // smer koule
          koule.dir_x *= -1;
          // vymazani cihly
          display[koule.y][new_x] = P_NIC;
          if(new_x % 2)
            display[koule.y][new_x-1] = P_NIC;
          else
            display[koule.y][new_x+1] = P_NIC;
        }
        // Odraz o cihlu
        // xxxx|xxxx|  xx|
        //     | *  |    |
        // *   |    |  * |
        else
        {
          // smer koule
          koule.dir_y *= -1;
          // vymazani cihly
          display[new_y][koule.x] = P_NIC;
          if(koule.x % 2)
            display[new_y][koule.x-1] = P_NIC;
          else
            display[new_y][koule.x+1] = P_NIC;
        }
        new_x = koule.x + koule.dir_x;
        new_y = koule.y + koule.dir_y;
        if(D_HEIGHT-2 != koule.y)
          cihly++;
        if(cihly == 10)
          return 1;
      }

      display[D_HEIGHT-1][deska.a] = P_CIHLA;
      display[D_HEIGHT-1][deska.b] = P_CIHLA;
      display[D_HEIGHT-1][deska.c] = P_CIHLA;

      // Hranice plochy, osa x
      if(new_x < 0 || new_x >= D_WIDTH)
      {
        koule.dir_x *= -1;
        new_x = koule.x + koule.dir_x;
      }

      // Hranice plochy, osa y
      if(new_y < 0)
      {
        koule.dir_y *= -1;
        new_y = koule.y + koule.dir_y;
      }
      if(new_y >= D_HEIGHT-1)
        return 0;

      display[koule.y][koule.x] = P_NIC;
      koule.x = new_x;
      koule.y = new_y;
      display[koule.y][koule.x] = P_KOULE;
      i=0;
    }
    i++;
    // Klavesnice??
    if(! (i % 14))
    {
      ch = key_decode(read_word_keyboard_4x4());
      LED_delay();// nejaky zpozdeni
      if (ch == key_decode(read_word_keyboard_4x4()))
      {
        if(ch == '4')
        {
          if(deska.a > 0)
          {
            display[D_HEIGHT-1][deska.a] = P_NIC;
            display[D_HEIGHT-1][deska.b] = P_NIC;
            display[D_HEIGHT-1][deska.c] = P_NIC;
            deska.a--;
            deska.b--;
            deska.c--;
            display[D_HEIGHT-1][deska.a] = P_CIHLA;
            display[D_HEIGHT-1][deska.b] = P_CIHLA;
            display[D_HEIGHT-1][deska.c] = P_CIHLA;
          }
        }
        else if(ch == '6')
        {
          if(deska.c < D_WIDTH-1)
          {
            display[D_HEIGHT-1][deska.a] = P_NIC;
            display[D_HEIGHT-1][deska.b] = P_NIC;
            display[D_HEIGHT-1][deska.c] = P_NIC;
            deska.a++;
            deska.b++;
            deska.c++;
            display[D_HEIGHT-1][deska.a] = P_CIHLA;
            display[D_HEIGHT-1][deska.b] = P_CIHLA;
            display[D_HEIGHT-1][deska.c] = P_CIHLA;
          }
        }
      }
    }

    LED_draw(); // 3.5ms
  }
}

/**
 * Hlavni funkce
 */
int main(void) {      

  initialize_hardware();
  WDG_stop();                          // Kill the dog
  LCD_init();                          // Init LCD
  LCD_clear();
  keyboard_init();                     // Init klavesnice
  for(;;) // might be faster than while(1)
  {
    LCD_append_string("Arkanoid        Press 5 to start");
    while(! press5());
    LCD_clear();
    LCD_append_string("Good luck       Have fun");
    delay_ms(100);
    LED_init();
    if(game_loop())
    {
      LCD_clear();
      LCD_append_string("You won! GRATZ  Press 5");
    }
    else
    {
      LCD_clear();
      LCD_append_string("You lost!       Press 5");
    }
    while(! press5());
  }
  
}
