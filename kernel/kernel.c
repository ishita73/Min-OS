void main() {
    char* video_memory = (char*) 0xB8000;
    *video_memory = 'H';
    video_memory++;
    *video_memory = 0x07;
    *video_memory++ = 'i';
    *video_memory = 0x07;
}