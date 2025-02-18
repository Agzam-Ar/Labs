#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>

void mergeSort(int* arr, int l, int r, int (*compare)(int*, int, int*, int*, int*, int*, int, int)) {
    if (l >= r) return;

    int middle = l + ((r - l) / 2);

    mergeSort(arr, l, middle, compare);
    mergeSort(arr, middle + 1, r, compare);

    int ln = middle - l + 1;
    int rn = r - middle;

    int* ls = malloc(sizeof(int) * ln);
    int* rs = malloc(sizeof(int) * rn);

    int i, j, k;

    for (i = 0; i < ln; i++) ls[i] = arr[l + i];
    for (i = 0; i < rn; i++) rs[i] = arr[middle + 1 + i];

    i = j = 0;
    k = compare(arr, l, rs, ls, &i, &j, ln, rn);
    printf("%d %d\n", i, j);
    while (i < ln) arr[k++] = ls[i++];
    while (j < rn) arr[k++] = rs[j++];

    free(rs);
    free(ls);
}

int compator(int* arr, int k, int* rs, int* ls, int* ip, int* jp, int ln, int rn) {
    int i = *ip;
    int j = *jp;
    while (i < ln && j < rn) {
        if (ls[i] < rs[j]) {
            arr[k++] = ls[i++];
        } else {
            arr[k++] = rs[j++];
        }
    }
    (*ip) = i;
    (*jp) = j;
    return k;
}

int main() {
    FILE* input = fopen("input.txt", "r");
    int n;
    fscanf(input, "%d", &n);
    int* arr = malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) fscanf(input, "%d", &arr[i]);
    printf("\n");
    fclose(input);
    mergeSort(arr, 0, n - 1, &compator);
    FILE* output = fopen("output.txt", "w+");
    for (int i = 0; i < n; i++) fprintf(output, "%d ", arr[i]);
    fclose(output);

}
