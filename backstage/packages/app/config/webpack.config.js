module.exports = (config, { env }) => {
  if (env === 'development') {
    // Configurar webpack dev server para escuchar en todas las interfaces
    config.devServer = {
      ...config.devServer,
      host: '0.0.0.0',
      port: 3000,
      allowedHosts: 'all',
      client: {
        webSocketURL: 'auto://0.0.0.0:0/ws'
      }
    };
  }
  return config;
};
