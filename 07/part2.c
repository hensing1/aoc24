#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

unsigned long get_num(char* line, char* index);

char dfs(unsigned long* list, unsigned long target, unsigned long sum, char index, char max);
char num_digits(unsigned long n);
unsigned long concat(unsigned long a, unsigned long b);

int main() {
    char line[50];
    unsigned long sum = 0;
    do {
        unsigned long target;
        unsigned long* nums = malloc(16 * sizeof(unsigned long));

        memset(line, 0, sizeof line);
        fgets(line, sizeof line, stdin);


        char index = 0;
        target = get_num(line, &index);

        index++;

        char num_count = 0;
        while(line[index] == ' ') {
            index++;
            nums[num_count] = get_num(line, &index);
            num_count++;
        }
        line[index] = '\0';

        if (dfs(nums, target, nums[0], 1, num_count)) {
            sum += target;
        }
    } while (line[0] != '\0');
    printf("%lu\n", sum);
    return 0;
}

unsigned long concat(unsigned long a, unsigned long b) {
    for (int i = 0; i < num_digits(b); i++) {
        a *= 10;
    }
    return a + b;
}

char num_digits(unsigned long n) {
    char d = 0;
    while (n != 0) {
        d++;
        n /= 10;
    }
    return d;
}

unsigned long get_num(char* line, char* index) {
    unsigned long num = 0;

    int digit = line[*index] - '0';
    while (0 <= digit && digit <= 9) {
        num *= 10;
        num += digit;

        (*index)++;
        digit = line[*index] - '0';
    }

    return num;
}


char dfs(unsigned long* list, unsigned long target, unsigned long sum, char index, char list_len) {

    if (index == list_len) {
        return sum == target;
    }

    if (sum > target) {
        return 0;
    }

    char plus = dfs(list, target, sum + list[index], index + 1, list_len);
    if (plus) {
        return 1;
    }

    char times = dfs(list, target, sum * list[index], index + 1, list_len);
    if (times) {
        return 1;
    }

    char conc = dfs(list, target, concat(sum, list[index]), index + 1, list_len);
    return conc;
}
