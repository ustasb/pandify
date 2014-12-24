FROM rails:onbuild

ENV RAILS_ENV=production

RUN rake assets:precompile

VOLUME /usr/src/app/

ENTRYPOINT ["bin/deploy"]
