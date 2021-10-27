require(
    ['jquery', 'miaps', 'miapswp', 'miapspage'],
    function ($, miaps, miapsWp, miapsPage) {
        function init() {
            $('#btnBack').on('click', function () {
                miapsPage.back()
            })

            $('#btnUpload').on('click', service.fileUpload)
        }

        var service = {
            fileUpload: function () {
                var config = {
                    type: "fileupload",
                    param: {
                        params: {
                            userCd: "CW5887",
                            workReportId: "22518",
                            attachFileInfo: [
                                {
                                    fileName: "git-logo.png",
                                    atchOrder: "0",
                                    type: "A",
                                    photoItemCd: "P001",
                                    ptgrpDt: "2021-07-28",
                                    ptgrpCrd: "37.57295,126.98448",
                                    safeRejtYn: "Y",
                                    safeRejtRsnCd: "기타"
                                },
                                {
                                    fileName: "ipsum-logo.png",
                                    atchOrder: "1",
                                    type: "A",
                                    photoItemCd: "P002",
                                    ptgrpDt: "2021-07-28",
                                    ptgrpCrd: "37.57295,126.98448",
                                    safeRejtYn: "Y",
                                    safeRejtRsnCd: "촬영불가"
                                }
                            ]
                        },
                        files: [
                            {path: '/Volumes/DataDisk/_98_SampleAsset/_01_img/_0_logo/git-logo.png'},
                            {path: '/Volumes/DataDisk/_98_SampleAsset/_01_img/_0_logo/ipsum-logo.png'}
                        ],
                        pathname: '/minkSvc'
                    },
                    callback: "_cb.cbUpload"
                };

                // renderRequestInfo(config);

//                renderRequestParams(config);

                miaps.mobile(config, _cb.cbUpload);
            }
        }

        var _cb = {
            cbUpload: function (data) {
                var obj = miaps.parse(data)
                console.log(obj)
            }
        }

        init()
    })