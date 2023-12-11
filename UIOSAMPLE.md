### UIO Sample

Following is the normal c source code sample.  
So if you want to use UIO from Nerves, you need to write as NIF.

see also. https://www.kernel.org/doc/html/v5.15/driver-api/uio-howto.html

```c
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>

/* we can check this size by `cat /sys/class/uio/uioX/maps/map0/size` */
#define SIZE 0x10000

#define AXI_GPIO_LED "/dev/uio0"
#define AXI_GPIO_SW_BTN "/dev/uio1"
#define PWM_RGB "/dev/uio4"

/* see. https://docs.xilinx.com/v/u/en-US/pg144-axi-gpio Register Space */
#define GPIO_DATA_ADDR_OFFSET 0x0000
#define GPIO_DATA2_ADDR_OFFSET 0x0008

/* see. https://github.com/Digilent/libpwm/blob/master/libpwm.h */
#define PWM_CTRL_OFFSET         0x0000
#define PWM_PERIOD_OFFSET       0x0008
#define PWM_DUTY_OFFSET         0x0040

int main() {
  int fd;
  fd = open(AXI_GPIO_LED, O_RDWR);
  if (fd < 0) {
    return -1;
  }

  void *led_addr = mmap(NULL, SIZE, PROT_WRITE, MAP_SHARED_VALIDATE, fd, 0);
  close(fd);

  if (led_addr == MAP_FAILED) {
    return -1;
  }

  fd = open(AXI_GPIO_SW_BTN, O_RDWR);
  if (fd < 0) {
    return -1;
  }

  void *sw_btn_addr = mmap(NULL, SIZE, PROT_READ, MAP_SHARED_VALIDATE, fd, 0);
  close(fd);

  if (sw_btn_addr == MAP_FAILED) {
    return -1;
  }

  fd = open(PWM_RGB, O_RDWR);
  if (fd < 0) {
    return -1;
  }

  void *pwm_addr = mmap(NULL, SIZE, PROT_WRITE, MAP_SHARED_VALIDATE, fd, 0);
  close(fd);

  if (pwm_addr == MAP_FAILED) {
    return -1;
  }

  uint32_t sw_bits = *(uint32_t *)(sw_btn_addr + GPIO_DATA_ADDR_OFFSET);
  int sw0, sw1, sw2, sw3;
  sw0 = (sw_bits & 0x01) >> 0;
  sw1 = (sw_bits & 0x02) >> 1;
  sw2 = (sw_bits & 0x04) >> 2;
  sw3 = (sw_bits & 0x08) >> 3;

  uint32_t btn_bits = *(uint32_t *)(sw_btn_addr + GPIO_DATA2_ADDR_OFFSET);
  int btn0, btn1, btn2, btn3;
  btn0 = (btn_bits & 0x01) >> 0;
  btn1 = (btn_bits & 0x02) >> 1;
  btn2 = (btn_bits & 0x04) >> 2;
  btn3 = (btn_bits & 0x08) >> 3;

  printf("sw = %d%d%d%d\n", sw3, sw2, sw1, sw0);
  printf("btn = %d%d%d%d\n", btn3, btn2, btn1, btn0);

  *(uint32_t *)(led_addr + GPIO_DATA_ADDR_OFFSET) = sw_bits | btn_bits;

  *(uint32_t *)(pwm_addr + PWM_CTRL_OFFSET)   = sw3;
  *(uint32_t *)(pwm_addr + PWM_PERIOD_OFFSET) = 10;
  *(uint32_t *)(pwm_addr + PWM_DUTY_OFFSET   + (4 * 2)) = sw2;
  *(uint32_t *)(pwm_addr + PWM_DUTY_OFFSET   + (4 * 1)) = sw1;
  *(uint32_t *)(pwm_addr + PWM_DUTY_OFFSET   + (4 * 0)) = sw0;

  munmap(sw_btn_addr, SIZE);
  munmap(led_addr, SIZE);
  return 0;
}
```
