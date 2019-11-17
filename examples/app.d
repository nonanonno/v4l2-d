import std.stdio;
import core.sys.posix.unistd;
import core.sys.posix.fcntl;
import core.sys.posix.sys.ioctl;
import v4l2.videodev2;
import core.stdc.errno;
import std.string;
import core.sys.posix.sys.mman;
import core.sys.posix.sys.select;
import core.stdc.string;

int xioctl(int fd, int req, void* arg) {
	int r;
	do {
		r = ioctl(fd, req, arg);
		if (req == VIDIOC_DQBUF) {
			writefln("r : %d", r);
		}
	}
	while (r == -1 && errno == EINTR);
	return r;
}

void main(string[] args) {
	enum width = 640;
	enum height = 480;

	immutable fd = open(toStringz(args[1]), O_RDWR);
	assert(fd != -1);
	scope (exit)
		close(fd);

	// QUery video capabilities
	v4l2_capability caps;
	assert(xioctl(fd, VIDIOC_QUERYCAP, &caps) != -1);
	writeln("bus_info : ", fromStringz(cast(char*) caps.bus_info));
	writeln("card     : ", fromStringz(cast(char*) caps.card));
	writeln("driver   : ", fromStringz(cast(char*) caps.driver));
	writeln("version  : ", caps.version_);

	// Format specification
	v4l2_format fmt;
	fmt.type = v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE;
	fmt.fmt.pix.width = width;
	fmt.fmt.pix.height = height;
	fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
	fmt.fmt.pix.field = v4l2_field.V4L2_FIELD_NONE;
	assert(xioctl(fd, VIDIOC_S_FMT, &fmt) != -1);

	// Request buffer
	v4l2_requestbuffers req;
	req.count = 1;
	req.type = v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE;
	req.memory = v4l2_memory.V4L2_MEMORY_MMAP;
	assert(xioctl(fd, VIDIOC_REQBUFS, &req) != -1);

	// Query buffer
	v4l2_buffer buf;
	buf.type = v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE;
	buf.memory = v4l2_memory.V4L2_MEMORY_MMAP;
	buf.index = 0;
	assert(xioctl(fd, VIDIOC_QUERYBUF, &buf) != -1);
	writefln("%dx%d", fmt.fmt.pix.width, fmt.fmt.pix.height);
	writeln("buf.length   : ", buf.length);
	writeln("buf.m.offset : ", buf.m.offset);
	auto buffer = cast(ubyte*) mmap(null, buf.length, PROT_READ | PROT_WRITE,
			MAP_SHARED, fd, buf.m.offset);

	// Start streaming
	buf.type = v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE;
	assert(xioctl(fd, VIDIOC_STREAMON, &buf.type) != -1);
	scope (exit)
		xioctl(fd, VIDIOC_STREAMOFF, &buf.type);

	// Capture image
	while (true) {
		assert(xioctl(fd, VIDIOC_QBUF, &buf) != -1);
		fd_set fds;
		FD_ZERO(&fds);
		FD_SET(fd, &fds);
		timeval tv;
		tv.tv_sec = 2;
		immutable r = select(fd + 1, &fds, null, null, &tv);
		assert(r != -1);
		buf = v4l2_buffer.init;
		buf.type = v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE;
		buf.memory = v4l2_memory.V4L2_MEMORY_MMAP;

		assert(xioctl(fd, VIDIOC_DQBUF, &buf) != -1);

		auto image = new ubyte[buf.length];
		writeln(image.length);
		memcpy(image.ptr, buffer, buf.length);

		foreach (y; 0 .. 10) {
			foreach (x; 0 .. 10) {
				writef("%4d", image[x + y * width]);
			}
			writeln();
		}
		break;
	}
}
