import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/if_dark.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/presentation/bloc/get_podcasts_cubit.dart';
import 'package:spotify/presentation/bloc/get_podcasts_state.dart';
import 'package:spotify/presentation/song_player/pages/podcast_player.dart';


class NewsPodcasts extends StatelessWidget {
  final Function(PodcastEntity) onPodcastSelected; // Thêm callback

  const NewsPodcasts({super.key, required this.onPodcastSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetPodcastCubit()..getPodcasts(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<GetPodcastCubit, GetPodcastsState>(
          builder: (context, state) {
            if (state is GetPodcastsLoading) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            if (state is GetPodcastsLoaded) {
              return _podcasts(state.podcasts);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _podcasts(List<PodcastEntity> podcasts) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onPodcastSelected(podcasts[index]); // Gọi callback khi chọn podcast
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => PodcastPlayer(
                  currentIndex: index,
                  podcasts: podcasts,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            '${AppURLs.podcaseCoverFirestorage}${podcasts[index].podcast} - ${podcasts[index].title}.jpg?${AppURLs.mediaAlt}',
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 40,
                          width: 40,
                          transform: Matrix4.translationValues(10, 10, 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.isDarkmode
                                ? AppColors.darkGreyText
                                : const Color(0xffE6E6E6),
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: context.isDarkmode
                                ? const Color(0xff959595)
                                : const Color(0xff555555),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    podcasts[index].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    podcasts[index].podcast,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 14),
      itemCount: podcasts.length,
    );
  }
}

