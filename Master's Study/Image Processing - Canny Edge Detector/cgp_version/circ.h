#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

int parsefile(const char* fname_in, const char* fname_out, int* data, int* par_inputs, int* par_outputs)
{

    cv::Mat img_in = cv::imread( fname_in );
    int result = 
       img_in.rows*img_in.cols*10;
    if(! data){
      return result;
    }
    cv::Mat tmp, img_out;
    printf("fname_in %s\n", fname_in);
    printf("fname_out %s\n", fname_out);
    cv::cvtColor( img_in, tmp, CV_BGR2GRAY );
    copyMakeBorder( tmp, img_in, 1,1,1,1, cv::BORDER_REPLICATE );

    tmp = cv::imread(fname_out);
    cv::cvtColor( tmp, img_out, CV_BGR2GRAY );
    unsigned char *output = (unsigned char*)(img_out.data);
    unsigned char *input = (unsigned char*)(img_in.data);
    int* dataptr= data;
    for(int j = 0;j < img_out.rows;j++){
        for(int i = 0;i < img_out.cols;i++){
            for(int x = 0; x < 3; x++){
              for(int y = 0; y < 3; y++){
                *dataptr = img_in.at<unsigned char>(x+j, y+i);
                dataptr++;
              }
            }
            *dataptr = img_out.at<unsigned char>(j, i);
            dataptr++;
        }
    }
    if (par_inputs != 0) *par_inputs = 9;
    if (par_outputs != 0) *par_outputs = 1;

    return result;
}
