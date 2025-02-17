// mergeSort.cpp : Этот файл содержит функцию "main". Здесь начинается и заканчивается выполнение программы.
//
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>

void mergeSort(int* arr, int l, int r, int (*compare)(int, int)) {
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
    k = l;
    while (i < ln && j < rn) {
        if (compare(ls[i], rs[j]) <= 0) {
            arr[k++] = ls[i++];
        } else {
            arr[k++] = rs[j++];
        }
    }
    while (i < ln) arr[k++] = ls[i++];
    while (j < rn) arr[k++] = rs[j++];


    free(rs);
    free(ls);
}

int compator(int a, int b) {
    return a - b;
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

// Запуск программы: CTRL+F5 или меню "Отладка" > "Запуск без отладки"
// Отладка программы: F5 или меню "Отладка" > "Запустить отладку"

// Советы по началу работы 
//   1. В окне обозревателя решений можно добавлять файлы и управлять ими.
//   2. В окне Team Explorer можно подключиться к системе управления версиями.
//   3. В окне "Выходные данные" можно просматривать выходные данные сборки и другие сообщения.
//   4. В окне "Список ошибок" можно просматривать ошибки.
//   5. Последовательно выберите пункты меню "Проект" > "Добавить новый элемент", чтобы создать файлы кода, или "Проект" > "Добавить существующий элемент", чтобы добавить в проект существующие файлы кода.
//   6. Чтобы снова открыть этот проект позже, выберите пункты меню "Файл" > "Открыть" > "Проект" и выберите SLN-файл.
