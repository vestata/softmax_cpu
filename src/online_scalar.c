#include "softmax.h"

void softmax_online_scalar(const float *input, float *output, int size)
{
    float m_prev = -FLT_MAX;
    float d = 0.0f;

    float m_curr;

    for (int j = 0; j < size; j++) {
        float xj = input[j];
        m_curr = fmaxf(m_prev, xj);
        d = expf(m_prev - m_curr) * d + expf(xj - m_curr);
        m_prev = m_curr;
    }

    for (int i = 0; i < size; i++) {
        output[i] = expf(input[i] - m_curr) / d;
    }
}
