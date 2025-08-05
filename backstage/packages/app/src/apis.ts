import { ScmIntegrationsApi, scmIntegrationsApiRef } from '@backstage/integration-react';
import {
  AnyApiFactory,
  configApiRef,
  createApiFactory,
  discoveryApiRef,
  fetchApiRef,
  identityApiRef,
} from '@backstage/core-plugin-api';
import { AuthProxyDiscoveryApi } from '@backstage/core-app-api';
import { ProxiedSignInPage } from '@backstage/core-components';
import {
  githubAuthApiRef,
  gitlabAuthApiRef,
  googleAuthApiRef,
  microsoftAuthApiRef,
  oktaAuthApiRef,
} from '@backstage/core-plugin-api';

export const apis: AnyApiFactory[] = [
  createApiFactory({
    api: scmIntegrationsApiRef,
    deps: { configApi: configApiRef },
    factory: ({ configApi }) => ScmIntegrationsApi.fromConfig(configApi),
  }),
  createApiFactory({
    api: discoveryApiRef,
    deps: { configApi: configApiRef, fetchApi: fetchApiRef },
    factory: ({ configApi, fetchApi }) =>
      AuthProxyDiscoveryApi.fromConfig(configApi, { fetchApi }),
  }),
  createApiFactory({
    api: githubAuthApiRef,
    deps: {},
    factory: () =>
      ProxiedSignInPage.create({
        id: 'github-auth-provider',
        title: 'GitHub',
        helperText: 'Sign in using GitHub',
        scope: 'read:user',
      }),
  }),
  createApiFactory({
    api: gitlabAuthApiRef,
    deps: {},
    factory: () =>
      ProxiedSignInPage.create({
        id: 'gitlab-auth-provider',
        title: 'GitLab',
        helperText: 'Sign in using GitLab',
        scope: 'read_user',
      }),
  }),
  createApiFactory({
    api: googleAuthApiRef,
    deps: {},
    factory: () =>
      ProxiedSignInPage.create({
        id: 'google-auth-provider',
        title: 'Google',
        helperText: 'Sign in using Google',
        scope: 'openid email profile',
      }),
  }),
  createApiFactory({
    api: microsoftAuthApiRef,
    deps: {},
    factory: () =>
      ProxiedSignInPage.create({
        id: 'microsoft-auth-provider',
        title: 'Microsoft',
        helperText: 'Sign in using Microsoft',
        scope: 'openid email profile',
      }),
  }),
  createApiFactory({
    api: oktaAuthApiRef,
    deps: {},
    factory: () =>
      ProxiedSignInPage.create({
        id: 'okta-auth-provider',
        title: 'Okta',
        helperText: 'Sign in using Okta',
        scope: 'openid email profile',
      }),
  }),
];
