//C-Program for DOT MATRIX DISPLAY Clock
//16 MHz Clock frequency, ATMEGA 8 Microcontroller
//                           C1 C2 C3 C4 C5    C1 C2 C3 C4 C5
//BIT0 = ROW1           *    *                 0    1    1   0   0
//BIT1 = ROW2      *               *           1     0    0   1  0
//BIT2 = ROW3      *               *           1     0    0   1  0
//BIT3 = ROW4      *               *           1     0    0   1  0
//BIT4 = ROW5      *               *           1     0    0   1  0
//BIT5 = ROW6      *               *            1    0    0   1  0
//BIT6 = ROW7            *   *                  0    1    1   0  0
//characters for column common cathode and row anode
char number_font1[10][5] = {
    //Rows data by enabling single column
    // C1   C2   C3   C4   C5   R1==D0 -- R7==D6
    {0X3E, 0X41, 0X41, 0X3E, 0X00}, //0
    {0X44, 0X42, 0X7F, 0X40, 0X00}, //1
    {0X62, 0X51, 0X49, 0X46, 0X00}, //2
    {0X41, 0X49, 0X4D, 0X32, 0X00}, //3
    {0X18, 0X14, 0X12, 0X7F, 0X00}, //4
    {0X4F, 0X49, 0X49, 0X31, 0X00}, //5
    {0X3E, 0X49, 0X49, 0X32, 0X00}, //6
    {0X01, 0X01, 0X79, 0X07, 0X00}, //7
    {0X36, 0X49, 0X49, 0X36, 0X00}, //8
    {0X26, 0X49, 0X49, 0X3E, 0X00}, //9
};

char i = 0, j, k, flag = 0, temp, time[6] = {1, 2, 0, 0, 0, 0}, rowdata[32], shift, frame = 0;
char separator = 0, position, set = 0, rtc_reg[8];

void framing(void);
void set_framing(void);

void twi_strt(void);
void twi_stp(void);
void set_time(void);
void read_time(void);

void change() iv IVT_ADDR_INT0 ics ICS_AUTO
{
    if ((PIND & 0X07) == 0X03) //If set/change button alone is pressed
    {
        set++;        //Initially set=0
        if (set == 1) //Button is pressed for the first time so change time
        {
            GICR = 0X40;
            time[0] = 1;
            time[1] = 0;
            time[2] = 1;
            time[3] = 0;
            time[4] = 1;
            time[5] = 0;
            set_framing();
        }
        else //Button is pressed for the second time so time is set
        {
            rtc_reg[0] = time[4] * 0X10 + time[5];
            rtc_reg[1] = time[2] * 0X10 + time[3];
            rtc_reg[2] = (time[0] & 0X07) * 0X10 + time[1];
            framing();
            set_time();
            position = 0;
            set = 0;
            GICR = 0XC0;
        }
    }
    else if ((PIND & 0X07) == 0X01) //If Shift button is pressed
    {
        if (set == 1) //Avoiding un wanted operation if shift key is pressed
        {
            position++;    //Increment position variable
            set_framing(); //Go to set framing function
        }
    }
    else if ((PIND & 0X07) == 0X02)
    {
        if (set == 1) //Avoiding un wanted operation if adjust key is pressed
        {
            switch (position)
            {
            case 0:
            {              //thrs in 12 hrs format
                time[0]++; //Ten hours will be either 0 or 1
                time[0] %= 2;
            }
            break;
            case 1:
            {                     //hrs in 12 hrs format
                time[1]++;        //Depending on ten hours value
                if (time[0] == 0) //Limit hours value
                {
                    time[1] %= 10;
                }
                else
                {
                    time[1] %= 3;
                }
            }
            break;
            case 2:
            {              //tmint
                time[2]++; //Ten minutes value will be 0 to 5
                time[2] %= 6;
            }
            break;
            case 3:
            { //mint
                time[3]++;
                time[3] %= 10;
            }
            break;
            case 4:
            { //tsec            //Ten seconds value will be 0 to 5
                time[4]++;
                time[4] %= 6;
            }
            break;
            case 5:
            { //sec
                time[5]++;
                time[5] %= 10;
            }
            break;
            }
            set_framing(); //Go to set framing with the updated values
        }
    }
}

void rtc() iv IVT_ADDR_INT1 ics ICS_AUTO
{
    SREG_I_BIT = 0;
    GICR = 0X00;
    separator++;
    separator %= 2;
    read_time();
    framing();
    GICR = 0XC0;
    SREG_I_BIT = 1;
}

void spi() iv IVT_ADDR_SPI__STC ics ICS_AUTO
{
    flag = 1;
}

