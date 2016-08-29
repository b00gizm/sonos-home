apiVersion: v1
kind: List
items:

- apiVersion: v1
  kind: Pod
  metadata:
    name: nginx
    labels:
      name: nginx
      project: sonos-home
      component: www
  spec:
    containers:
      - name: nginx
        image: "${DOCKER_PREFIX}/nginx"
        imagePullPolicy: IfNotPresent
        ports:
          - {containerPort: 80}
          - {containerPort: 443}
        readinessProbe:
          tcpSocket:
            port: 443
        volumeMounts:
          - name: http-basic
            mountPath: "/etc/http-basic"
            readOnly: true
    volumes:
      - name: http-basic
        secret:
          secretName: nginx-basic-secret

- apiVersion: v1
  kind: Service
  metadata:
    name: nginx
    labels:
      name: nginx
      project: sonos-home
  spec:
    ports:
    - name: http
      port: 80
      protocol: TCP
    - name: https
      port: 443
      protocol: TCP
    selector:
      name: nginx
      component: www
    externalIPs:
      - ${EXTERNAL_IP}

- apiVersion: v1
  kind: Pod
  metadata:
    name: sonos-http-api
    labels:
      name: sonos-http-api
      project: sonos-home
      component: api
  spec:
    hostNetwork: true
    containers:
      - name: sonos-http-api
        image: "${DOCKER_PREFIX}/sonos-http-api"
        imagePullPolicy: IfNotPresent
        ports:
          - {containerPort: 5005}
        readinessProbe:
          tcpSocket:
            port: 5005

- apiVersion: v1
  kind: Endpoints
  metadata:
    name: sonos-http-api
    labels:
      name: sonos-http-api
      project: sonos-home
  subsets:
    - addresses:
      - ip: ${EXTERNAL_IP}
      ports:
      - name: http
        port: 5005
        protocol: TCP

- apiVersion: v1
  kind: Service
  metadata:
    name: sonos-http-api
    labels:
      name: sonos-http-api
      project: sonos-home
  spec:
    ports:
    - name: http
      port: 80
      targetPort: 5005
      protocol: TCP

- apiVersion: v1
  kind: Secret
  metadata:
    name: nginx-basic-secret
    labels:
      name: nginx-basic-secret
      project: sonos-home
  type: Opaque
  data:
    api-user: $(echo "${NGINX_BASIC_AUTH_USER}:${NGINX_BASIC_AUTH_PASS}" | base64)

