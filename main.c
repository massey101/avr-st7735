#include<avr/io.h>
#include<util/delay.h>

#include "spi.h"
#include "st7735.h"
#include "st7735_gfx.h"
#include "st7735_font.h"

#include "test_bw.h"
#include "test_colour.h"
#include "tom_thumb.h"

int main(void) {
    spi_init();
    st7735_init();

    st7735_set_orientation(ST7735_LANDSCAPE);

    // Reset with all white
    st7735_fill_rect(0, 0, 128, 128, ST7735_COLOR_WHITE);

    // Draw title
    st7735_draw_text(
        5,
        12,
        "ST7735 AVR Library",
        &TomThumb,
        1,
        ST7735_COLOR_BLACK
    );
    st7735_draw_line(5, 13, 70, 13, ST7735_COLOR_BLACK);
    st7735_draw_line(5, 15, 70, 15, ST7735_COLOR_BLACK);

    // Draw bitmap examples
    st7735_draw_text(5, 30, "bitmaps:", &TomThumb, 1, ST7735_COLOR_BLACK);
    st7735_draw_mono_bitmap(
        45,
        25,
        (PGM_P) test_bw,
        ST7735_COLOR_WHITE,
        ST7735_COLOR_BLACK
    );
    st7735_draw_bitmap(80, 25, (PGM_P) test_colour);

    // Draw circle example
    st7735_draw_text(5, 72, "Circles:", &TomThumb, 1, ST7735_COLOR_BLACK);
    st7735_draw_circle(45, 69, 5, ST7735_COLOR_RED);

    // Draw line example
    st7735_draw_text(5, 93, "Lines:", &TomThumb, 1, ST7735_COLOR_BLACK);
    for(uint8_t y = 85; y <= 95; y += 5) {
        st7735_draw_line(35, 90, 80, y, ST7735_COLOR_GREEN);
    }

    // Draw rectangle examples
    st7735_draw_text(5, 112, "Rectangles:", &TomThumb, 1, ST7735_COLOR_BLACK);
    st7735_draw_rect(55, 105, 10, 10, ST7735_COLOR_BLACK);
    st7735_fill_rect(70, 105, 10, 10, ST7735_COLOR_BLUE);

    while(1);
}