void main()
{
    PORTB = 0XFF; //Declaring PORTB as output port with high initial values
    DDRB = 0XFF;

    PORTD = 0XFF; //Declaring PORTD as Input port with Pulled Up inputs
    DDRD = 0X00;

    DDRC = 0XFF;

    MSTR_BIT = 1; //Enabling master mode of SPI
    SPE_BIT = 1;  //Enabling SPI
    SPIE_BIT = 1; //Enable SPI Interrupt

    TWBR = 0X48; //TWI Baud rate

    read_time();

    framing();
    rtc_reg[7] = 0X10;
    set_time();
    PORTC0_BIT = 1; //Issue clock signal to decade counter
    Delay_us(5);
    PORTC0_BIT = 0;
    MCUCR = 0X0A;
    GICR = 0XC0;
    SREG_I_BIT = 1;
    Delay_us(5);
    shift = 4;
    while (1)
    {
        //Negation of row data is because, we are using Column anode in proteus

        SPDR = ~rowdata[8 * (shift - 1) + frame];
        do
        {
        } while (flag == 0); //Wait TX Complete interrupt
        flag = 0;
        shift--;        //According to logic Hint:8*4=32 columns
        if (shift == 0) //So shift is run from 4 to 1
        {               //4-Bytes of data should be sent for each frame
            shift = 4;
            frame++; //Increment the frame

            PORTB1_BIT = 1; //Enable output
            Delay_ms(2);    //Wait this can be varied
            PORTB1_BIT = 0; //Disable outputs of registers
            PORTB0_BIT = 0; //Issue clock signal to decade counter
            Delay_us(5);
            PORTB0_BIT = 1;
            if (frame == 8)
            {
                frame = 0;      //frame runs from 0 to 7
                PORTC0_BIT = 1; //Issue master reset signal to decade counter
                Delay_us(5);
                PORTC0_BIT = 0;
            }
        }
    }
}

void framing(void)
{
    char i, j, k;
    for (i = 0, j = 0, k = 0; i <= 31; i++)
    {
        if ((i != 10) && (i != 21))
        {
            rowdata[i] = number_font1[time[j]][k];
            k++;
            if (k == 5)
            {
                j++;
                k = 0;
            }
        }
        else
        {
            if (separator == 0)
            {
                rowdata[i] = 0X14;
            }
            else
            {
                rowdata[i] = 0X00;
            }
        }
    }
}

void set_framing(void)
{
    char i, j, k, l;
    switch (position)
    {
    case 0:
    {
        l = 4;
    }
    break;
    case 1:
    {
        l = 9;
    }
    break;
    case 2:
    {
        l = 15;
    }
    break;
    case 3:
    {
        l = 20;
    }
    break;
    case 4:
    {
        l = 26;
    }
    break;
    case 5:
    {
        l = 31;
    }
    break;
    }
    for (i = 0, j = 0, k = 0; i <= l; i++)
    {
        if ((i != 10) && (i != 21))
        {
            rowdata[i] = number_font1[time[j]][k];
            k++;
            if (k == 5)
            {
                j++;
                k = 0;
            }
        }
        else
        {
            rowdata[i] = 0X00;
        }
    }
    for (i = l + 1, j = 0, k = 0; i <= 31; i++)
    {
        if ((i != 10) && (i != 21))
        {
            rowdata[i] = 0X00;
            k++;
            if (k == 5)
            {
                j++;
                k = 0;
            }
        }
        else
        {
            rowdata[i] = 0X00;
        }
    }
}

void twi_strt(void)
{
    TWCR = 0XA4; //send start command
    do
    {
    } while (TWINT_BIT == 0); //wait untill TX complete falg is set
}

void twi_stp(void)
{
    TWCR = 0X94;
    do
    {
    } while (TWINT_BIT == 1);
    Delay_us(15);
}

void set_time(void)
{
    rtc_reg[temp] = 0X10;
    twi_strt();

    TWDR = 0XD0; //send RTC Address
    TWCR = 0X84;
    do
    {
    } while (TWINT_BIT == 0); //wait untill TX complete falg is set

    TWDR = 0X00; //send register address
    TWCR = 0X84;
    do
    {
    } while (TWINT_BIT == 0); //wait untill TX complete falg is set

    for (temp = 0; temp <= 7; temp++)
    {
        TWDR = rtc_reg[temp];
        TWCR = 0X84;
        do
        {
        } while (TWINT_BIT == 0); //wait untill TX complete falg is set
    }
}

void read_time(void)
{
    char temp_read;
    for (temp_read = 0; temp_read <= 2; temp_read++)
    {
        twi_strt();  // issue TWI start signal
        TWDR = 0XD0; // send byte via TWI (device address + Write)
        TWCR = 0X84;
        do
        {
        } while (TWINT_BIT == 0);
        TWDR = temp_read; //Send address of the byte to be read
        TWCR = 0X84;
        do
        {
        } while (TWINT_BIT == 0);
        twi_strt();
        TWDR = 0XD1; // send byte (device address + Read)
        TWCR = 0X84;
        do
        {
        } while (TWINT_BIT == 0);
        TWEA_BIT = 0; // read data (NO acknowledge)
        do
        {
        } while (TWINT_BIT == 0); //wait until data byte is received
        rtc_reg[temp_read] = TWDR;
        twi_stp();
    }
    //Issuing register values to time variables
    for (temp_read = 0; temp_read <= 5; temp_read++)
    {
        if ((temp_read % 2) == 0)
        {
            time[5 - temp_read] = rtc_reg[temp_read / 2] % 16;
        }
        else
        {
            time[5 - temp_read] = rtc_reg[temp_read / 2] / 16;
        }
    }
}
