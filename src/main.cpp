#include <iostream>

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>

auto main() -> int {

    cv::Mat img;
    cv::VideoCapture capture{2, cv::CAP_V4L2};

    if (!capture.isOpened()) {
        throw std::runtime_error("Err: Unable to open video capture.");
    }

    double rate = capture.get(cv::CAP_PROP_FPS);
    cv::Mat frame;

    auto delay = 1000 / rate;
    auto stop(false);
    while (!stop) {
        if (!capture.read(frame)) {
            std::cout << "no video frame" << std::endl;
            break;
        }

        cv::imshow("video", frame);
        if (cv::waitKey(static_cast<int>(delay)) > 0) {
            stop = true;
        }
    }

    capture.release();

    return 0;
}