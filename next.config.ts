import { createVanillaExtractPlugin } from "@vanilla-extract/next-plugin";
import { NextConfig } from "next";

const withVanillaExtract = createVanillaExtractPlugin({});

const nextConfig: NextConfig = {
  typedRoutes: true,
  images: { qualities: [75, 100] },
};

export default withVanillaExtract(nextConfig);
