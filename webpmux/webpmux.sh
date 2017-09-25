#!/bin/bash

:<<!
从动态的WebP文件中获取到每一帧webp图像，并且解压成png和jgp格式图像。
步骤：
1.将所有动态webp文件拷贝到images文件夹下。
2.终端运行 sh webp.sh images
!

if [[ $1 ]]; then
	path=`pwd`/$1 #指定文件夹路径
	results=`ls $path | grep '.webp$'` #获得所有.webp结尾的文件名
	for result in $results
	do 
		file=$path/$result #获得每个webp文件的路径
		if test -f $file #判断是否是文件
		then 
			dirpath=$path/${result%.webp} #要创建的文件夹路径
			webppath=$dirpath/webp
			pngpath=$dirpath/png
			jpgpath=$dirpath/jpg
			`mkdir $dirpath`
			`mkdir $webppath`
			`mkdir $pngpath`
			`mkdir $jpgpath`
			i=0
			while(($i>=0))
			do
				i=$(($i+1))

				webpframe=$webppath/${result%.webp}$i.webp
				`webpmux -get frame $i $file -o $webpframe`

				if (test -f $webpframe) #判断是否已经获取到所有帧了
				then #用webp生成png图片
					pngframe=$pngpath/${result%.webp}$i.png
					jpgframe=$jpgpath/${result%.webp}$i.jpg
					`dwebp $webpframe -o $pngframe`
					`dwebp $webpframe -o $jpgframe`
				else 
					if (($i == 1)) #如果第一帧有生成，则说明是动态webp，如果第一帧没有生成则说明不是动态webp
					then #不是动态webp文件时，删除创建的文件夹
						`rm -r $dirpath`
					fi
					break
				fi
			done
		fi
	done
else
	echo 没有指定文件夹
fi