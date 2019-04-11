sh fdx_patchejbdeploy.sh
sudo -u wasadmin bash << EOF
  whoami
  sh with_version_maven_fdxStageBuild_devops.sh 8.2.2 test
  cd /home/wasadmin/bin/PatchScheduler_dyn/
  ./maven_devdeploy.sh 8.2.2 FDX_BRN_DEV_8_2_2 FDXPRF1 HTTPServer fdxnjdevant2Node01Cell
  whoami
EOF
