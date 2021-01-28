void dummy_test_entrypoint()
{

}

void main()
{
    short* video_memory = (char*)0xb8000;
    *video_memory = (0x07 << 8) | 'X';
    for (;;);
}